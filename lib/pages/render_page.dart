import 'package:flutter/material.dart';

import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:louvor_bethel/models/worship.dart';

class RenderPage extends StatefulWidget {
  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  final Worship adoracao = Worship.adoracao();

  final ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  Widget build(BuildContext context) {
    // final Size screen = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => _toggleScrolling(),
          ),
          _circleAvatar(adoracao.userAvatar)
        ],
        titleSpacing: 0.0,
        title: Text('LOUVOR BETHEL'),
      ),
      body: Container(),
      // PDF.network(
      //   'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf',
      //   height: screen.height,
      //   width: screen.width,
      // ),
    );
  }

  bool scroll = false;
  int speedFactor = 80;

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  _scroll() {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;

    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: durationDouble.toInt()),
        curve: Curves.linear);
  }

  Widget _circleAvatar(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CircleAvatar(
        radius: 22.0,
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}
