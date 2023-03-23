import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexed_validator/regexed_validator.dart';

class PhoneQRScreen extends StatefulWidget {
  const PhoneQRScreen({super.key});

  @override
  State<PhoneQRScreen> createState() => _PhoneQRScreenState();
}

class _PhoneQRScreenState extends State<PhoneQRScreen> {
  final _phoneFormKey = GlobalKey<FormState>();

  var phoneTextField = TextEditingController();

  String qrData = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (phone.isNotEmpty) {
        qrData = 'tel:$phone';
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            phone.isNotEmpty &&
            _phoneFormKey.currentState!.validate()) {
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
                    itemTitle: phone,
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
                key: _phoneFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: phoneTextField,
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
                      phone = value;
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
