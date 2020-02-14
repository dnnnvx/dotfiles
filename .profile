#export JAVA_HOME=/usr/lib/jvm/jdk-12.0.1
#export PATH=${PATH}:${JAVA_HOME}/bin

# Android SDK
export ANDROID_HOME=/usr/local/src/android/Sdk
export PATH=${PATH}:${ANDROID_HOME}

# Android NDK
#export ANDROID_NDK=/usr/local/src/android/android-ndk-r18b
export ANDROID_NDK=/usr/local/src/android/Sdk/ndk-bundle
export PATH=${PATH}:${ANDROID_NDK}

# Android Studio
export PATH=${PATH}:/usr/local/src/android/android-studio/bin/studio.sh
export _JAVA_AWT_WM_NONREPARENTING=1

# Gradle
#export PATH=${PATH}:/opt/gradle/gradle-5.4.1/bin

# Flutter
export PATH=${PATH}:/usr/local/lib/flutter/bin

# Maven
#export PATH=${PATH}:/usr/local/maven/apache-maven-3.6.1/bin

# Go
export PATH=${PATH}:/usr/local/lib/go/bin:$HOME/go/bin

# Blender
export PATH=${PATH}:/usr/local/src/blender

# X11 utils
# export $(dbus-launch)
