import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:soan/models/global/invoice_model.dart';

class PdfInvoiceServiceEn {
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

  static Future<File> generate(InvoiceModel invoice) async {
    final pdf = pw.Document();

    final font = await rootBundle.load("assets/arial.ttf");
    final ttf = pw.Font.ttf(font);
    final List dots = [1, 2, 3, 4];
    final greyColor = PdfColor.fromHex('#E0E0E0');
    final double vat = ((double.parse(invoice.prices.vat)) * 100) /
        double.parse(invoice.prices.subTotal);

    for (int i = 0; i < invoice.invoiceItems.length; i++) {
      invoice.invoiceItems[i].id = (i + 1).toString();
    }

    final imageByteData1 =
        await rootBundle.load('assets/images/invoice_image1.png');
    final imageUint8List1 = imageByteData1.buffer.asUint8List(
        imageByteData1.offsetInBytes, imageByteData1.lengthInBytes);
    final image1 = pw.MemoryImage(imageUint8List1);
    final imageByteData2 =
        await rootBundle.load('assets/images/invoice_image2.png');
    final imageUint8Listq = imageByteData2.buffer.asUint8List(
        imageByteData2.offsetInBytes, imageByteData2.lengthInBytes);
    final image2 = pw.MemoryImage(imageUint8Listq);
    log(pdf.document.pdfPageList.pages.length);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.ltr,
        margin:
            const pw.EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        build: (pw.Context context) {
          return [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    height: 50,
                    child: pw.Stack(children: [
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.SizedBox(
                          height: 40,
                          width: 50,
                          child: pw.Image(image1, fit: pw.BoxFit.fill),
                        ),
                      ),
                      pw.Align(
                        alignment: pw.Alignment.bottomCenter,
                        child: pw.Text(
                          'Invoice',
                          style: pw.TextStyle(
                              fontSize: 30, fontWeight: pw.FontWeight.normal),
                        ),
                      ),
                    ]),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          height: 25,
                          width: 220,
                          color: greyColor,
                          child: pw.Center(
                            child: pw.Text(
                              'From',
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 25,
                          width: 220,
                          color: greyColor,
                          child: pw.Center(
                            child: pw.Text(
                              'Facility VAT',
                            ),
                          ),
                        )
                      ]),
                  pw.SizedBox(height: 5),
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          invoice.provider.providerName,
                          style: pw.TextStyle(font: ttf),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Container(
                          //height: 20,
                          width: 220,
                          child: pw.Center(
                            child: pw.Text(
                              invoice.provider.taxNumber,
                            ),
                          ),
                        )
                      ]),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    invoice.provider.city.name,
                    style: pw.TextStyle(font: ttf),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Container(
                          height: 25,
                          width: 220,
                          color: greyColor,
                          child: pw.Center(
                            child: pw.Text(
                              'To',
                            ),
                          ),
                        ),
                        pw.Container(
                          height: 25,
                          width: 220,
                          child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceEvenly,
                              children: [
                                pw.Container(
                                  height: 25,
                                  width: 109,
                                  color: greyColor,
                                  child: pw.Center(
                                    child: pw.Text(
                                      'Invoice Nr',
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 25,
                                  width: 109,
                                  color: greyColor,
                                  child: pw.Center(
                                    child: pw.Text(
                                      'Date',
                                    ),
                                  ),
                                )
                              ]),
                        )
                      ]),
                  pw.SizedBox(height: 5),
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "${invoice.customer.firstName}  ${invoice.customer.lastName}",
                          style: pw.TextStyle(font: ttf),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.Container(
                          //height: 20,
                          width: 220,
                          child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Center(
                                  child: pw.Text(
                                    "#${invoice.id}",
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 1,
                                ),
                                pw.Center(
                                  child: pw.Text(
                                    invoice.createdAt,
                                    textDirection: pw.TextDirection.rtl,
                                  ),
                                )
                              ]),
                        )
                      ]),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    invoice.locaiton.city.name,
                    style: pw.TextStyle(font: ttf),
                    textDirection: pw.TextDirection.rtl,
                  ),
                  pw.SizedBox(height: 5),
                  pw.Table(columnWidths: {
                    0: const pw.FlexColumnWidth(1),
                    1: const pw.FlexColumnWidth(5),
                    2: const pw.FlexColumnWidth(2),
                    3: const pw.FlexColumnWidth(1),
                    4: const pw.FlexColumnWidth(1),
                    5: const pw.FlexColumnWidth(1),
                  }, children: [
                    pw.TableRow(children: [
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        child: pw.Center(
                          child: pw.Text('Serial\n\nNumber',
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text('Description',
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text('Total price\n\nwihout\n\nVAT',
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text('VAT\n\nX',
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text('VAT\n\nSAR',
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        margin: const pw.EdgeInsets.only(left: 1),
                        color: greyColor,
                        child: pw.Center(
                          child: pw.Text('Total\n\nPrice',
                              textAlign: pw.TextAlign.center),
                        ),
                      )
                    ]),
                    for (var x in invoice.invoiceItems)
                      pw.TableRow(children: [
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(child: pw.Text(x.id))),
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(
                                child: pw.Text(
                              x.name,
                              textDirection: pw.TextDirection.rtl,
                              maxLines: 2,
                              softWrap: true,
                              overflow: pw.TextOverflow.clip,
                            ))),
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(child: pw.Text(x.price))),
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(
                                child: pw.Text("${vat.toStringAsFixed(0)} %"))),
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(
                                child: pw.Text(
                                    '${vat * double.parse(x.price) / 100}'))),
                        pw.Container(
                            height: 35,
                            padding: const pw.EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: PdfColors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: pw.Center(
                                child: pw.Text(
                                    '${double.parse(x.price) + (vat * double.parse(x.price) / 100)}',
                                    overflow: pw.TextOverflow.clip,
                                    style: const pw.TextStyle(fontSize: 12)))),
                      ]),
                  ]),
                  pw.SizedBox(height: 10),
                  Footer(dots, image2, greyColor, invoice, vat),
                ])
          ]; // Center
        },
      ),
    );

    return saveDocument(name: 'invoice_${invoice.id}.pdf', pdf: pdf);
  }

  // ignore: non_constant_identifier_names
  static pw.SizedBox Footer(List<dynamic> dots, pw.MemoryImage image2,
      PdfColor greyColor, InvoiceModel invoice, double vat) {
    return pw.SizedBox(
      height: 220,
      child: pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
          pw.Expanded(
            flex: 1,
            child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text('Notes',
                        style: const pw.TextStyle(
                          fontSize: 15,
                        )),
                  ),
                  // ignore: unused_local_variable
                  for (var x in dots)
                    pw.Container(
                        height: 20,
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.black,
                            width: 1.0,
                            style: pw.BorderStyle.dotted,
                          ),
                        ))),
                  pw.SizedBox(height: 20),
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.SizedBox(
                          height: 60,
                          width: 40,
                          child: pw.Image(image2, fit: pw.BoxFit.fill),
                        ),
                        pw.Text(
                          'This in voice was issued in\naccordance with the agreement\nof use of SOAN app',
                          overflow: pw.TextOverflow.clip,
                          style: const pw.TextStyle(
                            fontSize: 15,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                      ]),
                ]),
          ),
          pw.SizedBox(width: 20),
          pw.Expanded(
            flex: 1,
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Container(
                        width: 90,
                        padding: const pw.EdgeInsets.symmetric(vertical: 5),
                        color: greyColor,
                        child: pw.Center(
                          child: pw.Text('SAR',
                              style: const pw.TextStyle(
                                fontSize: 15,
                              )),
                        ),
                      )),
                  pw.SizedBox(height: 20),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total price wihtout VAT',
                        ),
                        pw.Text(
                          invoice.prices.subTotal,
                        )
                      ]),
                  pw.SizedBox(height: 3),
                  pw.Divider(),
                  pw.SizedBox(height: 3),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'VAT',
                        ),
                        pw.Text(
                          '${vat.toStringAsFixed(0)} %',
                        )
                      ]),
                  pw.SizedBox(height: 3),
                  pw.Divider(),
                  pw.SizedBox(height: 3),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total prive with VAT',
                        ),
                        pw.Text(
                          invoice.prices.total,
                        )
                      ]),
                  pw.SizedBox(height: 3),
                  pw.Divider(),
                  pw.SizedBox(height: 3),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Invoice Total',
                        ),
                        pw.Text(
                          invoice.prices.total,
                        )
                      ]),
                  pw.SizedBox(height: 3),
                  pw.Divider(),
                ]),
          )
        ]),
        pw.SizedBox(height: 10),
        pw.SizedBox(
          height: 15,
          child: pw.Expanded(
            child: pw.FittedBox(
                child: pw.Text(
              'www.soan-app.com           |6374 Al Amir Sultan Road, Unit No.15, Al Khaldiyeh neighborhood, zip code 23421-3799, Jeddah, Saudi Arabia',
              overflow: pw.TextOverflow.clip,
              style: const pw.TextStyle(
                  //fontSize: 8.5,
                  ),
            )),
          ),
        ),
      ]),
    );
  }
}
