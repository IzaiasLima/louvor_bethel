import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:louvor_bethel/models/worship.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewPage extends StatefulWidget {
  PDFViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  final Worship adoracao = Worship.adoracao();

  String urlPDFPath = '';
  bool exists = true;
  bool pdfReady = false;
  bool loaded = false;
  // int _totalPages = 0;
  // int _currentPage = 0;
  PDFViewController _pdfViewController;

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
    if (_scrollController.hasClients) {
      double maxExtent = _scrollController.position.maxScrollExtent;
      double distanceDifference = maxExtent - _scrollController.offset;
      double durationDouble = distanceDifference / speedFactor;

      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: durationDouble.toInt()),
          curve: Curves.linear);
    }
  }

  Future<String> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var dir = await getApplicationDocumentsDirectory();
      String file = '${dir.path}/' + fileName + '.pdf';
      var dio = Dio();
      await dio.download(url, file);
      // var bytes = data.bodyBytes;
      // print(dir.path);
      // File urlFile = await file.writeAsBytes(data);
      return file;
    } catch (e) {
      print(e);
      throw Exception('Error opening url file');
    }
  }

  @override
  void initState() {
    // requestPersmission();
    getFileFromUrl(
            'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf',
            name: 'temporario')
        .then(
      (value) => {
        setState(() {
          if (value != null) {
            urlPDFPath = value;
            loaded = true;
            exists = true;
          } else {
            exists = false;
          }
        })
      },
    );
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scroll());
    final screen = MediaQuery.of(context).size;
    final aspect = MediaQuery.of(context).devicePixelRatio;

    print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.play_arrow),
        //       onPressed: () => _toggleScrolling(),
        //     ),
        //     _circleAvatar(adoracao.userAvatar)
        //   ],
        //   titleSpacing: 0.0,
        //   title: Text('LOUVOR BETHEL'),
        // ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: Container(
              height: screen.height * 0.9,
              width: screen.width * 0.9,
              child: PDFView(
                filePath: urlPDFPath,
                autoSpacing: false,
                enableSwipe: true,
                swipeHorizontal: false,
                fitEachPage: true,
                fitPolicy: FitPolicy.WIDTH,
                nightMode: false,
                onError: (e) {
                  //Show some error message or UI
                },
                onRender: (_pages) {
                  setState(() {
                    //_totalPages = _pages;
                    pdfReady = true;
                  });
                },
                onViewCreated: (PDFViewController vc) {
                  setState(() {
                    _pdfViewController = vc;
                  });
                },

                // onPageChanged: (int page, int total) {
                //   setState(() {
                //     _currentPage = page;
                //   });
                // },
                onPageError: (page, e) {},
              ),
            ),
          ),
        ),
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.chevron_left),
        //       iconSize: 50,
        //       color: Colors.black,
        //       onPressed: () {
        //         setState(() {
        //           if (_currentPage > 0) {
        //             _currentPage--;
        //             _pdfViewController.setPage(_currentPage);
        //           }
        //         });
        //       },
        //     ),
        //     Text(
        //       '${_currentPage + 1}/$_totalPages',
        //       style: TextStyle(color: Colors.black, fontSize: 20),
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.chevron_right),
        //       iconSize: 50,
        //       color: Colors.black,
        //       onPressed: () {
        //         setState(() {
        //           if (_currentPage < _totalPages - 1) {
        //             _currentPage++;
        //             _pdfViewController.setPage(_currentPage);
        //           }
        //         });
        //       },
        //     ),
        //   ],
        // ),
      );
    } else {
      if (exists) {
        //Replace with your loading UI
        return Scaffold(
          appBar: AppBar(
            title: Text('Demo'),
          ),
          body: Text(
            'Loading..',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        //Replace Error UI
        return Scaffold(
          appBar: AppBar(
            title: Text('Demo'),
          ),
          body: Text(
            'PDF Not Available',
            style: TextStyle(fontSize: 20),
          ),
        );
      }
    }
  }
}
