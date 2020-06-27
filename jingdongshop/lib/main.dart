import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/Counter.dart';
import 'provider/CartProvider.dart';
import 'routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'provider/CheckoutProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Counter()),
        ChangeNotifierProvider(builder: (_) => CartProviderClass()),
        ChangeNotifierProvider(builder: (_) => CheckoutProviderClass())
      ],
      child: MaterialApp(
        title: '京东商城',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: ThemeData(
            primaryColor: Colors.white,
            textTheme: TextTheme(subhead: TextStyle(textBaseline: TextBaseline.alphabetic))
        ),
          // 配置多语言
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [
            const Locale("zh", "CH"),
            const Locale("en", "US")
          ]
      ),
    );
  }
}

