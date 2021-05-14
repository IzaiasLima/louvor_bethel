import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class ViewPluginPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ViewPluginPage> {
  String path;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/teste.pdf';
  }

  Future<bool> _existsFile() async {
    var filePath = await _localPath;
    final file = File(filePath);
    return file.exists();
  }

  _fetchPost() async {
    var filePath = await _localPath;
    final String url =
        'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf';
    Dio().download(url, filePath);
  }

  void _loadPdf() async {
    await _fetchPost();
    await _existsFile();
    path = await _localPath;

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            if (path != null)
              Container(
                height: 300.0,
                child: PdfView(
                  path: path,
                ),
              )
            else
              Text("Pdf is not Loaded"),
            ElevatedButton(
              child: Text("Load pdf"),
              onPressed: _loadPdf,
            ),
          ],
        ),
      ),
    );
  }
}
