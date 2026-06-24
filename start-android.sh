#!/bin/bash

echo "🚀 Spinning down any older running containers..."
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null

echo "📱 Starting ReDroid (Android 11 Core)..."
docker run -d --privileged \
  --name=redroid \
  -p 5555:5555 \
  redroid/redroid:11.0.0-latest \
  androidboot.redroid.width=450 \
  androidboot.redroid.height=850 \
  androidboot.redroid.gpu.mode=guest

echo "⏳ Waiting 10 seconds for the Android OS components to boot..."
sleep 10

echo "🌐 Launching the ws-scrcpy Web Streaming Controller..."
docker run -d \
  --name=scrcpy-web \
  --link redroid:redroid \
  -p 7860:8000 \
  lucasbento/ws-scrcpy:latest

echo "✅ Android is up! Ready for Port Forwarding on port 7860."
