import 'package:flutter/material.dart';
import 'package:louvor_bethel/common/custom_drawer.dart';
import 'package:pdf_flutter/pdf_flutter.dart';

class PdfFlutterPage extends StatefulWidget {
  @override
  _PDFListBodyState createState() => _PDFListBodyState();
}

class _PDFListBodyState extends State<PdfFlutterPage>
    with WidgetsBindingObserver {
  double screenWidth;
  Widget pdf;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pdf = PDF.network(
      'https://5f60ae01-5578-4b0a-9d87-c9ff7d7ca71a.filesusr.com/ugd/fa5e8a_5073d0240559445ba3e54a4967dee5d0.pdf',
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    pdf = Container(
      width: MediaQuery.of(context).size.height,
      child: pdf,
    );
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SafeArea(
        child: pdf,
      ),
    );
  }
}
