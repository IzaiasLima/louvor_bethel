import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:async';

class PdfViewPage extends StatefulWidget {
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  // PdfViewerController pdfViewerController;
  SfPdfViewer pdf;
  Stopwatch timeController;
  Timer timer;
  bool isStoped = true;
  double speed = 50;

  @override
  void initState() {
    super.initState();
    // pdfViewerController = PdfViewerController();
    timeController = Stopwatch();
  }

  @override
  void dispose() {
    timeController.stop();
    timeController = null;
    // pdfViewerController = null;
    pdf = null;
    super.dispose();
  }

  play() {
    if (_scrollController.hasClients) {
      if (isStoped) {
        _scrollController.animateTo(_scrollController.offset,
            duration: Duration(seconds: 1), curve: Curves.linear);
      } else {
        double maxExtent = _scrollController.position.maxScrollExtent;
        double distanceDifference = maxExtent - _scrollController.offset;
        double durationDouble = distanceDifference / speed;

        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(seconds: durationDouble.toInt()),
            curve: Curves.linear);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => play());
    String url =
        'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';

    String file = '/assets/AoErguermosAsMaos2.pdf';

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 20,
            bottom: 10,
            child: Slider(
              divisions: 99,
              value: speed,
              min: 1,
              max: 100,
              label: speed.round().toString(),
              onChanged: (value) => setState(() => speed = value),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 30,
            child: FloatingActionButton(
              mini: true,
              child: Icon(isStoped ? Icons.play_arrow : Icons.pause,
                  size: 30, color: Colors.white),
              onPressed: () => setState(() => isStoped = !isStoped),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SfPdfViewer.network(
            url,
            key: _pdfViewerKey,
            initialScrollOffset: Offset.zero,
            // controller: pdfViewerController,
            canShowPaginationDialog: false,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            interactionMode: PdfInteractionMode.pan,
            pageSpacing: 0.0,
          ),
        ),
      ),
    );
  }
}
