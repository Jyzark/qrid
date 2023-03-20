import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class EmailQRScreen extends StatefulWidget {
  const EmailQRScreen({super.key});

  @override
  State<EmailQRScreen> createState() => _EmailQRScreenState();
}

class _EmailQRScreenState extends State<EmailQRScreen> {
  final _emailFormKey = GlobalKey<FormState>();

  var emailTextField = TextEditingController();

  String? qrData;
  String? email;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (email != null && _emailFormKey.currentState!.validate()) {
        qrData = 'mailto:$email';
      }

      if (qrData != null &&
          email != null &&
          _emailFormKey.currentState!.validate()) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: email!,
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
                    'Email Address',
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
                key: _emailFormKey,
                child: TextFormField(
                  controller: emailTextField,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: ValidationBuilder(
                    requiredMessage: 'Email Address cannot be empty',
                  )
                      .required()
                      .email('Please enter a valid email address')
                      .build(),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    _emailFormKey.currentState!.validate();
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter email adress',
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
