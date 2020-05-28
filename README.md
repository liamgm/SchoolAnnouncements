# SchoolAnnouncements
## A project for supporting a live-streamed news-cast style school announcments show (or any other live stream to a small, intranet audience).

This repository is for Windows computers.

## Two options exist in this project:

- h.264 video, AAC audio, in a MPEG2-Transport Stream container delivered to VLC
- VP8 video, Vorbis audio, in a webm container delivered to FireFox

## Explanation of Repository Contents

This repository does not include VLC which you can download for free from [VideoLAN](https://www.videolan.org/vlc/index.html).

This repository does contain slightly modified versions of Icecast and OBS-Studio as described below, and a pair of basic profiles to get you started with the two streaming options.

The modifications to IceCast here are minimal: two Normal Mount points are defined in the icecast.xml file and the status.xsl file makes it easier to play the live stream.

The modifications to OBS are more substantial. There are problems with the FFMpeg builds that ship with OBS that causes problems with WEBM. [Thanks to Alan from a OBS Forum](https://obsproject.com/forum/threads/issue-with-vp8-encoding-need-help.80835/), who recognized that the problem was introduced after version 4.1.4.

This distribution of OBS is based on the 25.0.8 release, but uses the [4.1.4 shared build of FFMPeg](https://ffmpeg.zeranoe.com/builds/win64/shared/ffmpeg-4.1.4-win64-shared.zip).

That problem will not occur on an operating system other than Windows, where OBS can record WebM using FFMpeg just fine out of the box in my testing. If you don't want to use WebM/Firefox, you don't need this customization and can use your existing OBS installation to stream h.264/aac. In that case, you'll just need IceCast and [the MPEG2TS profile that you can download and import on its own.](https://github.com/liamgm/SchoolAnnouncements/raw/master/OBS_Profiles/MPEG2TS/basic.ini)

This version of OBS also has the [Virtual Camera plugin](https://obsproject.com/forum/resources/obs-virtualcam.949/) pre-installed so that you can use the output of OBS to send to remote reporters via WebRTC, over <https://talky.io>, for example, and capture the video coming back for use in the broadcast.

## Instructions for Use

1. Download this repository and save it to your computer

2. Start IceCast and OBS by clicking the StartAnnouncements.bat file

3. Bring in a video source and audio source and transition that scene to the program output

4. Click Record to begin piping the output to FFMpeg which then streams to IceCast

5. Open the URL printed to the window that launched with the bat file to see the video and share it with other people within your intranet

6. Click on the M3U button at the right of the row for the /announcements.ts mount point and open the file with VLC

7. To try WebM, click the Profiles menu and select WEBM, then start recording. On the media server's webpage (port 8000 on your computer), click the /announcements.webm link to open the video in the browser.

## Low Latency

In this setup, the main way to reduce latency is by setting a low Keyframe interval in the advanced video recording menu since the primary source of latency is the buffer on the client that typically waits to fill with 2 keyframes before it'll start playing. The provided profiles set them to 24fps for h.264/aac, so one keyframe per second; and one every two seconds for VP8.

Icecast has a Burst-size parameter for streams that is analogous to segment length in newer streaming protocols. By default, Icecast uses a burst-size of a little over 64kb, which is less than the amount of data between two keyframes: lowering the burst-size from default thus does not improve latency by any significant amount.

On very old and slow hardware, I typically see 3-5 seconds of latency with this setup; on a newer computer, I see latency of 2 seconds, which is a dramatic improvement.