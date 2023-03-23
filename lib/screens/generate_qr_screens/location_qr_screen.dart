import 'package:flutter/material.dart';
import 'package:qrid/controllers/generated_history_controller.dart';

class LocationQRScreen extends StatefulWidget {
  const LocationQRScreen({super.key});

  @override
  State<LocationQRScreen> createState() => _LocationQRScreenState();
}

class _LocationQRScreenState extends State<LocationQRScreen> {
  final _latitudeFormKey = GlobalKey<FormState>();
  final _longitudeFormKey = GlobalKey<FormState>();

  var latitudeTextField = TextEditingController();
  var longitudeTextField = TextEditingController();

  String qrData = '';
  String latitude = '';
  String longitude = '';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final typeName = args['title'];

    Widget generateButton() {
      if (latitude.isNotEmpty && longitude.isNotEmpty) {
        qrData = 'geo:$latitude,$longitude';
      }

      bool isValid() {
        if (qrData.isNotEmpty &&
            latitude.isNotEmpty &&
            longitude.isNotEmpty &&
            _latitudeFormKey.currentState!.validate() &&
            _longitudeFormKey.currentState!.validate()) {
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
                    itemTitle: 'Latitude: $latitude\n'
                        'Longitude: $longitude',
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
                    'Latitude',
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
                key: _latitudeFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: latitudeTextField,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.location],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    String latitudePattern =
                        r'^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$';

                    if (value!.isEmpty) {
                      return 'Latitude cannot be empty';
                    }

                    if (!value.contains(RegExp(latitudePattern))) {
                      return 'Please enter a valid latitude';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      latitude = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter latitude',
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
                    'Longitude',
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
                key: _longitudeFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: longitudeTextField,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.location],
                  autocorrect: true,
                  enableSuggestions: true,
                  validator: (value) {
                    String longitudePattern =
                        r'^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$';

                    if (value!.isEmpty) {
                      return 'Longitude cannot be empty';
                    }

                    if (!value.contains(RegExp(longitudePattern))) {
                      return 'Please enter a valid longitude';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      longitude = value;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'Enter longitude',
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
