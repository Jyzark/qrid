import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class LinkQRScreen extends StatefulWidget {
  const LinkQRScreen({super.key});

  @override
  State<LinkQRScreen> createState() => _LinkQRScreenState();
}

class _LinkQRScreenState extends State<LinkQRScreen> {
  var urlTextField = TextEditingController();

  String? qrData;
  String? url;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (url != null) {
        qrData = url;
      }

      if (qrData != null && url != null) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: url!,
                itemRawData: qrData!,
              );
              Navigator.pushNamed(
                context,
                '/generate-qr-result',
                arguments: {
                  'typeName': typeName,
                  'qrData': qrData,
                },
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
            child: const Text('Generate QR Code'),
          ),
        );
      } else {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: null,
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
            child: const Text('Generate QR Code'),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          typeName,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'URL',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.url],
                autocorrect: true,
                enableSuggestions: true,
                controller: urlTextField,
                onChanged: (value) {
                  if (value.isUrl() && value.contains('https://') ||
                      value.isUrl() && value.contains('http://')) {
                    setState(() {
                      url = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isUrl() && newValue.contains('https://') ||
                      newValue.isUrl() && newValue.contains('http://')) {
                    setState(() {
                      url = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isUrl() && value.contains('https://') ||
                      value.isUrl() && value.contains('http://')) {
                    setState(() {
                      url = value;
                    });
                  }
                },
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (!value!.isUrl() && !value.contains('https://') ||
                      !value.isUrl() && !value.contains('http://')) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter URL',
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: generateButton(),
      ),
    );
  }
}
