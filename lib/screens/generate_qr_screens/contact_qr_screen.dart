import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ContactQRScreen extends StatefulWidget {
  const ContactQRScreen({super.key});

  @override
  State<ContactQRScreen> createState() => _ContactQRScreenState();
}

class _ContactQRScreenState extends State<ContactQRScreen> {
  final _contactNameFormKey = GlobalKey<FormState>();
  final _contactCompanyFormKey = GlobalKey<FormState>();
  final _contactTitleFormKey = GlobalKey<FormState>();
  final _contactPhoneFormKey = GlobalKey<FormState>();
  final _contactEmailFormKey = GlobalKey<FormState>();
  final _contactAddressFormKey = GlobalKey<FormState>();
  final _contactWebsiteFormKey = GlobalKey<FormState>();
  final _contactNoteFormKey = GlobalKey<FormState>();

  var contactNameTextField = TextEditingController();
  var contactCompanyTextField = TextEditingController();
  var contactTitleTextField = TextEditingController();
  var contactPhoneTextField = TextEditingController();
  var contactEmailTextField = TextEditingController();
  var contactAddressTextField = TextEditingController();
  var contactWebsiteTextField = TextEditingController();
  var contactNoteTextField = TextEditingController();

  String qrData = '';
  String contactName = '';
  String contactCompany = '';
  String contactTitle = '';
  String contactPhone = '';
  String contactEmail = '';
  String contactAddress = '';
  String contactWebsite = '';
  String contactNote = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (contactName.isNotEmpty && contactPhone.isNotEmpty) {
        String vCardString() {
          String formattedVCardString = '';
          formattedVCardString += 'BEGIN:VCARD\n';
          formattedVCardString += 'VERSION:3.0\n';
          formattedVCardString += 'N:$contactName\n';

          if (contactCompany.isNotEmpty) {
            formattedVCardString += 'ORG:$contactCompany\n';
          }

          if (contactTitle.isNotEmpty) {
            formattedVCardString += 'TITLE:$contactTitle\n';
          }

          formattedVCardString += 'TEL:$contactPhone\n';

          if (contactEmail.isNotEmpty && validator.email(contactEmail)) {
            formattedVCardString += 'EMAIL:$contactEmail\n';
          }

          if (contactAddress.isNotEmpty) {
            formattedVCardString += 'ADR:$contactAddress\n';
          }

          if (contactWebsite.isNotEmpty && validator.url(contactWebsite)) {
            formattedVCardString += 'URL:$contactWebsite\n';
          }

          if (contactNote.isNotEmpty) {
            formattedVCardString += 'NOTE:$contactNote\n';
          }

          formattedVCardString += 'END:VCARD';
          return formattedVCardString;
        }

        qrData = vCardString();
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            contactName.isNotEmpty &&
            contactPhone.isNotEmpty &&
            _contactNameFormKey.currentState!.validate() &&
            _contactPhoneFormKey.currentState!.validate()) {
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
                    itemTitle: contactName,
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
                key: _contactNameFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: contactNameTextField,
                  keyboardType: TextInputType.name,
                  autofillHints: const [AutofillHints.name],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      contactName = value;
                    });
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
                key: _contactCompanyFormKey,
                child: TextFormField(
                  controller: contactCompanyTextField,
                  keyboardType: TextInputType.text,
                  autofillHints: const [AutofillHints.organizationName],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      contactCompany = value;
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
                    'Title',
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
                key: _contactTitleFormKey,
                child: TextFormField(
                  controller: contactTitleTextField,
                  keyboardType: TextInputType.text,
                  autofillHints: const [AutofillHints.jobTitle],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      contactTitle = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter title',
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
                key: _contactPhoneFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: contactPhoneTextField,
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
                      contactPhone = value;
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
                key: _contactEmailFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: contactEmailTextField,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (!validator.email(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      contactEmail = value;
                    });
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
                key: _contactAddressFormKey,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  controller: contactAddressTextField,
                  keyboardType: TextInputType.streetAddress,
                  autofillHints: const [AutofillHints.fullStreetAddress],
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      contactAddress = value;
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
                    'Website',
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
                key: _contactWebsiteFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: contactWebsiteTextField,
                  keyboardType: TextInputType.url,
                  autofillHints: const [AutofillHints.url],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (!validator.url(value!)) {
                      return 'Please enter a valid website';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      contactWebsite = value;
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
                key: _contactNoteFormKey,
                child: TextFormField(
                  minLines: 2,
                  maxLines: 10,
                  controller: contactNoteTextField,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  enableSuggestions: true,
                  onChanged: (value) {
                    setState(() {
                      contactNote = value;
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
