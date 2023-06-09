import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class TextQRScreen extends StatefulWidget {
  const TextQRScreen({super.key});

  @override
  State<TextQRScreen> createState() => _TextQRScreenState();
}

class _TextQRScreenState extends State<TextQRScreen> {
  final _textFormKey = GlobalKey<FormState>();

  var textTextField = TextEditingController();

  String qrData = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (text.isNotEmpty) {
        qrData = text;
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            text.isNotEmpty &&
            _textFormKey.currentState!.validate()) {
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
                    itemTitle: text,
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
      resizeToAvoidBottomInset: true,
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
                    'Text',
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
                key: _textFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: textTextField,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Text cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter text',
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
