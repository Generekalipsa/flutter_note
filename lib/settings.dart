import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_note/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';



class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.all(8.0), // Adjust the margin as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme switch',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return Row(
                      children: [
                        Icon(Icons.light_mode),
                        Switch(
                          value: themeProvider.themeData == darkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                        Icon(Icons.dark_mode),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}