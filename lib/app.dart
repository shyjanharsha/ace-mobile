import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget — wires Riverpod + GoRouter + Theme
class KazhuthaKaliApp extends ConsumerWidget {
  const KazhuthaKaliApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Kazhutha Kali',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,

      // GoRouter integration
      routerConfig: router,

      // Media query overrides
      builder: (context, child) {
        // Clamp text scale to prevent layout breaks
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.3),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
