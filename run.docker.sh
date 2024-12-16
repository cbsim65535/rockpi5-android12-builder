#!/bin/bash

# 총 물리 메모리 확인 (단위: KB)
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')

# 총 스왑 메모리 확인 (단위: KB)
swap_mem=$(grep SwapTotal /proc/meminfo | awk '{print $2}')

# 두 메모리 합계 (단위: KB)
combined_mem=$((total_mem + swap_mem))

# 24GB를 KB로 변환 (24 * 1024 * 1024)
required_mem=$((24 * 1024 * 1024))

if [ "$combined_mem" -lt "$required_mem" ]; then
  echo "경고: 물리 메모리와 스왑 메모리의 합이 24GB 미만입니다!"
  echo "현재 메모리: $(echo "scale=2; $combined_mem/1024/1024" | bc) GB (물리: $(echo "scale=2; $total_mem/1024/1024" | bc) GB, 스왑: $(echo "scale=2; $swap_mem/1024/1024" | bc) GB)"
  echo "다음 중 하나를 수행하세요:"
  echo "1. 물리 메모리를 증설하십시오."
  echo "2. 스왑 메모리를 설정하거나 늘리십시오. 아래 명령을 참고하세요:"
  echo "   sudo fallocate -l 24G /swapfile"
  echo "   sudo chmod 600 /swapfile"
  echo "   sudo mkswap /swapfile"
  echo "   sudo swapon /swapfile"
  exit 1
else
  echo "메모리가 충분합니다. 총 메모리: $(echo "scale=2; $combined_mem/1024/1024" | bc) GB (물리: $(echo "scale=2; $total_mem/1024/1024" | bc) GB, 스왑: $(echo "scale=2; $swap_mem/1024/1024" | bc) GB)"
fi


# 디렉토리가 존재하는지 확인
if [ ! -d "output" ]; then
  echo "output 디렉토리가 존재하지 않으므로 생성합니다."
  mkdir output
else
  echo "output 디렉토리가 이미 존재합니다."
fi

# 실행
sudo docker run -it -v $(pwd)/output:/rock-android12/rockdev --memory=16g --memory-swap=32g --privileged rockpi5-android12-builder bash