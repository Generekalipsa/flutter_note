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
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('About application'),
                    content: Text(
                            'This application was created as an academic project in Flutter.\n'
                            'It is an open-source project which anyone is free to use, modify, distribute and share under the BSD-style license.\n'
                            '\nLibraries used in a project are:\n\n'
                            '-provider\nhttps://github.com/rrousselGit/provider\n\n'
                            '-shared preferences\nhttps://github.com/flutter/packages/tree/main/packages/shared_preferences/shared_preferences\n'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: "About app",
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.all(8.0), // Adjust the margin as needed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change theme',
                      style: TextStyle(
                        fontSize: 20,
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
                SizedBox(height: 8),
              ],
            ),
          ),
      ),
    );
  }
}