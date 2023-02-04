import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:soan/models/global/invoice_model.dart';

class PdfInvoiceServiceAr {
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
                          'الفاتورة',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              font: ttf,
                              fontSize: 30,
                              fontWeight: pw.FontWeight.normal),
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
                            child: pw.Text('من',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                )),
                          ),
                        ),
                        pw.Container(
                          height: 25,
                          width: 220,
                          color: greyColor,
                          child: pw.Center(
                            child: pw.Text('الرقم الضریبي للمنشأة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                )),
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
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf),
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
                              'إلى',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf),
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
                                      'رقم الفاتورة',
                                      style: pw.TextStyle(font: ttf),
                                      textDirection: pw.TextDirection.rtl,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 25,
                                  width: 109,
                                  color: greyColor,
                                  child: pw.Center(
                                    child: pw.Text(
                                      'التاریخ',
                                      style: pw.TextStyle(font: ttf),
                                      textDirection: pw.TextDirection.rtl,
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
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(font: ttf),
                                  ),
                                ),
                                pw.SizedBox(
                                  width: 1,
                                ),
                                pw.Center(
                                  child: pw.Text(
                                    invoice.createdAt,
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(font: ttf),
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
                    1: const pw.FlexColumnWidth(1),
                    2: const pw.FlexColumnWidth(1),
                    3: const pw.FlexColumnWidth(2),
                    4: const pw.FlexColumnWidth(5),
                    5: const pw.FlexColumnWidth(1),
                  }, children: [
                    pw.TableRow(children: [
                      pw.Container(
                        height: 80,
                        margin: const pw.EdgeInsets.only(left: 1),
                        color: greyColor,
                        child: pw.Center(
                          child: pw.Text('الاجمالي',
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text(
                              'ضریبة القیمة\n\nالمضافة\n\nریال سعودي',
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text('ضریبة\n\nالقیمة\n\nالمضافة\n\nX',
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(font: ttf),
                              textAlign: pw.TextAlign.center),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text(
                            'السعر\n\nالإجمالي غیر\n\nشامل ضریبة\n\nالقیمة المضافة',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        margin: const pw.EdgeInsets.only(left: 1),
                        child: pw.Center(
                          child: pw.Text(
                            'الوصف',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                      ),
                      pw.Container(
                        height: 80,
                        color: greyColor,
                        child: pw.Center(
                          child: pw.Text(
                            'الرقم\nالتسلسلي',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                      ),
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
                            child: pw.Center(
                                child: pw.Text(
                                    '${double.parse(x.price) + (vat * double.parse(x.price) / 100)}',
                                    overflow: pw.TextOverflow.clip,
                                    style: const pw.TextStyle(fontSize: 12)))),
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
                                child: pw.Text(
                              x.name,
                              style: pw.TextStyle(font: ttf),
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
                            child: pw.Center(child: pw.Text(x.id))),
                      ]),
                  ]),
                  pw.SizedBox(height: 10),
                  pw.SizedBox(
                    height: 230,
                    child: pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Expanded(
                              flex: 1,
                              child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Align(
                                        alignment: pw.Alignment.centerLeft,
                                        child: pw.Container(
                                          width: 90,
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                  vertical: 5),
                                          color: greyColor,
                                          child: pw.Center(
                                            child: pw.Text('ریال سعودي',
                                                textDirection:
                                                    pw.TextDirection.rtl,
                                                style: pw.TextStyle(
                                                  font: ttf,
                                                  fontSize: 15,
                                                )),
                                          ),
                                        )),
                                    pw.SizedBox(height: 20),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            invoice.prices.subTotal,
                                          ),
                                          pw.Text(
                                              'الإجمالي غیر شامل ضریبة القیمة المضافة',
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(font: ttf)),
                                        ]),
                                    pw.SizedBox(height: 3),
                                    pw.Divider(),
                                    pw.SizedBox(height: 3),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('${vat.toStringAsFixed(0)} %',
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(font: ttf)),
                                          pw.Text('ضریبة القیمة المضافة',
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(font: ttf)),
                                        ]),
                                    pw.SizedBox(height: 3),
                                    pw.Divider(),
                                    pw.SizedBox(height: 3),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            invoice.prices.total,
                                          ),
                                          pw.Text(
                                              'المجموع شامل ضریبة القیمة المضافة',
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(font: ttf)),
                                        ]),
                                    pw.SizedBox(height: 3),
                                    pw.Divider(),
                                    pw.SizedBox(height: 3),
                                    pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text(
                                            invoice.prices.total,
                                          ),
                                          pw.Text('المبلغ المستحق',
                                              textDirection:
                                                  pw.TextDirection.rtl,
                                              style: pw.TextStyle(font: ttf)),
                                        ]),
                                    pw.SizedBox(height: 3),
                                    pw.Divider(),
                                  ]),
                            ),
                            pw.SizedBox(width: 20),
                            pw.Expanded(
                              flex: 1,
                              child: pw.Column(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Align(
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text('ملاحظات',
                                          textDirection: pw.TextDirection.rtl,
                                          style: pw.TextStyle(
                                            font: ttf,
                                            fontSize: 15,
                                          )),
                                    ),
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
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.end,
                                        children: [
                                          pw.Text(
                                            'تم اصدار ھذه الفاتورة\n\nوفق اتفاقیة استخدام تطبیق صون',
                                            textDirection: pw.TextDirection.rtl,
                                            overflow: pw.TextOverflow.clip,
                                            style: pw.TextStyle(
                                              fontSize: 15,
                                              font: ttf,
                                              decoration:
                                                  pw.TextDecoration.underline,
                                            ),
                                          ),
                                          pw.SizedBox(
                                            height: 60,
                                            width: 40,
                                            child: pw.Image(image2,
                                                fit: pw.BoxFit.fill),
                                          ),
                                        ]),
                                  ]),
                            ),
                          ]),
                      pw.SizedBox(height: 10),
                      pw.SizedBox(
                        height: 15,
                        child: pw.Expanded(
                          child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'www.soan-app.com             6374',
                                overflow: pw.TextOverflow.clip,
                                textDirection: pw.TextDirection.ltr,
                                style: pw.TextStyle(
                                  font: ttf,
                                ),
                              ),
                              pw.FittedBox(
                                  child: pw.Text(
                                'طریق الأمیر سلطان، وحدة:15، حي الخالدیة، الرمز البریدي 3799-23421، جدة، السعودیة ',
                                overflow: pw.TextOverflow.clip,
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                  font: ttf,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ])
          ]; // Center
        },
      ),
    );

    return saveDocument(name: 'invoice_${invoice.id}.pdf', pdf: pdf);
  }
}
