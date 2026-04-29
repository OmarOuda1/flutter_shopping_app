import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Theme'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            title: Text('Credits'),
            leading: Icon(Icons.info),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FutureBuilder(
                    future: rootBundle.loadString('assets/credits.md'),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            return AlertDialog(
                              title: Text('Credits'),
                              content: SingleChildScrollView(
                                child: MarkdownBody(data: snapshot.data!),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            content: Container(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
