import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReproductorScreen extends StatefulWidget {
  final String urlVideo;

  const ReproductorScreen({super.key, required this.urlVideo});

  @override
  State<ReproductorScreen> createState() => _ReproductorScreenState();
}

class _ReproductorScreenState extends State<ReproductorScreen> {
  VideoPlayerController? _controller;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(covariant ReproductorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 🔁 SI CAMBIA EL VIDEO, REINICIAMOS
    if (oldWidget.urlVideo != widget.urlVideo) {
      _disposeController();
      _initVideo();
    }
  }

  void _initVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.urlVideo),
      );

      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void _disposeController() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproductor de Video')),
      body: Center(
        child: _error
            ? const Text(
                'Error al cargar el video',
                style: TextStyle(color: Colors.red),
              )
            : _controller != null && _controller!.value.isInitialized
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller!.value.isPlaying
                                    ? _controller!.pause()
                                    : _controller!.play();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: () {
                              _controller!.pause();
                              _controller!.seekTo(Duration.zero);
                            },
                          ),
                        ],
                      )
                    ],
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
