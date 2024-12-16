#!/bin/bash
sudo docker build -t rockpi5-android12-builder --progress=plain --build-arg USER_ID=`id -u` --build-arg GROUP_ID=`id -g` .