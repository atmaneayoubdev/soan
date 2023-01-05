import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:soan/models/global/invoice_model.dart';

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        },
      ),
    );
    return pdf.save();
  }

  // Future<void> savePdfFile(String fileName, Uint8List byteList) async {
  //   final output = await getTemporaryDirectory();
  //   var filePath = "${output.path}/$fileName.pdf";
  //   final file = File(filePath);
  //   await file.writeAsBytes(byteList);
  //   await OpenDocument.openDocument(filePath: filePath);
  // }

  static Future<File> generate(InvoiceModel invoice) async {
    final pdf = pw.Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Widget buildHeader(InvoiceModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSupplierAddress(invoice),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice),
              buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(InvoiceModel invoiceModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${invoiceModel.customer.firstName} ${invoiceModel.customer.lastName}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("+${invoiceModel.customer.phoneNumber}"),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceModel invoice) {
    DateTime dt = DateTime.parse(invoice.createdAt);
    String formattedDate = DateFormat.yMMMEd().format(dt);

    final titles = <String>[
      'Order Id:',
      'Invoice Date:',
    ];
    final data = <String>[
      invoice.id,
      formattedDate,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(InvoiceModel invoiceModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoiceModel.provider.providerName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(invoiceModel.locaiton.locationName,
              style: const pw.TextStyle(fontSize: 12),
              textDirection: pw.TextDirection.rtl),
        ],
      );

  static Widget buildTitle(InvoiceModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          //Text('this is a description'),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(InvoiceModel invoice) {
    final headers = ['Description', 'Unit Price', 'VAT', 'Total'];
    final data = invoice.invoiceItems.map((item) {
      double itemPrice = double.parse(item.price);
      double subTotal = double.parse(invoice.prices.subTotal);
      double vat = double.parse(invoice.prices.vat);
      double percentVat = (vat * 100) / subTotal;
      final total = ((percentVat * itemPrice) / 100) + itemPrice;

      return [
        item.name,
        '\$ $itemPrice',
        '$percentVat %',
        '\$ ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(InvoiceModel invoice) {
    double total = double.parse(invoice.prices.total);
    double subTotal = double.parse(invoice.prices.subTotal);
    double vat = double.parse(invoice.prices.vat);
    int percent = (vat * 100) ~/ subTotal;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: subTotal.toStringAsFixed(2),
                  unite: true,
                ),
                buildText(
                  title: 'Vat $percent %',
                  value: vat.toStringAsFixed(2),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: total.toStringAsFixed(2),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(InvoiceModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address', value: invoice.locaiton.addressName),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
