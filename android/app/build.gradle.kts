import java.io.FileInputStream
import java.util.Properties

// 업로드 키스토어 설정. `android/key.properties` 는 저장소에 들어가지 않는다
// (`android/.gitignore` + 루트 `.gitignore` 이중으로 막는다).
//
// ⚠ 키스토어와 비밀번호를 잃으면 **앱 업데이트가 영구 불가**하다. 첫 업로드
//    전에 이 PC 밖에 백업할 것.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}
val hasUploadKeystore = keystorePropertiesFile.exists()

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // FCM/Firebase: android/app/google-services.json을 읽어 빌드에 주입한다
    // (Firebase.initializeApp()가 옵션 없이 자동 설정을 찾도록). 버전은 settings.gradle.kts에서 관리.
    id("com.google.gms.google-services")
}

android {
    namespace = "im.beavertalk.beavertalk"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications 18.x는 코어 라이브러리 디슈가링을 요구한다.
        // 없으면 Android 빌드가 깨진다(java.time 등 최신 API 백포트).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "im.beavertalk.beavertalk"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // flutter_sound 9.30 only needs minSdk 24 (recorder floor); the app never
        // calls startPlayerFromStream (the only API-29 path), so 29 was overly
        // conservative. Lowered to 26 so Android-8+ devices (e.g. the API-28
        // Galaxy S8 QA device) can install; the Pronunciation Challenge STT still
        // needs API 30 (vosk) and degrades to tap below that.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasUploadKeystore) {
                storeFile = keystoreProperties["storeFile"]?.let { rootProject.file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // 키스토어가 있으면 업로드 키로 서명한다.
            //
            // 없으면 디버그 키로 떨어진다 — `flutter run --release` 같은 로컬
            // 확인을 막지 않기 위해서다. ⚠ 그 산출물은 **Play 에 올릴 수 없다**
            // (업로드 자체가 거부된다). 그래서 조용히 넘어가지 않고 경고를 찍는다.
            signingConfig = if (hasUploadKeystore) {
                signingConfigs.getByName("release")
            } else {
                logger.warn(
                    "[signing] android/key.properties 가 없어 릴리스를 디버그 키로 서명합니다. " +
                    "이 산출물은 Play 업로드가 거부됩니다."
                )
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 코어 라이브러리 디슈가링 런타임(flutter_local_notifications 18.x 요구).
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
