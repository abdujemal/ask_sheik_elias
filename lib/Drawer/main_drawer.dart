import 'package:ask_sheik_elias/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatefulWidget {
  final ThemeModel? model;
  const MainDrawer({this.model});

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    Spacer(),
                    Icon(Icons.help),
                    Text(AppLocalizations.of(context)!.asksheikelias, style: Theme.of(context).textTheme.headline5,textAlign: TextAlign.start,),
                    Spacer()
                  ],
                ),
                SizedBox(height: 40,),
                Text(AppLocalizations.of(context)!.setting,textAlign: TextAlign.start,),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(AppLocalizations.of(context)!.changelanguage),
                  subtitle: Text(AppLocalizations.of(context)!.lang) ,
                  onTap: (){
                    widget.model!.toggleLocale(context);


                  },
                ),
                SizedBox(height: 5,),
                ListTile(
                  leading: Icon(Icons.nights_stay),
                  title: Text(AppLocalizations.of(context)!.night_mode),
                  subtitle: Text(widget.model!.mode == ThemeMode.dark ? AppLocalizations.of(context)!.on : AppLocalizations.of(context)!.off),
                  onTap: () async {
                    if(widget.model!.mode == ThemeMode.dark){
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      await prefs.setInt('theme', 0);
                      widget.model!.toLightMode();
                    }else{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('theme', 1);
                      widget.model!.toDarkMode();
                    }
                  },
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey,))
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
