import 'package:flutter/material.dart';
import 'app_constants.dart';
import 'screens/main_navigation.dart';

void main() => runApp(const QrNovaApp());

class QrNovaApp extends StatelessWidget {
  const QrNovaApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appTitle,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
    ),
    home: const MainNavigation(),
  );
}
