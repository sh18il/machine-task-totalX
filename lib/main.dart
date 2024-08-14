import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:totalx/controller/mobile_auth.dart';
import 'package:totalx/firebase_options.dart';
import 'package:totalx/view/mobile_auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhoneOtpAuth(),
        )
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MobileAuthPage(),
      ),
    );
  }
}
