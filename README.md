# Swift-Android-Toolchains

Only for >= MacOS 10.14.x,

Not working on Windows && Linux Host!!!

## English

The `toolchains` that provide the ability to develop `android ndk program` by using `Swift` language.

## Chinese

使用 Swift (>= 5.3) 去进行 Android 的 NDK 开发, 此项目就是为了此目的提供 `交叉编译链`.

## Dependency

- ndk 21.3.6528147
- android studio 4.1

## Sample for Android studio

```bash
git clone https://github.com/Guang1234567/swift-android-architecture.git
```

set

```properies
swift-android.dir=/Users/XXX/dev_kit/sdk/swift_source/swift-android-5.3.1-release-ndk21
```

in `local.properies` file.

## Sample for Commeand Line

```bash
git clone https://github.com/Guang1234567/swift-nio-ssl.git
```

cd your swift project, then type :

```bash
#1
export SWIFT_ANDROID_HOME=$HOME/dev_kit/sdk/swift_source/swift-android-5.3.1-release-ndk21

#2
export SWIFT_ANDROID_ARCH=aarch64

#3
${SWIFT_ANDROID_HOME}/build-tools/1.9.6-swift5/swift-build --configuration debug -Xswiftc -DDEBUG -Xswiftc -g -v
```
