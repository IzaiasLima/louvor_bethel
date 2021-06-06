import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/route_args.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({Key key}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _getVideoId('url'),
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteArgs;
    _controller.cue(_getVideoId(args.strParam));

    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }

  String _getVideoId(String url) {
    String uri = 'https://youtu.be/';
    try {
      return (url.startsWith(uri)) ? (url.split(uri))[1] : null;
    } catch (_) {
      return null;
    }
  }
}
