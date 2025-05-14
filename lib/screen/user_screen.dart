import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'account':
        break;
      case 'settings':
        break;
      case 'privacy':
        break;
      case 'logout':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text(
          "User Profile",
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _onMenuSelected(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'account',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: 'privacy',
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Privacy'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
