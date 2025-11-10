import 'package:flutter/material.dart';

class Settingstile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const Settingstile({super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap ?? () {},
    );
  }
}
