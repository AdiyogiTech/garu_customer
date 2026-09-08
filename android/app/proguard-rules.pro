# Flutter
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Video Player
-keep class io.flutter.plugins.videoplayer.** { *; }
-keep class com.google.android.exoplayer2.** { *; }

# WebView
-keep class io.flutter.plugins.webviewflutter.** { *; }

# Prevent stripping annotations
-keepattributes *Annotation*
