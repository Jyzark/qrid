import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class ContactQRScreen extends StatefulWidget {
  const ContactQRScreen({super.key});
  @override
  State<ContactQRScreen> createState() => _ContactQRScreenState();
}

class _ContactQRScreenState extends State<ContactQRScreen> {
  var contactNameTextField = TextEditingController();
  var contactCompanyTextField = TextEditingController();
  var contactTitleTextField = TextEditingController();
  var contactPhoneTextField = TextEditingController();
  var contactEmailTextField = TextEditingController();
  var contactAddressTextField = TextEditingController();
  var contactWebsiteTextField = TextEditingController();
  var contactNoteTextField = TextEditingController();
  String? qrData;
  String? contactName;
  String? contactCompany;
  String? contactTitle;
  String? contactPhone;
  String? contactEmail;
  String? contactAddress;
  String? contactWebsite;
  String? contactNote;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];
    Widget generateButton() {
      if (contactName != null && contactPhone != null) {
        String vCardString() {
          String formattedVCardString = '';
          formattedVCardString += 'BEGIN:VCARD\n';
          formattedVCardString += 'VERSION:3.0\n';
          formattedVCardString += 'N:${contactName!}\n';
          if (contactCompany != null) {
            formattedVCardString += 'ORG:${contactCompany!}\n';
          }
          if (contactTitle != null) {
            formattedVCardString += 'TITLE:${contactTitle!}\n';
          }
          formattedVCardString += 'TEL:${contactPhone!}\n';
          if (contactEmail != null) {
            formattedVCardString += 'EMAIL:${contactEmail!}\n';
          }
          if (contactAddress != null) {
            formattedVCardString += 'ADR:${contactAddress!}\n';
          }
          if (contactWebsite != null) {
            formattedVCardString += 'URL:${contactWebsite!}\n';
          }
          if (contactNote != null) {
            formattedVCardString += 'NOTE:${contactNote!}\n';
          }
          formattedVCardString += 'END:VCARD';
          return formattedVCardString;
        }

        qrData = vCardString();
      }
      if (qrData != null && contactName != null && contactPhone != null) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: contactName!,
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
                    'Name',
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
                autofillHints: const [AutofillHints.name],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactNameTextField,
                onChanged: (value) {
                  setState(() {
                    contactName = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    contactName = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    contactName = value;
                  });
                },
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter name',
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.organizationName],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactCompanyTextField,
                onChanged: (value) {
                  setState(() {
                    contactCompany = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    contactCompany = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    contactCompany = value;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter company',
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.jobTitle],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactTitleTextField,
                onChanged: (value) {
                  setState(() {
                    contactTitle = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    contactTitle = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    contactTitle = value;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter title',
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
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.telephoneNumber],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactPhoneTextField,
                onChanged: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      contactPhone = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isPhone() &&
                      newValue.length >= 5 &&
                      newValue.length <= 15) {
                    setState(() {
                      contactPhone = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      contactPhone = value;
                    });
                  }
                },
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null) {
                    return 'Phone Number cannot be empty';
                  }
                  if (!value.isPhone() ||
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.email],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactEmailTextField,
                onChanged: (value) {
                  if (value.isEmail()) {
                    setState(() {
                      contactEmail = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isEmail()) {
                    setState(() {
                      contactEmail = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isEmail()) {
                    setState(() {
                      contactEmail = value;
                    });
                  }
                },
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!value!.isEmail()) {
                    return 'Please input a valid email adress';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter email address',
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
              TextFormField(
                minLines: 1,
                maxLines: 5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.fullStreetAddress],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactAddressTextField,
                onChanged: (value) {
                  setState(() {
                    contactAddress = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    contactAddress = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    contactAddress = value;
                  });
                },
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter address',
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: const [AutofillHints.url],
                autocorrect: true,
                enableSuggestions: true,
                controller: contactWebsiteTextField,
                onChanged: (value) {
                  if (value.isUrl()) {
                    setState(() {
                      contactWebsite = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isUrl()) {
                    setState(() {
                      contactWebsite = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isUrl()) {
                    setState(() {
                      contactWebsite = value;
                    });
                  }
                },
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (!value!.isUrl()) {
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
              TextFormField(
                minLines: 2,
                maxLines: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autocorrect: true,
                enableSuggestions: true,
                controller: contactNoteTextField,
                onChanged: (value) {
                  setState(() {
                    contactNote = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    contactNote = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    contactNote = value;
                  });
                },
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter note',
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
