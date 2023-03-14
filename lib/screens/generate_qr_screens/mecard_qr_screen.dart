import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class MeCardQRScreen extends StatefulWidget {
  const MeCardQRScreen({super.key});
  @override
  State<MeCardQRScreen> createState() => _MeCardQRScreenState();
}

class _MeCardQRScreenState extends State<MeCardQRScreen> {
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
      if (meCardName != null) {
        String meCardString() {
          String formattedMeCardString = '';
          formattedMeCardString += 'MECARD:';
          formattedMeCardString += 'N:${meCardName!};';
          if (meCardCompany != null) {
            formattedMeCardString += 'ORG:${meCardCompany!};';
          }
          if (meCardPhone != null) {
            formattedMeCardString += 'TEL:${meCardPhone!};';
          }
          if (meCardEmail != null) {
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
      if (qrData != null && meCardName != null) {
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
                controller: meCardNameTextField,
                onChanged: (value) {
                  setState(() {
                    meCardName = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    meCardName = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    meCardName = value;
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
                controller: meCardCompanyTextField,
                onChanged: (value) {
                  setState(() {
                    meCardCompany = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    meCardCompany = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    meCardCompany = value;
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
                controller: meCardPhoneTextField,
                onChanged: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      meCardPhone = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isPhone() &&
                      newValue.length >= 5 &&
                      newValue.length <= 15) {
                    setState(() {
                      meCardPhone = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isPhone() &&
                      value.length >= 5 &&
                      value.length <= 15) {
                    setState(() {
                      meCardPhone = value;
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
                controller: meCardEmailTextField,
                onChanged: (value) {
                  if (value.isEmail()) {
                    setState(() {
                      meCardEmail = value;
                    });
                  }
                },
                onSaved: (newValue) {
                  if (newValue!.isEmail()) {
                    setState(() {
                      meCardEmail = newValue;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.isEmail()) {
                    setState(() {
                      meCardEmail = value;
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
                controller: meCardAddressTextField,
                onChanged: (value) {
                  setState(() {
                    meCardAddress = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    meCardAddress = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    meCardAddress = value;
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
                controller: meCardNoteTextField,
                onChanged: (value) {
                  setState(() {
                    meCardNote = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    meCardNote = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    meCardNote = value;
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
