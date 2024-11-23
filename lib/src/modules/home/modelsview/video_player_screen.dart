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
  bool _isFullScreen = false;

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

  void _toggleFullScreen(BuildContext context) {
    if (_isFullScreen) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FullScreenVideoPlayer(controller: _controller);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Vídeo
        Container(
          height: MediaQuery.of(context).size.height * 0.6, // 60% da altura da tela
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        // Controles
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
                  Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: () => _toggleFullScreen(context),
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

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Sai do fullscreen ao toque
      },
      child: Container(
        color: Colors.black,
        child: Center(
          child: controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
