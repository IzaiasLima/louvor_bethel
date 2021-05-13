import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';

class JKHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<JKHomePage> {
  bool _isLoading = true;
  PDFDocument document;
  String title = "Loading";

  final url =
      'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    setState(() {
      _isLoading = true;
      title = "Loading";
    });
    document = await PDFDocument.fromURL(url);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(
                        document: document,
                        zoomSteps: 1,
                        lazyLoad: false,
                        scrollDirection: Axis.vertical,

                        //uncomment below code to replace bottom navigation with your own
                        /* navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage()(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                          },
                        ),
                      ],
                    );
                  }, */
                      ))));
  }
}
