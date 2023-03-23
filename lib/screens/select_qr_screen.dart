import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrid/ad_helper.dart';
import 'package:qrid/widgets/qr_type_listtile.dart';
import 'package:wakelock/wakelock.dart';

class SelectQRScreen extends StatefulWidget {
  const SelectQRScreen({super.key});

  @override
  State<SelectQRScreen> createState() => _SelectQRScreenState();
}

class _SelectQRScreenState extends State<SelectQRScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadBannerAd);
  }

  Future<void> _loadBannerAd() async {
    final AnchoredAdaptiveBannerAdSize? adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: adSize!,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            _bannerAd = null;
          });
          debugPrint('Failed to load banner ad: ${error.message}');
          ad.dispose();
        },
        onAdClosed: (ad) {
          setState(() {
            _bannerAd = null;
          });
          ad.dispose();
        },
      ),
    );
    return _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.disable();

    Widget? adBannerWidget() {
      if (_bannerAd != null) {
        return AdWidget(ad: _bannerAd!);
      } else {
        return const SizedBox.shrink();
      }
    }

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
        surfaceTintColor: Colors.white,
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
      bottomNavigationBar: adBannerWidget(),
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose a BannerAd object
    _bannerAd?.dispose();
    super.dispose();
  }
}
