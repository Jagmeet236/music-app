plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.jagmeet.client"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // ✅ Required for multidex support on older APIs
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.jagmeet.client"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // ✅ Needed when app grows large (ExoPlayer + Flutter easily exceed 64k methods)
        multiDexEnabled = true
    }

    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")

            // ✅ Enable R8 shrinking WITH our safe rules
            // This was the ROOT CAUSE — release was shrinking ExoPlayer classes
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // ✅ Prevents ExoPlayer / Media3 version conflicts across plugins
    configurations.all {
        resolutionStrategy {
            force("androidx.media3:media3-exoplayer:1.3.1")
            force("androidx.media3:media3-session:1.3.1")
            force("androidx.media3:media3-ui:1.3.1")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Multidex support
    implementation("androidx.multidex:multidex:2.0.1")
    // ✅ Required for isCoreLibraryDesugaringEnabled = true
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}