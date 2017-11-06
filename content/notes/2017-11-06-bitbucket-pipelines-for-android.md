---
title: BitBucket Pipelines for Android
kind: note
created_at: 2017-11-06 21:20:12 +0200
---

BitBucket provides [build pipelines](https://bitbucket.org/product/features/pipelines) to automate the build process when you push
changes on your repository.
By default, it comes with a docker image made for Java which is not directly suitable
for Android builds.

There are some [alternative docker images](https://hub.docker.com/r/runmymind/docker-android-sdk/) to solve this but on my
experimentations, it was very long to download and setup the image. Due to build time restriction
of the BitBucket free plan, it was a blocker.

My approach is to download the Android SDK myself and use `caches` for it. The build with custom
docker image was about 8 minutes and is now 1'30".

`ci_install.sh`:

``` bash
#!/usr/bin/env bash

set -eu

cur_dir=$(cd "$(dirname "$0")"; pwd)
origin_dir=$(cd "${cur_dir}/.."; pwd)
app_dir="${origin_dir}/android"
output_dir="${origin_dir}/artifacts"

default_android_sdk_zip_version="3859397"
android_sdk_zip_version=${1:-${default_android_sdk_zip_version}}

case $(uname -s) in
  Linux)
    os="linux"
  ;;
  Darwin)
    os="darwin"
  ;;
  CYGWIN*|MINGW*)
    os="windows"
  ;;
  *)
    echo "!! Unsupported OS $(uname -s)"
    exit 1
  ;;
esac

export ANDROID_HOME="${origin_dir}/android-sdk-${os}"

if [ ! -f "${ANDROID_HOME}/tools/bin/sdkmanager" ]; then
  # Download and unzip Android sdk
  echo "Downloading Android SDK '${android_sdk_zip_version}' for '${os}'"
  wget "https://dl.google.com/android/repository/sdk-tools-${os}-${android_sdk_zip_version}.zip"
  unzip "sdk-tools-${os}-${android_sdk_zip_version}.zip" -d "${ANDROID_HOME}"
  rm "sdk-tools-${os}-${android_sdk_zip_version}.zip"
fi

# Add Android binaries to PATH
export PATH="${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# Accept all licenses (source: http://stackoverflow.com/questions/38096225/automatically-accept-all-sdk-licences)
echo "Auto Accepting licenses"
mkdir -p "$ANDROID_HOME/licenses"
echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_HOME}/licenses/android-sdk-license"
echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_HOME}/licenses/android-sdk-preview-license"

# Update android sdk
echo "Downloading packages described by ${cur_dir}/package_file.txt"
cat "${cur_dir}/package_file.txt"
( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | sdkmanager --package_file="${cur_dir}/package_file.txt"
```

`package_file.txt`

``` text
platform-tools
build-tools;26.0.2
platforms;android-26
```

`bitbucket-pipelines.yml`:

``` yaml
image: java:8

pipelines:
  branches:
    master:
      - step:
          caches:
            - gradle
            - android-sdk
          script:
            - bash ./build/ci_install.sh
            - ANDROID_HOME=$PWD/android-sdk-linux bash ./build/android.sh

definitions:
  caches:
    android-sdk: android-sdk-linux
```
