import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studio_yaiverse_mobile/views/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Studio YAIVERSE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
            titleTextStyle:
                GoogleFonts.nunito(color: Colors.black, fontSize: 20)),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelStyle: TextStyle(color: Colors.grey)),
      ),
      home: const StudioYaiverseHome(title: "Studio YAIverse"),
    );
  }
}
