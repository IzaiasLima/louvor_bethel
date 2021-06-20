import 'package:flutter/material.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'package:louvor_bethel/src/routes/route_args.dart';

class VideoPlay extends StatefulWidget {
  static const routeName = 'video';

  const VideoPlay({Key key}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteArgs;
    _controller = YoutubePlayerController(
      initialVideoId: _getVideoId(args.strParam),
      params: YoutubePlayerParams(
        startAt: Duration(seconds: 0),
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: YoutubePlayerIFrame(
              controller: _controller,
              aspectRatio: 16 / 9,
            ),
          ),
        ),
      ),
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

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
