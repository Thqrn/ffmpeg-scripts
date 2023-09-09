# What is this?
This is a collection of batch script's I've made or am still making. Most (if not all) require FFmpeg, meaning you'll need that to use them. They all use drag and drop and are designed for use with send-to. If you need any help, add me on discord, Frost#5872, or join my server, https://discord.gg/9tRZ6C7tYz.

*This readme hasn't been updated in a while so take most of the information with a grain of salt.*

Scripts with more niche uses can be found in the folder labled "niche".

# Audio Channel Splitter
Splits each audio channel in a file into its own separate file.

# Audio Combiner
Combines audio files into a single file, with support for individual volume adjustment and videos.

# Audio Replacer
Allows you to replace the audio in a video using audio from another file.

# Metadata
Extracts whatever (basic) metadata FFmpeg can find from a file.

# Properties
Grabs the video/audio format, resolution, framerate, duration, and (optionally) the frame count from all input videos and lists them.

# Video GIF Converter
Converts videos to gifs.

Note: quality will likely be poor and filesizes will be large. This is because gifs are a terrible format. Just host the video on a site like streamable, gifycat, or tenor if you want decent quality.

# Video Interpolater
Shitty video interpolation.

# Video Frame Extractor
Extracts a frame from videos. Note that frames start at 0, so the second frame in the video is 1, the third is 2, and so on.
Example: ![](https://i.ibb.co/pLjqC3q/image.jpg)

# Video mp4 Converter
Remuxes or reencodes videos to the mp4 container. Uses H.264 and AAC for compatability.

# Video Resampler
Uses tmix to blend the frames of a video together to create a lower framerate video.

# Video Speeed Changer
Changes the speed of a video, and can also change the framerate (ex: you might not want to have a 600 fps video if you speed it up 10x).

# Video Text Adder
Essentially a basic meme generator. Allows a user to add top text and bottom text.

# Video Trimmer
Simple and lossless video/audio trimmer. Should work with any media files.

# Video Upscaler
Upscale a video to higher resolutions, with tons of scaling algorithms. Designed for use before uploading to YouTube.