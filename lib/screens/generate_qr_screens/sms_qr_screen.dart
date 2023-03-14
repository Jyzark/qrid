import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class SMSQRScreen extends StatefulWidget {
  const SMSQRScreen({super.key});

  @override
  State<SMSQRScreen> createState() => _SMSQRScreenState();
}

class _SMSQRScreenState extends State<SMSQRScreen> {
  var smsPhoneTextField = TextEditingController();
  var smsMessageTextField = TextEditingController();

  String? qrData;
  String? smsPhone;
  String? smsMessage;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (smsPhone != null &&
          smsPhone!.isPhone() &&
          smsPhone!.length >= 5 &&
          smsPhone!.length <= 15 &&
          smsMessage != null) {
        qrData = 'smsto:$smsPhone:$smsMessage';
      }

      if (qrData != null &&
          smsPhone != null &&
          smsPhone!.isPhone() &&
          smsPhone!.length >= 5 &&
          smsPhone!.length <= 15 &&
          smsMessage != null) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: '$smsPhone\n'
                    '$smsMessage',
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
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.telephoneNumber],
                autocorrect: true,
                enableSuggestions: true,
                controller: smsPhoneTextField,
                onChanged: (value) {
                  setState(() {
                    smsPhone = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    smsPhone = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    smsPhone = value;
                  });
                },
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (!value!.isPhone() ||
                      value.length < 5 ||
                      value.length > 15) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter phone number',
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
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                minLines: 2,
                maxLines: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: true,
                enableSuggestions: true,
                controller: smsMessageTextField,
                onChanged: (value) {
                  setState(() {
                    smsMessage = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    smsMessage = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    smsMessage = value;
                  });
                },
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null) {
                    return 'Message cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter message',
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
