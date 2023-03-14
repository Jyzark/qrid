import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class WiFiQRScreen extends StatefulWidget {
  const WiFiQRScreen({super.key});
  @override
  State<WiFiQRScreen> createState() => _WiFiQRScreenState();
}

class _WiFiQRScreenState extends State<WiFiQRScreen> {
  var networkNameTextField = TextEditingController();
  var networkPasswordTextField = TextEditingController();
  String? qrData;
  String? networkName;
  String? networkPassword;
  final List<String> wifiEncryptions = [
    'WPA/WPA2',
    'WEP',
    'No Encryption',
  ];
  String? selectedEncryption;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];
    Widget generateButton() {
      if (networkName != null) {
        String wifiString() {
          String formattedWiFiString = '';
          formattedWiFiString += 'WIFI:';
          formattedWiFiString += 'S:${networkName!};';
          if (selectedEncryption != 'No Encryption' &&
              networkPassword != null) {
            formattedWiFiString += 'P:${networkPassword!};';
          }
          if (selectedEncryption != 'No Encryption') {
            formattedWiFiString +=
                'T:${selectedEncryption!.replaceAll('WPA/WPA2', 'WPA')};';
          }
          formattedWiFiString += ';';
          return formattedWiFiString;
        }

        qrData = wifiString();
      }
      if (qrData != null && networkName != null) {
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

        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: wifiItemTitle(),
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

    Widget networkPasswordTextFieldWidget() {
      if (selectedEncryption != 'No Encryption') {
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
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: networkPasswordTextField,
              onChanged: (value) {
                setState(() {
                  networkPassword = value;
                });
              },
              onSaved: (newValue) {
                setState(() {
                  networkPassword = newValue;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  networkPassword = value;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value!.length < 8) {
                  return 'Password must contain at least 8 characters';
                }
                return null;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: 'Enter password',
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      } else {
        return const SizedBox();
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
                    'Network Name',
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
                autocorrect: true,
                enableSuggestions: true,
                controller: networkNameTextField,
                onChanged: (value) {
                  setState(() {
                    networkName = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    networkName = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    networkName = value;
                  });
                },
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Network name cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter network name',
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
                    selectedEncryption = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    selectedEncryption = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
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
