import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewPage extends StatefulWidget {
  PDFViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PDFViewPageState createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  String urlPDFPath = '';
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController _pdfViewController;
  bool loaded = false;

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

  // void requestPersmission() async {
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  // }

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

  @override
  Widget build(BuildContext context) {
    print(urlPDFPath);
    if (loaded) {
      return Scaffold(
        body: PDFView(
          filePath: urlPDFPath,
          autoSpacing: false,
          enableSwipe: true,
          pageFling: true,
          pageSnap: true,
          swipeHorizontal: false,
          fitEachPage: true,
          fitPolicy: FitPolicy.WIDTH,
          nightMode: false,
          onError: (e) {
            //Show some error message or UI
          },
          onRender: (_pages) {
            setState(() {
              _totalPages = _pages;
              pdfReady = true;
            });
          },
          onViewCreated: (PDFViewController vc) {
            setState(() {
              _pdfViewController = vc;
            });
          },
          onPageChanged: (int page, int total) {
            setState(() {
              _currentPage = page;
            });
          },
          onPageError: (page, e) {},
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
