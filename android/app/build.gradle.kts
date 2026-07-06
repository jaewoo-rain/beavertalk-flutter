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
        // flutter_sound's startPlayerFromStream (PCM stream playback) requires
        // Android API 29+ ("Need SDK 29"); pin the floor explicitly.
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
