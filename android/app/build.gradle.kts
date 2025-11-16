import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come after Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nonigopalchandro.app.calculation"
    compileSdk = 35   // ✅ update from flutter.compileSdkVersion or 34
    ndkVersion = "27.0.12077973"  // ✅ update NDK version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.nonigopalchandro.app.calculation"
        minSdk = 21
        targetSdk = 35   // ✅ update to 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // 🔑 Signing config (reads from key.properties)
    signingConfigs {
        create("release") {
            val keystoreProperties = Properties()
            val keystoreFile = rootProject.file("key.properties")
            if (keystoreFile.exists()) {
                keystoreProperties.load(FileInputStream(keystoreFile))
            }

            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false  // ✅ disable resource shrinking
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false  // ✅ disable in debug too
        }
    }
}

flutter {
    source = "../.."
}
