import 'package:flutter/material.dart';
import 'package:qrid/widgets/qr_type_listtile.dart';
import 'package:wakelock/wakelock.dart';

class SelectQRScreen extends StatelessWidget {
  const SelectQRScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Wakelock.disable();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select QR Type',
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
          QRTypeListTile(
            typeIcon: Icons.link,
            typeTitle: 'Link',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-link-qr',
                arguments: {
                  'title': 'Link',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.alternate_email,
            typeTitle: 'Email',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-email-qr',
                arguments: {
                  'title': 'Email',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.account_circle_outlined,
            typeTitle: 'Contact',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-contact-qr',
                arguments: {
                  'title': 'Contact',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.phone_outlined,
            typeTitle: 'Phone',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-phone-qr',
                arguments: {
                  'title': 'Phone',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.sms_outlined,
            typeTitle: 'SMS',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-sms-qr',
                arguments: {
                  'title': 'SMS',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.notes,
            typeTitle: 'Text',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-text-qr',
                arguments: {
                  'title': 'Text',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.wifi,
            typeTitle: 'Wi-Fi',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-wifi-qr',
                arguments: {
                  'title': 'Wi-Fi',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.emoji_events_outlined,
            typeTitle: 'Event',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-event-qr',
                arguments: {
                  'title': 'Event',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.place_outlined,
            typeTitle: 'Location',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-location-qr',
                arguments: {
                  'title': 'Location',
                },
              );
            },
          ),
          const SizedBox(height: 24),
          QRTypeListTile(
            typeIcon: Icons.qr_code_2,
            typeTitle: 'MeCard',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/generate-mecard-qr',
                arguments: {
                  'title': 'MeCard',
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
