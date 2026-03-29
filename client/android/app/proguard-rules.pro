# ─── Flutter ──────────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.**

# ─── just_audio / ExoPlayer (Media3) ─────────────────────────────────────────
# Keep all ExoPlayer classes — R8 strips these in release causing error (2)
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keepclassmembers class com.google.android.exoplayer2.** { *; }

# Keep Media3 (newer ExoPlayer namespace)
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**
-keepclassmembers class androidx.media3.** { *; }

# ─── audio_session ────────────────────────────────────────────────────────────
-keep class com.ryanheise.** { *; }
-dontwarn com.ryanheise.**

# ─── audio_waveforms ──────────────────────────────────────────────────────────
-keep class com.simform.audio_waveforms.** { *; }
-dontwarn com.simform.audio_waveforms.**

# ─── Kotlin coroutines (used internally by just_audio) ────────────────────────
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# ─── General Android / Jetpack ────────────────────────────────────────────────
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**
-keep class androidx.core.app.CoreComponentFactory { *; }

# ─── Prevent stripping of native methods ──────────────────────────────────────
-keepclasseswithmembernames class * {
    native <methods>;
}