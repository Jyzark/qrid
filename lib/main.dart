import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrid/screens/generate_qr_result_screen.dart';
import 'package:qrid/screens/generate_qr_screens/contact_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/email_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/event_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/link_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/location_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/mecard_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/phone_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/sms_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/text_qr_screen.dart';
import 'package:qrid/screens/generate_qr_screens/wifi_qr_screen.dart';
import 'package:qrid/screens/history_detail_screen.dart';
import 'package:qrid/screens/history_screen.dart';
import 'package:qrid/screens/home_screen.dart';
import 'package:qrid/screens/select_qr_screen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}

class Palette {
  static const MaterialColor swatch = MaterialColor(
    0xff242424,
    <int, Color>{
      50: Color(0xff202020),
      100: Color(0xff1d1d1d),
      200: Color(0xff191919),
      300: Color(0xff161616),
      400: Color(0xff121212),
      500: Color(0xff0e0e0e),
      600: Color(0xff0b0b0b),
      700: Color(0xff070707),
      800: Color(0xff040404),
      900: Color(0xff000000),
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRID',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        primarySwatch: Palette.swatch,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 36, 36, 36),
            disabledForegroundColor: const Color.fromARGB(255, 114, 114, 114),
            disabledBackgroundColor: const Color.fromARGB(255, 235, 235, 235),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 36, 36, 36),
        ),
        tabBarTheme: const TabBarTheme(
          overlayColor: MaterialStatePropertyAll(Colors.transparent),
        ),
        timePickerTheme: TimePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          hourMinuteShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 114, 114, 114),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
                color: Color.fromARGB(255, 36, 36, 36),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                width: 2,
                color: Colors.red[100]!,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.red,
              ),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 114, 114, 114),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromARGB(255, 235, 235, 235),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 2,
              color: Color.fromARGB(255, 36, 36, 36),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
              color: Colors.red[100]!,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/history-detail': (context) => const HistoryDetailScreen(),
        '/select-qr-type': (context) => const SelectQRScreen(),
        '/generate-link-qr': (context) => const LinkQRScreen(),
        '/generate-email-qr': (context) => const EmailQRScreen(),
        '/generate-contact-qr': (context) => const ContactQRScreen(),
        '/generate-phone-qr': (context) => const PhoneQRScreen(),
        '/generate-sms-qr': (context) => const SMSQRScreen(),
        '/generate-text-qr': (context) => const TextQRScreen(),
        '/generate-wifi-qr': (context) => const WiFiQRScreen(),
        '/generate-event-qr': (context) => const EventQRScreen(),
        '/generate-location-qr': (context) => const LocationQRScreen(),
        '/generate-mecard-qr': (context) => const MeCardQRScreen(),
        '/generate-qr-result': (context) => const GenerateQRResultScreen(),
      },
    );
  }
}
