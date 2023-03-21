import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class MeCardQRScreen extends StatefulWidget {
  const MeCardQRScreen({super.key});

  @override
  State<MeCardQRScreen> createState() => _MeCardQRScreenState();
}

class _MeCardQRScreenState extends State<MeCardQRScreen> {
  final _meCardNameFormKey = GlobalKey<FormState>();
  final _meCardCompanyFormKey = GlobalKey<FormState>();
  final _meCardPhoneFormKey = GlobalKey<FormState>();
  final _meCardEmailFormKey = GlobalKey<FormState>();
  final _meCardAddressFormKey = GlobalKey<FormState>();
  final _meCardNoteFormKey = GlobalKey<FormState>();

  var meCardNameTextField = TextEditingController();
  var meCardCompanyTextField = TextEditingController();
  var meCardPhoneTextField = TextEditingController();
  var meCardEmailTextField = TextEditingController();
  var meCardAddressTextField = TextEditingController();
  var meCardNoteTextField = TextEditingController();

  String? qrData;
  String? meCardName;
  String? meCardCompany;
  String? meCardPhone;
  String? meCardEmail;
  String? meCardAddress;
  String? meCardNote;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (meCardName != null &&
          meCardPhone != null &&
          _meCardNameFormKey.currentState!.validate() &&
          _meCardPhoneFormKey.currentState!.validate()) {
        String meCardString() {
          String formattedMeCardString = '';
          formattedMeCardString += 'MECARD:';
          formattedMeCardString += 'N:${meCardName!};';

          if (meCardCompany != null) {
            formattedMeCardString += 'ORG:${meCardCompany!};';
          }

          formattedMeCardString += 'TEL:${meCardPhone!};';

          if (meCardEmail != null &&
              _meCardEmailFormKey.currentState!.validate()) {
            formattedMeCardString += 'EMAIL:${meCardEmail!};';
          }

          if (meCardAddress != null) {
            formattedMeCardString += 'ADR:${meCardAddress!};';
          }

          if (meCardNote != null) {
            formattedMeCardString += 'NOTE:${meCardNote!};';
          }

          formattedMeCardString += ';';
          return formattedMeCardString;
        }

        qrData = meCardString();
      }

      if (qrData != null &&
          meCardName != null &&
          meCardPhone != null &&
          _meCardNameFormKey.currentState!.validate() &&
          _meCardPhoneFormKey.currentState!.validate()) {
        var generatedHistoryController = GeneratedHistoryController();

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: meCardName!,
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
                    'Name',
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
                key: _meCardNameFormKey,
                child: TextFormField(
                  controller: meCardNameTextField,
                  keyboardType: TextInputType.name,
                  autofillHints: const [AutofillHints.name],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: ValidationBuilder(
                    requiredMessage: 'Name cannot be empty',
                  ).required().build(),
                  onChanged: (value) {
                    setState(() {
                      meCardName = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    _meCardNameFormKey.currentState!.validate();
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter name',
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
                    'Company',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _meCardCompanyFormKey,
                child: TextFormField(
                  controller: meCardCompanyTextField,
                  keyboardType: TextInputType.text,
                  autofillHints: const [AutofillHints.organizationName],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      meCardCompany = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter company',
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
                key: _meCardPhoneFormKey,
                child: TextFormField(
                  controller: meCardPhoneTextField,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: ValidationBuilder(
                    requiredMessage: 'Phone number cannot be empty',
                  )
                      .required()
                      .phone('Please enter a valid phone number')
                      .minLength(
                          5, 'Phone number cannot be less than 5 characters')
                      .maxLength(
                          15, 'Phone number cannot be more than 15 characters')
                      .build(),
                  onChanged: (value) {
                    setState(() {
                      meCardPhone = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    _meCardPhoneFormKey.currentState!.validate();
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
                    'Email Address',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _meCardEmailFormKey,
                child: TextFormField(
                  controller: meCardEmailTextField,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: ValidationBuilder(
                    requiredMessage: 'Email Address cannot be empty',
                  ).email('Please enter a valid email address').build(),
                  onChanged: (value) {
                    setState(() {
                      meCardEmail = value;
                    });
                  },
                  onFieldSubmitted: (value) {
                    _meCardEmailFormKey.currentState!.validate();
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter email address',
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
                    'Address',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _meCardAddressFormKey,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  controller: meCardAddressTextField,
                  keyboardType: TextInputType.streetAddress,
                  autofillHints: const [AutofillHints.fullStreetAddress],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      meCardAddress = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter address',
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
                    'Note',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Form(
                key: _meCardNoteFormKey,
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: meCardNoteTextField,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      meCardNote = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter note',
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
