import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:video_player/video_player.dart';
import '../home_controller.dart';
import 'template_page.dart';

class VideoPlayerYouTubeStyleScreen extends StatefulWidget {
  const VideoPlayerYouTubeStyleScreen({super.key});

  @override
  State<VideoPlayerYouTubeStyleScreen> createState() =>
      _VideoPlayerYouTubeStyleScreenState();
}

class _VideoPlayerYouTubeStyleScreenState
    extends State<VideoPlayerYouTubeStyleScreen> {
  final _controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    _controller.videoController
      ..addListener(() {
        if (mounted) {
          setState(() {}); // Atualiza o progresso e estado
        }
      })
      ..initialize().then((_) {
        if (mounted) {
          setState(() {}); // Atualiza após inicialização
        }
      });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controller.showControls = !_controller.showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.isFullScreem
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: _buildScreen()),
          )
        : TemplatePage(
            hasProx: null,
            isLeading: true,
            answerLenght: 1,
            header: const Text(
              'Informações:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                height: 1.5,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
              ),
            ),
            itens: (_, __) => [
              const Text(
                textAlign: TextAlign.justify,
                'Aqui você pode fazer a diferença! Veja como é simples.',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              SizedBox(
                height: 400,
                child: _buildScreen(),
              ),
              const Text(
                textAlign: TextAlign.justify,
                '\nAgora que você já entendeu como usar, volte à página inicial e proporcione alegria a uma das famílias assistidas.',
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ],
          );
  }

  Widget _buildScreen() {
    if (_controller.isChange) {
      _controller.isChange = false;
      if (_controller.wasPlaying) {
        _controller.wasPlaying = false;
        _controller.videoController.play();
      }
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: _toggleControlsVisibility,
          child: AspectRatio(
            aspectRatio: _controller.videoController.value.isInitialized
                ? _controller.videoController.value.aspectRatio
                : 16 / 9,
            child: _controller.videoController.value.isInitialized
                ? VideoPlayer(_controller.videoController)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
        if (_controller.showControls)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildVideoControls(),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _controller.videoController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.videoController.value.isPlaying) {
                      _controller.videoController.pause();
                    } else {
                      _controller.videoController.play();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _controller.isFullScreem
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: () {
                  _controller.wasPlaying =
                      _controller.videoController.value.isPlaying;
                  _controller.isChange = true;
                  _controller.isFullScreem = !_controller.isFullScreem;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final duration = _controller.videoController.value.duration;
    final position = _controller.videoController.value.position;

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
              _controller.videoController
                  .seekTo(Duration(seconds: value.toInt()));
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

  @override
  void dispose() {
    _controller.videoController.dispose();
    super.dispose();
  }
}
