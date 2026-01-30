// lib\templates\footer.dart

import 'package:flutter/material.dart';

class MyFooter extends StatelessWidget implements PreferredSizeWidget {
  const MyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 50.0,
      padding: EdgeInsetsGeometry.zero,
      color: Colors.deepPurple,
      child: SizedBox(
        height: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {},
            ),
            Text('© 2026 Joca da Silva', style: TextStyle(color: Colors.white)),
            IconButton(
              icon: Icon(Icons.arrow_circle_up),
              color: Colors.white,
              iconSize: 30.0,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}