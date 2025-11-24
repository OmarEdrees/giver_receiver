import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:giver_receiver/presentation/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: "https://dntwmnrsalbkadjnwfuz.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRudHdtbnJzYWxia2Fkam53ZnV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5NTQ3MTcsImV4cCI6MjA3ODUzMDcxN30.inhyZyELp3_q2C5SosLKvE64U1PUgZ_wEY8mX85_zNg",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      ////////////////////////////
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
