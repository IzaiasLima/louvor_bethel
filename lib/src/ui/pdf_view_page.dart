import 'package:flutter/material.dart';
import 'package:louvor_bethel/src/models/lyric_model.dart';
import 'package:louvor_bethel/src/route_args.dart';
import 'package:louvor_bethel/src/ui/commons/app_bar.dart';
import 'package:louvor_bethel/src/ui/commons/drawer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// ignore: must_be_immutable
class PdfViewPage extends StatefulWidget {
  static const routeName = 'pdf';

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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as RouteObjectArgs;
    LyricModel lyric = args.objParam as LyricModel;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollPdf());

    return Scaffold(
      appBar: CustomAppBar(),
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
                lyric.pdfUrl,
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

  _scrollPdf() {
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
  void dispose() {
    _scrollController.dispose();
    pdf = null;
    super.dispose();
  }
}
