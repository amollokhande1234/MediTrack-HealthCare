plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.meditrack"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" 

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
        // coreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // defaultConfig {
    //     // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    //     applicationId = "com.example.meditrack"
    //     // You can update the following values to match your application needs.
    //     // For more information, see: https://flutter.dev/to/review-gradle-config.
    //     minSdkVersion flutter.minSdkVersion ? 
    //     targetSdk = flutter.targetSdkVersion
    //     versionCode = flutter.versionCode
    //     versionName = flutter.versionName
    // }

    defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.meditrack"

    // You can update the following values to match your application needs.
    // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = (flutter.minSdkVersion ?: 23)
        minSdk = 23
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName  = flutter.versionName
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
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-core:21.1.1") // optional but good
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  
}
