import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // -------------------------------------------------------
  // System UI — immersive dark experience
  // -------------------------------------------------------
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0E1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Force portrait orientation for card game
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load env variables
  await dotenv.load(fileName: '.env');

  // -------------------------------------------------------
  // Dependency injection
  // -------------------------------------------------------
  await setupDependencies();

  // -------------------------------------------------------
  // Launch app with ProviderScope
  // -------------------------------------------------------
  runApp(
    const ProviderScope(
      child: KazhuthaKaliApp(),
    ),
  );
}
