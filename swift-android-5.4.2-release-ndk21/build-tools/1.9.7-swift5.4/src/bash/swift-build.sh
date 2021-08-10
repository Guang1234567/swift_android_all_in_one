#!/bin/bash

export SWIFT_ANDROID_ARCH=${SWIFT_ANDROID_ARCH:-"aarch64"}
SWIFT_ANDROID_API=${SWIFT_ANDROID_API:-23}

echo -e "
######################## Swift-Android-Toolchain ########################

Compile Start

$@

SWIFT_ANDROID_ARCH  =   $SWIFT_ANDROID_ARCH
SWIFT_ANDROID_API   =   $SWIFT_ANDROID_API

#########################################################################
"

# 5.2.2
#export TOOLCHAINS=org.swift.522202004151a
# 5.2.3
#export TOOLCHAINS=org.swift.523202004281a

: "${SWIFT_ANDROID_HOME:?$SWIFT_ANDROID_HOME should be set}"
: "${ANDROID_NDK_HOME:?$ANDROID_NDK_HOME should be set}"

SELF_DIR=$(dirname $0)
SELF_DIR=$SELF_DIR/src/bash

xcode_toolchain=$(dirname $(dirname $(dirname $(xcrun --find swift))))

export CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang"
export CXX="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++"

# swiftc dont know about CC/CXX so tell correct compiler path for him in more brutal way
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"

export SWIFT_EXEC=$SWIFT_ANDROID_HOME/toolchain/usr/bin/swiftc
export SWIFT_EXEC_MANIFEST=$xcode_toolchain/usr/bin/swiftc
export SWIFTPM_PD_LIBS=$xcode_toolchain/usr/lib/swift/pm

if [ ! -n "${SWIFT_ANDROID_ARCH+defined}" ] || [ "$SWIFT_ANDROID_ARCH" == "aarch64" ]
then
    export TARGET=aarch64-unknown-linux-android
    export TRIPLE=aarch64-linux-android
    export ARCH=arm64
    export ABI=arm64-v8a
    export TOOLCHAIN_ROOT=aarch64-linux-android
elif [ "$SWIFT_ANDROID_ARCH" == "x86_64" ]
then
    export TARGET=x86_64-unknown-linux-android
    export TRIPLE=x86_64-linux-android
    export ARCH=x86_64
    export ABI=x86_64
    export TOOLCHAIN_ROOT=x86_64
elif [ "$SWIFT_ANDROID_ARCH" == "armv7" ]
then
    export TARGET=armv7-unknown-linux-androideabi
    export TRIPLE=arm-linux-androideabi
    export ARCH=arm
    export ABI=armeabi-v7a
    export TOOLCHAIN_ROOT=arm-linux-androideabi
elif [ "$SWIFT_ANDROID_ARCH" == "i686" ]
then
    export TARGET=i686-unknown-linux-android
    export TRIPLE=i686-linux-android
    export ARCH=x86
    export ABI=x86
    export TOOLCHAIN_ROOT=x86
else
    echo "Unknown arch '$SWIFT_ANDROID_ARCH'"
    exit 1
fi

include=-I.build/jniLibs/include
libs=-L.build/jniLibs/$ABI

flags="-Xcc $include -Xswiftc $include -Xswiftc $libs"
flags+=" -Xlinker $libs"
flags+=" -Xcc -D__ANDROID__"
flags+=" -Xcc -D__linux__"
flags+=" -Xcc -D__ANDROID_API_N__=24 -Xcc -D__ANDROID_API_M__=23 -Xcc -D__ANDROID_API__=$SWIFT_ANDROID_API"
flags+=" -Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
flags+=" -Xcc -D__SWIFT_ANDROID_API__=$SWIFT_ANDROID_API"
# flags+=" -Xcc -DTARGET_OS_LINUX=1 -Xcc -DTARGET_OS_ANDROID=1"
# https://stackoverflow.com/questions/8115192/android-ndk-getting-the-backtrace
flags+=" -Xcc -funwind-tables"
#flags+=" -Xswiftc -sdk -Xswiftc /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
flags+=" -Xswiftc -sdk -Xswiftc $SWIFT_ANDROID_HOME/toolchain"

$SWIFT_ANDROID_HOME/toolchain/usr/bin/swift-build --destination=<($SELF_DIR/generate-destination-json.sh) $flags "$@"

echo -e "
######################## Swift-Android-Toolchain ########################

$SWIFT_ANDROID_HOME/toolchain/usr/bin/swift-build --destination=<($SELF_DIR/generate-destination-json.sh) $flags "$@"

Compile End

#########################################################################
"

exit $?
