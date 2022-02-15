import 'package:rt_market/models/print_model.dart';
import 'package:rt_market/services/print_service.dart';

import '../../index.dart';

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrinterPage extends StatelessWidget {
  final List<Product> products;
  const PrinterPage({Key key, this.products}) : super(key: key);

  Future<Uint8List> generateInvoice(
      PdfPageFormat pageFormat, String title) async {
    final invoice = Invoice(
      products: products,
      tax: .0,
      baseColor: PdfColors.teal,
      accentColor: PdfColors.blueGrey900,
    );

    return await invoice.buildPdf(pageFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("printing")),
      body: PdfPreview(
        build: (format) => generateInvoice(format, "impression Facture"),
      ),
    );
  }
}
