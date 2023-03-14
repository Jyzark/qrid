import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrid/controllers/scanned_history_controller.dart';
import 'package:qrid/widgets/result_action_buttons.dart';
import 'package:qrid/widgets/result_content_preview.dart';
import 'package:wakelock/wakelock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MobileScannerController cameraController = MobileScannerController(
    autoStart: true,
    formats: [BarcodeFormat.qrCode],
  );
  double _zoomFactor = 0.0;
  BarcodeCapture? capture;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    Wakelock.enable();
    var scannedHistoryController = ScannedHistoryController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/qrid_logo.png',
                  isAntiAlias: true,
                  fit: BoxFit.fill,
                  height: 56,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/select-qr-type');
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Generate QR'),
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
                ),
              ],
            ),
          ),
        ),
      ),
      extendBody: true,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: cameraController,
                errorBuilder: (context, error, child) {
                  return Center(
                    child: Text(error.toString()),
                  );
                },
                onDetect: (barcodes) {
                  if (capture?.barcodes.first.rawValue !=
                      barcodes.barcodes.first.rawValue) {
                    setState(() {
                      capture = barcodes;
                    });
                    Barcode scanResult = capture!.barcodes.first;
                    IconData typeIcon() {
                      if (scanResult.type == BarcodeType.contactInfo &&
                          !scanResult.rawValue!.contains('MECARD:')) {
                        return Icons.account_circle_outlined;
                      } else if (scanResult.type == BarcodeType.email) {
                        return Icons.alternate_email;
                      } else if (scanResult.type == BarcodeType.phone) {
                        return Icons.phone_outlined;
                      } else if (scanResult.type == BarcodeType.sms) {
                        return Icons.sms_outlined;
                      } else if (scanResult.type == BarcodeType.text) {
                        return Icons.notes;
                      } else if (scanResult.type == BarcodeType.url) {
                        return Icons.link;
                      } else if (scanResult.type == BarcodeType.wifi) {
                        return Icons.wifi;
                      } else if (scanResult.type == BarcodeType.geo) {
                        return Icons.place_outlined;
                      } else if (scanResult.type == BarcodeType.calendarEvent) {
                        return Icons.emoji_events_outlined;
                      } else if (scanResult.type == BarcodeType.contactInfo &&
                          scanResult.rawValue!.contains('MECARD:')) {
                        return Icons.qr_code_2;
                      } else {
                        return Icons.help_outline;
                      }
                    }

                    String resultType() {
                      if (scanResult.type == BarcodeType.contactInfo &&
                          !scanResult.rawValue!.contains('MECARD:')) {
                        return 'Contact';
                      } else if (scanResult.type == BarcodeType.email) {
                        return 'Email';
                      } else if (scanResult.type == BarcodeType.phone) {
                        return 'Phone';
                      } else if (scanResult.type == BarcodeType.sms) {
                        return 'SMS';
                      } else if (scanResult.type == BarcodeType.text) {
                        return 'Text';
                      } else if (scanResult.type == BarcodeType.url) {
                        return 'Link';
                      } else if (scanResult.type == BarcodeType.wifi) {
                        return 'Wi-Fi';
                      } else if (scanResult.type == BarcodeType.geo) {
                        return 'Location';
                      } else if (scanResult.type == BarcodeType.calendarEvent) {
                        return 'Event';
                      } else if (scanResult.type == BarcodeType.contactInfo &&
                          scanResult.rawValue!.contains('MECARD:')) {
                        return 'MeCard';
                      } else {
                        return 'Unknown';
                      }
                    }

                    String wifiResult() {
                      String? wifiSSID = scanResult.wifi!.ssid;
                      String? wifiPass = scanResult.wifi!.password;
                      String wifiType = scanResult.wifi!.encryptionType
                          .toString()
                          .replaceAll('EncryptionType.none', 'None')
                          .replaceAll('EncryptionType.open', 'Open')
                          .replaceAll('EncryptionType.wpa', 'WPA')
                          .replaceAll('EncryptionType.wep', 'WEP');
                      if (scanResult.wifi!.encryptionType ==
                              EncryptionType.wpa ||
                          scanResult.wifi!.encryptionType ==
                              EncryptionType.wep) {
                        return 'Name: $wifiSSID\n'
                            'Password: $wifiPass\n'
                            'Type: $wifiType';
                      } else {
                        return 'Name: $wifiSSID\n'
                            'Type: $wifiType';
                      }
                    }

                    String geoResult() {
                      return 'Latitude: ${scanResult.geoPoint!.latitude}\n'
                          'Longitude: ${scanResult.geoPoint!.longitude}';
                    }

                    String resultText() {
                      if (scanResult.type == BarcodeType.wifi) {
                        return wifiResult();
                      } else if (scanResult.type == BarcodeType.geo) {
                        return geoResult();
                      } else {
                        return '${scanResult.displayValue}';
                      }
                    }

                    var resultTextField = TextEditingController(
                      text: resultText(),
                    );
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Result'),
                          contentPadding: const EdgeInsets.all(20),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 235, 235, 235),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      typeIcon(),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      resultType(),
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ResultContentPreview(captureData: capture!),
                              TextField(
                                minLines: 1,
                                maxLines: 5,
                                readOnly: true,
                                controller: resultTextField,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(20),
                                ),
                              ),
                            ],
                          ),
                          actionsPadding:
                              const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          actions: [
                            ResultActionButtons(
                              captureData: capture!,
                              copyText: resultText(),
                            )
                          ],
                        );
                      },
                    );
                    scannedHistoryController.addHistory(
                      itemType: scanResult.type == BarcodeType.contactInfo &&
                              scanResult.rawValue!.contains('MECARD:')
                          ? 'MeCard'
                          : scanResult.type
                              .toString()
                              .replaceAll('BarcodeType.unknown', 'Unknown')
                              .replaceAll('BarcodeType.contactInfo', 'Contact')
                              .replaceAll('BarcodeType.email', 'Email')
                              .replaceAll('BarcodeType.phone', 'Phone')
                              .replaceAll('BarcodeType.sms', 'SMS')
                              .replaceAll('BarcodeType.text', 'Text')
                              .replaceAll('BarcodeType.url', 'Link')
                              .replaceAll('BarcodeType.wifi', 'Wi-Fi')
                              .replaceAll('BarcodeType.geo', 'Location')
                              .replaceAll('BarcodeType.calendarEvent', 'Event'),
                      itemTitle: resultText(),
                      itemRawData: scanResult.rawValue!,
                    );
                  }
                },
                scanWindow: Rect.fromLTWH(
                  MediaQuery.of(context).size.width / 6.5,
                  MediaQuery.of(context).size.height / 3.72,
                  MediaQuery.of(context).size.width / 1.44,
                  MediaQuery.of(context).size.width / 1.44,
                ),
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/scan_overlay.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 3.2,
                left: 30,
                right: 30,
                child: Center(
                  child: Lottie.asset(
                    'assets/images/scan.json',
                    width: MediaQuery.of(context).size.width / 1.28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 52, 30, 140),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        Slider(
                          activeColor: Colors.white,
                          inactiveColor: const Color.fromARGB(64, 0, 0, 0),
                          value: _zoomFactor,
                          onChanged: (value) {
                            setState(() {
                              _zoomFactor = value;
                              cameraController.setZoomScale(value);
                            });
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: cameraController.torchState,
                              builder: (context, state, child) {
                                switch (state) {
                                  case TorchState.off:
                                    return ElevatedButton.icon(
                                      onPressed: () =>
                                          cameraController.toggleTorch(),
                                      icon: const Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                      ),
                                      label: const Text('Flash'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 20,
                                        ),
                                        backgroundColor:
                                            const Color.fromARGB(64, 0, 0, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                    );
                                  case TorchState.on:
                                    return ElevatedButton.icon(
                                      onPressed: () =>
                                          cameraController.toggleTorch(),
                                      icon: const Icon(
                                        Icons.flash_on,
                                        color: Colors.white,
                                      ),
                                      label: const Text('Flash'),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 20,
                                        ),
                                        backgroundColor: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                    );
                                }
                              },
                            ),
                            ElevatedButton.icon(
                              onPressed: () => cameraController.switchCamera(),
                              icon: ValueListenableBuilder(
                                valueListenable:
                                    cameraController.cameraFacingState,
                                builder: (context, state, child) {
                                  switch (state) {
                                    case CameraFacing.front:
                                      return const Icon(
                                        Icons.camera_front,
                                        color: Colors.white,
                                      );
                                    case CameraFacing.back:
                                      return const Icon(
                                        Icons.camera_rear,
                                        color: Colors.white,
                                      );
                                  }
                                },
                              ),
                              label: const Text('Flip'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                backgroundColor:
                                    const Color.fromARGB(64, 0, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomAppBar(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                bottom: 20,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/history');
                        },
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              color: Theme.of(context).primaryColor,
                              size: 36,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'History',
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 114, 114),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: MediaQuery.of(context).size.width / 60,
                      thickness: 4,
                      color: const Color.fromARGB(255, 235, 235, 235),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            if (await cameraController
                                .analyzeImage(image.path)) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.horizontal,
                                  content: const Text('QR code found!'),
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.horizontal,
                                  content: const Text('QR code not found!'),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).primaryColor,
                              size: 36,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'Gallery',
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 114, 114),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
