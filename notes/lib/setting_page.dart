import 'package:flutter/material.dart';
import 'package:notes/data/local/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: Consumer<ThemeProvider>(builder: (ctx, provider, __){
        return SwitchListTile.adaptive(
            title: Text('Dark Mode'),
            onChanged: (value){
              provider.updateTheme(value: value);
            },
            value: provider.getThemeValue(),
        );
      }),
    );
  }
}
