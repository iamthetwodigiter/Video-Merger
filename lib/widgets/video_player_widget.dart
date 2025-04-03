import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final videoPlayerController =
          VideoPlayerController.file(File(widget.videoPath));

      await videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        aspectRatio: 9 / 16,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
        ),
      );

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.position ==
            videoPlayerController.value.duration) {
          videoPlayerController.pause();
        }
      });

      setState(() {
        _chewieController?.play();
      });
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    return Chewie(controller: _chewieController!);
  }
}
