#!/bin/bash
while true; do
    ping -c 1 8.8.8.8 &> /dev/null || vlc /home/yeet/Music/The-Day-The-Routers-Died....mp3
    sleep 360
done
