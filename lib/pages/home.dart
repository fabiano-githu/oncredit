// lib/pages/home.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../templates/appbar.dart';
import '../templates/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  String _status = 'Desconectado';

  @override
  void initState() {
    super.initState();
    _loginAnonimo();
  }

  Future<void> _loginAnonimo() async {
    final user = await _authService.signInAnonymously();
    setState(() {
      _status = user != null
          ? 'Logado anonimamente: ${user.uid}'
          : 'Falha no login';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'OnCredit'),
      drawer: const MyDrawer(),
      body: Center(child: Text(_status)),
    );
  }
}
