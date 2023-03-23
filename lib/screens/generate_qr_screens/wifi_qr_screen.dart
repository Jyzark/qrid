import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class WiFiQRScreen extends StatefulWidget {
  const WiFiQRScreen({super.key});

  @override
  State<WiFiQRScreen> createState() => _WiFiQRScreenState();
}

class _WiFiQRScreenState extends State<WiFiQRScreen> {
  final _networkNameFormKey = GlobalKey<FormState>();
  final _networkPasswordFormKey = GlobalKey<FormState>();

  var networkNameTextField = TextEditingController();
  var networkPasswordTextField = TextEditingController();

  String qrData = '';
  String networkName = '';
  String networkPassword = '';
  final List<String> wifiEncryptions = [
    'WPA/WPA2',
    'WEP',
    'No Encryption',
  ];
  String selectedEncryption = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (networkName.isNotEmpty && selectedEncryption.isNotEmpty) {
        String wifiString() {
          String formattedWiFiString = '';
          formattedWiFiString += 'WIFI:';
          formattedWiFiString += 'S:$networkName;';

          if (selectedEncryption != 'No Encryption' &&
              networkPassword.isNotEmpty) {
            formattedWiFiString += 'P:$networkPassword;';
          }

          if (selectedEncryption != 'No Encryption') {
            formattedWiFiString +=
                'T:${selectedEncryption.replaceAll('WPA/WPA2', 'WPA')};';
          }

          formattedWiFiString += ';';
          return formattedWiFiString;
        }

        qrData = wifiString();
      }

      bool isValid() {
        if (selectedEncryption.isNotEmpty && selectedEncryption == 'WPA/WPA2' ||
            selectedEncryption.isNotEmpty && selectedEncryption == 'WEP') {
          if (qrData.isNotEmpty &&
              networkName.isNotEmpty &&
              networkPassword.isNotEmpty &&
              networkPassword.length >= 8 &&
              _networkNameFormKey.currentState!.validate()) {
            return true;
          } else {
            return false;
          }
        } else {
          if (qrData.isNotEmpty &&
              networkName.isNotEmpty &&
              _networkNameFormKey.currentState!.validate()) {
            return true;
          } else {
            return false;
          }
        }
      }

      String wifiItemTitle() {
        if (selectedEncryption == 'WPA/WPA2' || selectedEncryption == 'WEP') {
          return 'Name: $networkName\n'
              'Password: $networkPassword\n'
              'Type: $selectedEncryption';
        } else {
          return 'Name: $networkName\n'
              'Type: $selectedEncryption';
        }
      }

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isValid()
              ? () {
                  GeneratedHistoryController().addHistory(
                    itemType: typeName,
                    itemTitle: wifiItemTitle(),
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

    Widget networkPasswordTextFieldWidget() {
      if (selectedEncryption.isNotEmpty &&
          selectedEncryption != 'No Encryption') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
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
              key: _networkPasswordFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: networkPasswordTextField,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }

                  if (value.length < 8) {
                    return 'Password cannot be less than 8 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    networkPassword = value;
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter password',
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      } else {
        return const SizedBox.shrink();
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
                    'Network Name',
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
                key: _networkNameFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: networkNameTextField,
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Network name cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      networkName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter network name',
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          networkPasswordTextFieldWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Text(
                    'Encryption',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField2(
                items: wifiEncryptions
                    .map((item) => DropdownMenuItem<String>(
                        value: item, child: Text(item)))
                    .toList(),
                isExpanded: true,
                hint: const Text(
                  'Select encryption type',
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromARGB(255, 114, 114, 114),
                ),
                iconSize: 30,
                onChanged: (value) {
                  setState(() {
                    selectedEncryption = value!;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select encryption type';
                  }
                  return null;
                },
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5, 20, 20, 20),
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
