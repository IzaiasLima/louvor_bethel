import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:simple_pdf_viewer/simple_pdf_viewer.dart';

class SimplePdfPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SimplePdfPage> {
  final url =
      'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SimplePdfViewerWidget(
          completeCallback: (bool result) {
            print("completeCallback,result:$result");
          },
          initialUrl: url,
        ),
      ),
    );
  }
}
