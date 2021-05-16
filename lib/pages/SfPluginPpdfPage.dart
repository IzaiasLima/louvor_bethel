import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:async';

/// Represents Homepage for Navigation
class SfPluginPdfPage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<SfPluginPdfPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController pdfViewerController;
  SfPdfViewer pdf;
  Stopwatch timeController;
  Timer timer;
  bool isStoped = true;
  double speed = 50;

  @override
  void initState() {
    super.initState();
    pdfViewerController = PdfViewerController();
    timeController = Stopwatch();
  }

  @override
  void dispose() {
    timeController.stop();
    timeController = null;
    timer.cancel();
    timer = null;
    pdfViewerController = null;
    pdf = null;
    super.dispose();
  }

  playOrPause() {
    if (isStoped) {
      play();
    } else {
      pause();
    }
    setState(() {
      isStoped = !isStoped;
    });
  }

  play() {
    double duration = 110 - speed;
    timeController.start();
    timer = Timer.periodic(Duration(milliseconds: duration.toInt()), scroolPdf);
  }

  pause() {
    timeController.stop();
    timer.cancel();
  }

  scroolPdf(_) {
    if (timeController.isRunning) {
      double scrollOffset = pdfViewerController.scrollOffset.dy;

      setState(() {
        pdfViewerController.jumpTo(
          yOffset: pdfViewerController.scrollOffset.dy + 1,
        );
        if (scrollOffset == pdfViewerController.scrollOffset.dy) {
          isStoped = true;
          pause();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String url;
    url =
        // 'https://www.singing-bell.com/wp-content/uploads/2021/01/Baby-Bumblebee_Lyrics_pdf.pdf';

        url =
            'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';

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
              onPressed: () => playOrPause(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SfPdfViewer.network(
          url,
          key: _pdfViewerKey,
          initialScrollOffset: Offset.zero,
          controller: pdfViewerController,
          canShowPaginationDialog: false,
          canShowScrollHead: false,
          canShowScrollStatus: true,
          interactionMode: PdfInteractionMode.pan,
          pageSpacing: 0.0,
        ),
      ),
    );
  }
}
