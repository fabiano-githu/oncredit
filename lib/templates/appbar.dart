// lib\templates\appbar.dart

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'ON',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 25.0,
              ),
            ),
            SizedBox(width: 1),
            Icon(Icons.credit_score, size: 30,),
            SizedBox(width: 1),
            Text('Credit'),
          ],
        ),
      ),

      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
