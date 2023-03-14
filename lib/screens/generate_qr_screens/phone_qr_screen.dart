import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class PhoneQRScreen extends StatefulWidget {
  const PhoneQRScreen({super.key});
  @override
  State<PhoneQRScreen> createState() => _PhoneQRScreenState();
}

class _PhoneQRScreenState extends State<PhoneQRScreen> {
  var phoneTextField = TextEditingController();
  String? qrData;
  String? phone;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];
    Widget generateButton() {
      if (phone != null) {
        qrData = 'tel:$phone';
      }
      if (qrData != null && phone != null) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: phone!,
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
                controller: phoneTextField,
                onChanged: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      phone = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isPhone() &&
                      newValue.length >= 5 &&
                      newValue.length <= 15) {
                    setState(() {
                      phone = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      phone = value;
                    });
                  }
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