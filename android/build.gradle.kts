allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// vosk_flutter_2 (1.0.5) predates AGP 8: its android/build.gradle declares no
// `namespace`, so AGP 8.11's LibraryVariantBuilder fails to configure the module
// ("Namespace not specified"). Inject it from the plugin's legacy manifest
// `package` value. Reflection avoids putting the AGP types on the root Kotlin DSL
// script classpath. This is a build-config shim only — no plugin source changes.
subprojects {
    // `:app` already declares a namespace and is force-evaluated early by the
    // evaluationDependsOn above, so registering an afterEvaluate on it throws
    // ("already evaluated"). Only the third-party plugin modules need the shim.
    if (project.name == "app") return@subprojects
    afterEvaluate {
        val androidExt = extensions.findByName("android") ?: return@afterEvaluate
        val getNamespace = androidExt.javaClass.methods.firstOrNull {
            it.name == "getNamespace" && it.parameterCount == 0
        } ?: return@afterEvaluate
        val current = getNamespace.invoke(androidExt) as? String
        if (current == null) {
            val ns = project.group.toString().ifBlank { "org.vosk.vosk_flutter" }
            androidExt.javaClass.methods.firstOrNull {
                it.name == "setNamespace" && it.parameterCount == 1
            }?.invoke(androidExt, ns)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
