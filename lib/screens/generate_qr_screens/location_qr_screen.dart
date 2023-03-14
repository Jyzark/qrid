import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';
import 'package:regexpattern/regexpattern.dart';

class LocationQRScreen extends StatefulWidget {
  const LocationQRScreen({super.key});
  @override
  State<LocationQRScreen> createState() => _LocationQRScreenState();
}

class _LocationQRScreenState extends State<LocationQRScreen> {
  var latitudeTextField = TextEditingController();
  var longitudeTextField = TextEditingController();
  String? qrData;
  String? locationLatitude;
  String? locationLongitude;
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];
    Widget generateButton() {
      if (locationLatitude != null && locationLongitude != null) {
        qrData = 'geo:$locationLatitude,$locationLongitude';
      }
      if (qrData != null &&
          locationLatitude != null &&
          locationLongitude != null) {
        var generatedHistoryController = GeneratedHistoryController();
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              generatedHistoryController.addHistory(
                itemType: typeName,
                itemTitle: 'Latitude: $locationLatitude\n'
                    'Longitude: $locationLongitude',
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
                    'Latitude',
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
                autofillHints: const [AutofillHints.location],
                autocorrect: true,
                enableSuggestions: true,
                controller: latitudeTextField,
                onChanged: (value) {
                  setState(() {
                    locationLatitude = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    locationLatitude = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    locationLatitude = value;
                  });
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!value!.isAlphabetNumericSymbol()) {
                    return 'Please input a valid latitude';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter latitude',
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
                    'Longitude',
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
                autofillHints: const [AutofillHints.location],
                autocorrect: true,
                enableSuggestions: true,
                controller: longitudeTextField,
                onChanged: (value) {
                  setState(() {
                    locationLongitude = value;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    locationLongitude = newValue;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    locationLongitude = value;
                  });
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (!value!.isAlphabetNumericSymbol()) {
                    return 'Please input a valid longitude';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Enter longitude',
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
