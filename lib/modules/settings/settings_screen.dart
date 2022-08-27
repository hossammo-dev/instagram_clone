import 'package:flutter/material.dart';
import 'package:instagram_clone/shared/widgets/components.dart';

import '../../shared/cubit/auth_cubit/auth_cubit.dart';
import '../../shared/cubit/main_cubit/main_cubit.dart';
import '../auth/auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        title: 'Settings',
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.check, 'Theme', () {}), //todo theme icon
            const SizedBox(height: 20),
            _buildRow(Icons.notifications_outlined, 'Notifications', () {}),
            const SizedBox(height: 20),
            _buildRow(Icons.person_outline_outlined, 'Account', () {}),
            const SizedBox(height: 20),
            _buildRow(Icons.info_outline_rounded, 'About', () {}),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () => AuthCubit.get(context)
                    .logUserOut()
                    .whenComplete(
                        () {
                          MainCubit.get(context).removeCachedData();
                          navigateRemove(context, page: AuthScreen());
                        }),
                child: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
}
