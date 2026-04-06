## Flutter & Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

## Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

## Google Sign-In
-keep class com.google.android.gms.auth.** { *; }

## Image compression
-keep class com.luck.picture.lib.** { *; }

## Speech to text
-keep class com.csdcorp.speech_to_text.** { *; }

## General
-keep class **.R$* { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-dontwarn kotlin.**
-dontwarn kotlinx.**

## Play Core (deferred components / split install)
-dontwarn com.google.android.play.core.**
