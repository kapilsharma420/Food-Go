# ── Flutter Core ──
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.android.FlutterFragment { *; }
-keep class io.flutter.embedding.android.FlutterView { *; }
-dontwarn io.flutter.**

# ── App MainActivity ──
-keep class com.kapil.foodgo.** { *; }
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends android.app.Activity { *; }
-keep class * extends android.app.Application { *; }
-keep class * extends android.app.Service { *; }
-keep class * extends android.content.BroadcastReceiver { *; }
-keep class * extends android.content.ContentProvider { *; }

# ── Firebase ──
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ── Razorpay ──
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/*
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# ── Kotlin ──
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**

# ── AndroidX ──
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# ── GetX ──
-keep class com.get.** { *; }
-dontwarn com.get.**

# ── Shared Preferences ──
-keep class androidx.datastore.** { *; }

# ── General ──
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keep public class * extends java.lang.Exception
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}