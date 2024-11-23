import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerYouTubeStyleScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerYouTubeStyleScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerYouTubeStyleScreen> createState() =>
      _VideoPlayerYouTubeStyleScreenState();
}

class _VideoPlayerYouTubeStyleScreenState
    extends State<VideoPlayerYouTubeStyleScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _playPauseVideo() {
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

  void _stopVideo() {
    setState(() {
      _controller.pause();
      _controller.seekTo(Duration.zero);
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Envolva o Expanded com um Container para definir restrições de tamanho
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6, // 60% da tela
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        // Controles do vídeo
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: _isPlaying ? Colors.grey : Colors.white,
                ),
                onPressed: _isPlaying ? null : _playPauseVideo,
              ),
              IconButton(
                icon: Icon(
                  Icons.pause,
                  color: !_isPlaying ? Colors.grey : Colors.white,
                ),
                onPressed: !_isPlaying ? null : _playPauseVideo,
              ),
              IconButton(
                icon: const Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                onPressed: _stopVideo,
              ),
              IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: Colors.white,
                ),
                onPressed: () {
                  _controller.seekTo(Duration.zero);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
