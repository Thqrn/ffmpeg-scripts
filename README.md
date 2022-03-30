# What is this?
This is a collection of batch script's I've made or am still making. Most rely on FFmpeg, you'll need that to run them. They all use drag and drop features, which means you can also use them in send-to. If you need any help add me on discord, Frost#5872, or join my server, https://discord.gg/9tRZ6C7tYz

# Change Speed
Uses ffmpeg to change the speed of a video file. Also changes audio speed without changing pitch. Allows you to also trim the video.

# Interpolater
Interpolates a video. Allows you to select the input fps and output. If the video is above the input fps, it changes the input fps to the desired input fps. Then the video is interpolated to the output. Yes, this explanation sucks, but it's a simple program.

Please note that this script will not make your videos look good. It is designed to create artifacts.

# Replace Audio and Replace Audio Fast
Replaces the audio of an input video. Replace audio allows you to trim the video and select a start time for the added audio. Replace Audio Fast just allows you to replace the audio.

These scripts are slightly buggy and do not always propvide high quality outputs.

# Blur Auto Audio Fix
For use with https://github.com/f0e/blur

Blur has an issue for me where it slightly slows down the output video so audio is ever so slightly off sync. This script tries to fix that. When you send a file to it, it will try to find the original, noon-blur file and match the audio with the output from blur. Does not support automatic finding if you use detailed filenames, but the script itself does still work (you just have to drag in the original video manually).
