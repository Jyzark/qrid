import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQRResultScreen extends StatefulWidget {
  const GenerateQRResultScreen({Key? key}) : super(key: key);

  @override
  State<GenerateQRResultScreen> createState() => _GenerateQRResultScreenState();
}

class _GenerateQRResultScreenState extends State<GenerateQRResultScreen> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String typeName = args['typeName'];
    final String qrData = args['qrData'];
    var resultRawTextField = TextEditingController(text: qrData);

    IconData typeIcon() {
      if (typeName == 'Contact') {
        return Icons.account_circle_outlined;
      } else if (typeName == 'Email') {
        return Icons.alternate_email;
      } else if (typeName == 'Phone') {
        return Icons.phone_outlined;
      } else if (typeName == 'SMS') {
        return Icons.sms_outlined;
      } else if (typeName == 'Text') {
        return Icons.notes;
      } else if (typeName == 'Link') {
        return Icons.link;
      } else if (typeName == 'Wi-Fi') {
        return Icons.wifi;
      } else if (typeName == 'Location') {
        return Icons.place_outlined;
      } else if (typeName == 'Event') {
        return Icons.emoji_events_outlined;
      } else if (typeName == 'MeCard') {
        return Icons.qr_code_2;
      } else {
        return Icons.help_outline;
      }
    }

    Future<File> exportAsImage() async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 4.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      String tempPath = (await getTemporaryDirectory()).path;
      String fileDateTime = DateFormat('HHmmss-ddMMyyyy').format(
        DateTime.now(),
      );
      File imageFile =
          await File('$tempPath/qr-${typeName.toLowerCase()}-$fileDateTime.png')
              .create();
      return imageFile.writeAsBytes(pngBytes);
    }

    void saveToGallery() async {
      exportAsImage().then((value) async {
        await GallerySaver.saveImage(value.path, albumName: 'QRID');
      }).catchError((onError) {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Result',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/select-qr-type'));
          },
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 235, 235),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Type',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        typeIcon(),
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        typeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 235, 235, 235),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: qrData,
                      gapless: true,
                      padding: const EdgeInsets.all(30),
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              minLines: 1,
              maxLines: 10,
              readOnly: true,
              controller: resultRawTextField,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              saveToGallery();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.horizontal,
                  content: const Text('Saved to Gallery'),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: const Text('Save to Gallery'),
          ),
        ),
      ),
    );
  }
}
