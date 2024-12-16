#!/bin/bash

# 환경 변수 설정
source build/envsetup.sh

# 빌드 설정
lunch RadxaRock5A-userdebug
# git config --global --add safe.directory /rock-android12/kernel-5.10

# 빌드 시작
./build.sh -UCKAu userdebug