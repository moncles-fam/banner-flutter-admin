import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:banner_flutter/providers/user_provider.dart';
import 'package:banner_flutter/responsive/mobile_screen_layout.dart';
import 'package:banner_flutter/responsive/responsive_layout_screen.dart';
import 'package:banner_flutter/responsive/web_screen_layout.dart';
import 'package:banner_flutter/screens/login_screen.dart';
import 'package:banner_flutter/screens/signup_screen.dart';
import 'package:banner_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBC_Skpk_vGX61ZzBak33e4SvEa003BT5U",
          authDomain: "banner-bf3a0.firebaseapp.com",
          projectId: "banner-bf3a0",
          storageBucket: "banner-bf3a0.appspot.com",
          messagingSenderId: "298606010083",
          appId: "1:298606010083:web:e6eb4bb4a551e65b9aafd6",
          measurementId: "G-RMS9H80VY0"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram_clone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
