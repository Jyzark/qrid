import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexed_validator/regexed_validator.dart';

class LinkQRScreen extends StatefulWidget {
  const LinkQRScreen({super.key});

  @override
  State<LinkQRScreen> createState() => _LinkQRScreenState();
}

class _LinkQRScreenState extends State<LinkQRScreen> {
  final _urlFormKey = GlobalKey<FormState>();

  var urlTextField = TextEditingController();

  String qrData = '';
  String url = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (url.isNotEmpty) {
        qrData = url;
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            url.isNotEmpty &&
            _urlFormKey.currentState!.validate()) {
          return true;
        } else {
          return false;
        }
      }

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isValid()
              ? () {
                  GeneratedHistoryController().addHistory(
                    itemType: typeName,
                    itemTitle: url,
                    itemRawData: qrData,
                  );
                  Navigator.pushNamed(
                    context,
                    '/generate-qr-result',
                    arguments: {
                      'typeName': typeName,
                      'qrData': qrData,
                    },
                  );
                }
              : null,
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
        surfaceTintColor: Colors.white,
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
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _urlFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: urlTextField,
                  keyboardType: TextInputType.url,
                  autofillHints: const [AutofillHints.url],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'URL cannot be empty';
                    }

                    if (!validator.url(value)) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      url = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter URL',
                  ),
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
