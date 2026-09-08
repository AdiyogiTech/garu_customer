import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ProductVideoWidget extends StatefulWidget {
  final String videoUrl;
  final String? learnMoreUrl;

  const ProductVideoWidget({
    super.key,
    required this.videoUrl,
    this.learnMoreUrl,
  });

  @override
  State<ProductVideoWidget> createState() => _ProductVideoWidgetState();
}

class _ProductVideoWidgetState extends State<ProductVideoWidget> {
  late VideoPlayerController videoController;

  bool isInitialized = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await videoController.initialize();

    setState(() {
      isInitialized = true;
    });
  }

  Future<void> _openLearnMore() async {
    final url = widget.learnMoreUrl?.trim();

    if (url == null || url.isEmpty) {
      return;
    }

    final Uri uri = Uri.parse(url);

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("Could not open URL: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open this link"),
        ),
      );
    }
  }

  void _openFullScreenVideo() {
    if (!isInitialized) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideoPage(
          controller: videoController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*if (!isInitialized) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }*/

    final bool showLearnMore = widget.learnMoreUrl != null &&
        widget.learnMoreUrl!.trim().isNotEmpty &&
        widget.learnMoreUrl!.trim().toLowerCase() != 'null';

    // Video loading
    if (!isInitialized && !hasError) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Video error
    if (hasError) {
      return Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Center(
          child: Text(
            "Video could not be loaded",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            // aspectRatio: videoController.value.aspectRatio,
            aspectRatio: 16 / 9,
            child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                    width: videoController.value.size.width,
                    height: videoController.value.size.height,
                    child: VideoPlayer(videoController))),
          ),
          GestureDetector(
            onTap: () {
              if (videoController.value.isPlaying) {
                videoController.pause();
              } else {
                videoController.play();
              }
              setState(() {});
            },
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: videoController.value.isPlaying ? 0 : 1,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black54,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ================= LEARN MORE =================
                if (showLearnMore)
                  GestureDetector(
                    onTap: _openLearnMore,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff4CAF50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Learn more",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Gap only when Learn More exists
                if (showLearnMore) const SizedBox(width: 6),

                // ================= FULLSCREEN =================
                Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _openFullScreenVideo,
                    child: const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPage({
    super.key,
    required this.controller,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  @override
  void initState() {
    super.initState();

    // Automatically play when fullscreen opens
    widget.controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(widget.controller),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
                    }
                  });
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black54,
                  child: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }
}
