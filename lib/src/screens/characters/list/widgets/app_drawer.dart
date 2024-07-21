import 'package:flutter/material.dart';

import '../../../settings/settings_view.dart';

/// A drawer that displays the app's navigation options.
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Rick and Morty App')),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
