import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SMSQRScreen extends StatefulWidget {
  const SMSQRScreen({super.key});

  @override
  State<SMSQRScreen> createState() => _SMSQRScreenState();
}

class _SMSQRScreenState extends State<SMSQRScreen> {
  final _smsPhoneFormKey = GlobalKey<FormState>();
  final _smsMessageFormKey = GlobalKey<FormState>();

  var smsPhoneTextField = TextEditingController();
  var smsMessageTextField = TextEditingController();

  String qrData = '';
  String smsPhone = '';
  String smsMessage = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (smsPhone.isNotEmpty && smsMessage.isNotEmpty) {
        qrData = 'smsto:$smsPhone:$smsMessage';
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            smsPhone.isNotEmpty &&
            smsMessage.isNotEmpty &&
            _smsPhoneFormKey.currentState!.validate() &&
            _smsMessageFormKey.currentState!.validate()) {
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
                    itemTitle: '$smsPhone\n'
                        '$smsMessage',
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
                    'Phone Number',
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
                key: _smsPhoneFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: smsPhoneTextField,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number cannot be empty';
                    }

                    if (!validator.phone(value) ||
                        value.length <= 5 ||
                        value.length >= 15) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      smsPhone = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter phone number',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Message',
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
                key: _smsMessageFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: smsMessageTextField,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Message cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      smsMessage = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter message',
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
