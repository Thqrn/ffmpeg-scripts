# What is this?
This is a collection of batch script's I've made or am still making. Most (if not all) require FFmpeg, meaning you'll need that to use them. They all use drag and drop and are designed for use with send-to. If you need any help, add me on discord, Frost#5872, or join my server, https://discord.gg/9tRZ6C7tYz.

# Add Text
Essentially a meme generator. Allows a user to add top text and bottom text.

# Audio Sync
Syncs audio with a video. By default, the program finds a version of the input file not ending in ` - blur` as I use it for that program, but that can be easily changed. If no file is found automatically, it will ask for one.

# Change FPS
Changes the fps of a video.

# Change Speed
Changes the speed of a video.

# Compare Multiple
Horizontally stacks videos together for comparisons. Requires at least 2 inputs but can take more.

# Covert to gif
Converts videos to gifs.

# Convert to mp4
Remuxes or reencodes videos to the mp4 container.

# Extract Frame
Extracts a frame from videos. Note that frames start at 0, so the second frame in the video is 1, the third is 2, and so on.

# Interpolater
Interpolates a video. This was designed to give extremely terrible looking videos with lots of artifacts.

# Mask Blur
Masks a video made with https://github.com/f0e/blur, covering artifacts. Designed for Minecraft. This is just proof of concept, and **is not made to look good**.

# Metadata
Extracts whatever metadata FFmpeg can find from a file.

# Properties
Grabs the video/audio format, resolution, framerate, duration, and (optionally) the frame count from all input videos and lists them.
Example: ![](https://i.ibb.co/pLjqC3q/image.jpg)

# Replace Audio
Allows you to replace the audio in a video with audio from another source.

# Upscale NN
Scales a file with nearest neighbor. This works with images, videos, gifs, etc. It's planned to add more algorithms in the future.