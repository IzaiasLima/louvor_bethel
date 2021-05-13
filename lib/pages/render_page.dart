import 'package:flutter/material.dart';

import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:louvor_bethel/models/worship.dart';
import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';

// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
// import 'package:pdf_flutter/pdf_flutter.dart';

class RenderPage extends StatefulWidget {
  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  final Worship adoracao = Worship.adoracao();
  bool _isLoading = true;
  PDFDocument document;
  String title = "Loading";

  final ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
    loadDocument(0);
  }

  loadDocument(value) async {
    setState(() {
      _isLoading = true;
      title = "Loading";
    });
    if (value == 1) {
      document = await PDFDocument.fromURL(
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf");
    } else {
      document = await PDFDocument.fromAsset('assets/sample.pdf');
    }
    setState(() {
      title = (value == 1) ? "Loaded From Url" : "Loaded From Assets";
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final url =
        'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';

    final Size screen = MediaQuery.of(context).size;
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
      body: Container(
        height: screen.height * 0.5,
        width: screen.width * 0.5,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
                document: document,
                zoomSteps: 1,
              ),
      ),
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
