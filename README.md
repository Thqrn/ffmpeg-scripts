# What is this?
This is a collection of batch script's I've made or am still making. Most (if not all) require FFmpeg, meaning you'll need that to use them. They all use drag and drop and are designed for use with send-to. If you need any help, add me on discord, Frost#5872, or join my server, https://discord.gg/9tRZ6C7tYz.

*This readme hasn't been updated in a while so take most of the information with a grain of salt.*

Scripts with more niche uses can be found in the folder labled "niche".

# Add Text
Essentially a basic meme generator. Allows a user to add top text and bottom text.

# Artifact Hunter
Randomly zooms in and crops a random part of a random frame from a video and exports it as an image.

# Audio Sync
Tries to sync audio with a video. By default, the program finds a version of the input file not ending in ` - blur` as I use it for that program, but that can be easily changed. If no file is found automatically, it will ask for one.

# Audio Channel Splitter
Splits each audio channel in a file into its own separate file.

# Audio Combiner
Combines audio files into a single file, with support for individual volume adjustment and videos.

# Change FPS
Changes the framerate of a video.

# Change Speed
Changes the speed of a video, and can also change the framerate (ex: you might not want to have a 600 fps video if you speed it up 10x).

# Compare Multiple
Horizontally stacks videos together for comparisons. Requires at least 2 inputs but can take many more.

# Covert to gif
Converts videos to gifs.

Note: quality will likely be poor and filesizes will be large. This is because gifs are a terrible format. Just host the video on a site like streamable, gifycat, or tenor if you want decent quality.

# Convert to mp4
Remuxes or reencodes videos to the mp4 container. Uses H.264 and AAC for compatability.

# Extract Frame
Extracts a frame from videos. Note that frames start at 0, so the second frame in the video is 1, the third is 2, and so on.

# Interpolater
Interpolates a video. This was designed to give extremely terrible looking videos with lots of artifacts, so don't expect anything good.

# Metadata
Extracts whatever (basic) metadata FFmpeg can find from a file.

# Properties
Grabs the video/audio format, resolution, framerate, duration, and (optionally) the frame count from all input videos and lists them.
Example: ![](https://i.ibb.co/pLjqC3q/image.jpg)

# Replace Audio
Allows you to replace the audio in a video using audio from another file.

# Resample Video
Uses tmix to blend the frames of a video together to create a lower framerate video.

# Trimmer
Simple and lossless video/audio trimmer. Should work with any media files.

# Upscale NN
Scales a file with nearest neighbor. This works with images, videos, gifs, etc. It's planned to add more algorithms in the future.

# WebM Scaling
Makes a WebM file with a variable resolution, creating an "bouncing" effect.