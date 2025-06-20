import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:corrupted_island_android/pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Temel yükleme ve ayarların alınması
  WidgetsFlutterBinding.ensureInitialized();
  // .env dosyasının alınması
  await dotenv.load(fileName: ".env");
  // Reklam işlemlerinin uygulamaya yüklenmesi
  MobileAds.instance.initialize();
  // Durum çubuğunu şeffaf ve beyaz temaya dönüşmesi
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  // Uygulamanın dikey moda sabitlenmesi
  // manifest dosyasındaki 15. satırla beraber...
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corrupted Island',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
