#!/bin/bash

echo "🚀 Cleaning up older containers..."
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null

echo "📱 Starting ReDroid with Software Rendering & Lock Bypass..."
# We pass explicit configurations to strip out standard hardware rendering and unlock constraints
docker run -d --privileged \
  --name=redroid \
  -p 5555:5555 \
  redroid/redroid:11.0.0-latest \
  androidboot.redroid.width=450 \
  androidboot.redroid.height=850 \
  androidboot.redroid.gpu.mode=guest \
  ro.setupwizard.mode=DISABLED \
  ro.lockscreen.disable.default=true \
  persist.sys.disable_screen_lock=true

echo "⏳ Waiting 12 seconds for the software display rendering matrix to settle..."
sleep 12

echo "🌐 Launching the ws-scrcpy Web UI..."
docker run -d \
  --name=scrcpy-web \
  --link redroid:redroid \
  -p 7860:8000 \
  lucasbento/ws-scrcpy:latest

echo "✅ Optimization applied! Re-verify port 7860."
