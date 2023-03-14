import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultActionButtons extends StatefulWidget {
  const ResultActionButtons(
      {super.key, required this.captureData, required this.copyText});

  final BarcodeCapture? captureData;
  final String copyText;

  @override
  State<ResultActionButtons> createState() => _ResultActionButtonsState();
}

class _ResultActionButtonsState extends State<ResultActionButtons> {
  @override
  Widget build(BuildContext context) {
    var qrData = widget.captureData!.barcodes.first;

    if (qrData.type == BarcodeType.url && qrData.rawValue!.isUrl()) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                FlutterWebBrowser.openWebPage(
                  url: qrData.rawValue!,
                  customTabsOptions: CustomTabsOptions(
                    shareState: CustomTabsShareState.on,
                    showTitle: true,
                    instantAppsEnabled: true,
                    urlBarHidingEnabled: true,
                    defaultColorSchemeParams: CustomTabsColorSchemeParams(
                      toolbarColor: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Open in Browser'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.copyText,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              content: const Text('Copied to clipboard'),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Copy'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (qrData.type == BarcodeType.email) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse(qrData.rawValue!));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Send Email'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.copyText,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              content: const Text('Copied to clipboard'),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Copy'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (qrData.type == BarcodeType.contactInfo &&
        !qrData.rawValue!.contains('MECARD:')) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (await FlutterContacts.requestPermission()) {
                  final newContact = Contact.fromVCard(qrData.rawValue!);
                  await newContact.insert();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.horizontal,
                      content: Text('${qrData.displayValue} added to contact.'),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Add to Contact'),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      );
    } else if (qrData.type == BarcodeType.phone) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse(qrData.rawValue!));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Call Number'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.copyText,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              content: const Text('Copied to clipboard'),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Copy'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (qrData.type == BarcodeType.sms) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse(qrData.rawValue!.replaceAll(
                    '${qrData.sms!.phoneNumber}:',
                    '${qrData.sms!.phoneNumber}?body=')));
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Send SMS'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.copyText,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              content: const Text('Copied to clipboard'),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Copy'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (qrData.type == BarcodeType.geo) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(
                    qrData.geoPoint!.latitude!, qrData.geoPoint!.longitude!);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Open in Map'),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: widget.copyText,
                        ),
                      ).then(
                        (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.horizontal,
                              content: const Text('Copied to clipboard'),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Copy'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: widget.copyText,
                  ),
                ).then(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        dismissDirection: DismissDirection.horizontal,
                        content: const Text('Copied to clipboard'),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Copy'),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      );
    }
  }
}
