import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:postos/src/modules/home/home_controller.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  const FullScreenVideoPlayer({super.key});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  final _controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    _controller.videoController.addListener(
      () {
        if (mounted) {
          setState(() {}); // Atualizar a interface ao mudar o progresso
        }
      },
    );
  }

  void _toggleControlsVisibility() {
    _controller.showControls = !_controller.showControls;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<HomeController>();
    // Retomar reprodução se necessário
    if (_controller.wasPlaying) controller.videoController.play();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: AspectRatio(
              aspectRatio: controller.videoController.value.aspectRatio,
              child: VideoPlayer(controller.videoController),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildProgressBar(controller.videoController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (controller.videoController.value.isPlaying) {
                              controller.videoController.pause();
                            } else {
                              controller.videoController.play();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _controller.wasPlaying =
                                _controller.videoController.value.isPlaying;
                            Modular.to.pushNamed('youtube');
                          },
                        ),
                      ],
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

  Widget _buildProgressBar(VideoPlayerController videoController) {
    final duration = videoController.value.duration;
    final position = videoController.value.position;

    return Row(
      children: [
        Text(
          _formatDuration(position),
          style: const TextStyle(color: Colors.white),
        ),
        Expanded(
          child: Slider(
            value: position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            onChanged: (value) {
              videoController.seekTo(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.red,
            inactiveColor: Colors.white,
          ),
        ),
        Text(
          _formatDuration(duration),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
