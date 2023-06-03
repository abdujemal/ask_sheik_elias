import 'package:ask_sheik_elias/Providers/theme_provider.dart';
import 'package:ask_sheik_elias/Screens/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<ThemeModel>(
        create: (_)=>ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (_,model,__){
          return MaterialApp(
            locale: model.locale,
            localizationsDelegates: [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''),
              Locale('am', ''),
              Locale('ar', ''),
            ],
            debugShowCheckedModeBanner: false,
            title: 'Ask Sheik Elias Ahmed',
            theme: ThemeData.light(), // P
            themeMode:  model.mode,// rovide light theme
            darkTheme: ThemeData.dark(), // Provide dark theme
            // theme: ThemeData(
            //   // This is the theme of your application.
            //   //
            //   // Try running your application with "flutter run". You'll see the
            //   // application has a blue toolbar. Then, without quitting the app, try
            //   // changing the primarySwatch below to Colors.green and then invoke
            //   // "hot reload" (press "r" in the console where you ran "flutter run",
            //   // or simply save your changes to "hot reload" in a Flutter IDE).
            //   // Notice that the counter didn't reset back to zero; the application
            //   // is not restarted.
            //   primarySwatch: Colors.blue,
            //
            // ),
            home: QuestionsPage(model:model),

          );
        },
      ),
    );
  }
}
