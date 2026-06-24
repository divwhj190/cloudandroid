#!/bin/bash

echo "🚀 Spinning down and wiping legacy containers..."
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null

echo "📱 Starting ReDroid (Android 11 Machine Layer)..."
# We boot Android with explicit parameters forcing custom software layouts
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

echo "⏳ Giving the Android core framework 12 seconds to stabilize..."
sleep 12

echo "⚡ Deploying huonwe/webscreen over WebRTC..."
# We connect directly to the active ADB loop on port 5555 and map the web server out to 7860
docker run -d \
  --name=webscreen \
  --link redroid:redroid \
  -p 7860:8000 \
  huonwe/webscreen:latest \
  --adb-server redroid:5555

echo "✅ WebRTC Streaming Stack Is Live! Adjusting Ports..."
