import 'package:flutter/material.dart';
import 'package:louvor_bethel/ui/drawer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ScrollController _scrollController;
  double speed = 50;
  SfPdfViewer pdf;
  bool isStoped = true;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    // String file = '/assets/AoErguermosAsMaos2.pdf';
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            right: 20,
            bottom: 8,
            child: FloatingActionButton(
              mini: true,
              child: Icon(isStoped ? Icons.play_arrow : Icons.pause,
                  size: 30, color: Colors.white),
              onPressed: () => setState(() => isStoped = !isStoped),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 80,
              child: Slider(
                value: speed,
                min: 1.0,
                max: 100.0,
                divisions: 99,
                onChanged: (value) {
                  setState(() {
                    speed = value;
                    print(speed);
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.topLeft,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: SfPdfViewer.network(
                url,
                key: _pdfViewerKey,
                initialScrollOffset: Offset.zero,
                canShowPaginationDialog: false,
                canShowScrollHead: false,
                canShowScrollStatus: false,
                interactionMode: PdfInteractionMode.pan,
                pageSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
