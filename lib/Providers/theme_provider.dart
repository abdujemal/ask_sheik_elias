import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  Locale _locale = Locale('en','');
  ThemeMode get mode => _mode;
  Locale get locale => _locale;

  // const ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toDarkMode() {

    _mode = ThemeMode.dark;
    notifyListeners();
  }
  void toLightMode() {
    _mode = ThemeMode.light;
    notifyListeners();
  }
  void toggleLocale(context){
    if(AppLocalizations.of(context)!.localeName=="en"){
      toAM();
    }else if(AppLocalizations.of(context)!.localeName=="am"){
      toAR();
    }else{
      toEN();
    }

  }

  void toAM() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', "am");
    _locale = Locale('am','');
    notifyListeners();
  }
  void toEN() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', "en");
    _locale = Locale('en','');
    notifyListeners();
  }
  void toAR() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', "ar");
    _locale = Locale('ar','');
    notifyListeners();
  }
}
