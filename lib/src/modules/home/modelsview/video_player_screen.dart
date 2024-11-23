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
  bool _showControls = true;

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

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _toggleFullScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          controller: _controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Altura fixa para evitar infinito
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: _toggleControlsVisibility,
            child: AspectRatio(
              aspectRatio: _controller.value.isInitialized
                  ? _controller.value.aspectRatio
                  : 16 / 9,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
          if (_showControls)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow,
                          color: _isPlaying ? Colors.grey : Colors.white,
                        ),
                        onPressed: _playPauseVideo,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.pause,
                          color: !_isPlaying ? Colors.grey : Colors.white,
                        ),
                        onPressed: _playPauseVideo,
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
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControlsVisibility,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            widget.controller.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: VideoPlayer(widget.controller),
                    ),
                  )
                : const CircularProgressIndicator(),
            if (_showControls)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: widget.controller.value.isPlaying
                                ? Colors.grey
                                : Colors.white,
                          ),
                          onPressed: () => setState(() {
                            widget.controller.play();
                          }),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.pause,
                            color: widget.controller.value.isPlaying
                                ? Colors.white
                                : Colors.grey,
                          ),
                          onPressed: () => setState(() {
                            widget.controller.pause();
                          }),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
