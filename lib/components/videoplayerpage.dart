import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/constants.dart';
import 'package:limanplatform/dao/videoitem.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final videoitem video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize controller safely
    _controller = VideoPlayerController.asset(widget.video.videoPath)
      ..initialize()
          .then((_) {
            setState(() {
              _isInitialized = true;
            });
            _controller.play();
            _controller.setLooping(true);
            _isPlaying = true;
          })
          .catchError((error) {
            debugPrint("Video initialization error: $error");
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title.tr()),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: _isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: AnimatedOpacity(
                      opacity: _isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Constants.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Constants.background,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(color: Constants.background),
      ),
    );
  }
}
