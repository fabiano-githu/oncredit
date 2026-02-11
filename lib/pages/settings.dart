// lib/pages/settings.dart

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../templates/appbar.dart';
import '../config/app_config.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> _editCriticalSettings() async {
    final uidController = TextEditingController(text: AppConfig.fixedUid);
    final urlController = TextEditingController(text: AppConfig.baseUrl);

    final originalUid = AppConfig.fixedUid;
    final originalUrl = AppConfig.baseUrl;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text(
          '⚠ Configurações Críticas',
          style: TextStyle(color: Colors.red),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Alterar essas configurações pode quebrar o aplicativo.\n\n'
                'Use apenas se souber exatamente o que está fazendo.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: uidController,
                decoration: const InputDecoration(
                  labelText: 'UID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final newUid = uidController.text.trim();
    final newUrl = urlController.text.trim();

    final changed = newUid != originalUid || newUrl != originalUrl;

    if (!changed) return;

    final confirmed = await _confirmCriticalChange();

    if (!confirmed) return;

    await AppConfig.save(newUid, newUrl);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configurações atualizadas')));
  }

  Future<bool> _confirmCriticalChange() async {
    final controller = TextEditingController();
    bool confirmed = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: const Text(
          '🚨 CONFIRMAÇÃO OBRIGATÓRIA',
          style: TextStyle(color: Colors.red),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Você está alterando parâmetros internos do sistema.\n\n'
              'Isso pode impedir o funcionamento do aplicativo.\n\n'
              'Digite CONFIRMAR para continuar.',
            ),
            const SizedBox(height: 16),
            TextField(controller: controller),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (controller.text.trim().toUpperCase() == 'CONFIRMAR') {
                confirmed = true;
                Navigator.pop(context);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _sectionTitle('Aparência'),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: themeController,
              builder: (_, __) => SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Modo Escuro'),
                subtitle: const Text('Alternar entre tema claro e escuro'),
                value: themeController.isDarkMode,
                onChanged: (value) async {
                  await themeController.toggleTheme(value);
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle('Sistema'),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Versão'),
                  trailing: Text(
                    _appVersion,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Ambiente'),
                  trailing: Chip(
                    label: Text(AppConfig.environment),
                    backgroundColor: AppConfig.environment == 'DEV'
                        ? Colors.orange.shade200
                        : Colors.green.shade200,
                  ),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('Plataforma'),
                  subtitle: Text(Theme.of(context).platform.name.toUpperCase()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle('Projeto'),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Repositório'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: _openRepository,
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.edit_document),
                  title: const Text('Licença MIT'),
                  trailing: const Icon(Icons.visibility),
                  onTap: _showLicenseDialog,
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.handyman),
                  title: const Text('Suporte técnico'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: _openSupport,
                ),

                const Divider(height: 1),

                AboutListTile(
                  icon: const Icon(Icons.info),
                  applicationName: 'ONCredit',
                  applicationVersion: _appVersion,
                  applicationLegalese: '© 2026 André Luferat / ONCredit',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle('Administração'),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('UID Atual'),
                  subtitle: Text(AppConfig.fixedUid),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Base URL'),
                  subtitle: Text(AppConfig.baseUrl),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.cleaning_services),
                  title: const Text('Resetar Configurações Locais'),
                  subtitle: const Text('Limpa preferências salvas'),
                  onTap: _resetLocalSettings,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _sectionTitle('Zona de Risco', color: Colors.red),

          Card(
            color: Colors.red.shade50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text(
                'Editar Configurações Críticas',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('Pode comprometer o funcionamento do app'),
              onTap: _editCriticalSettings,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  static const String _mitLicenseText = '''
MIT License

Copyright (c) 2026 André Luferat / ONCredit

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

____ Tradução PT-BR não oficial ____

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software e da documentação associada (o "Software"), para lidar com o Software sem restrições, incluindo, sem limitação, os direitos de usar, copiar, modificar, fundir, publicar, distribuir, sublicenciar e/ou vender cópias do Software, e para permitir que as pessoas a quem o Software for fornecido o façam, sujeitas às seguintes condições:

O aviso de direitos autorais acima e este aviso de permissão devem ser incluídos em todas as cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "NO ESTADO EM QUE SE ENCONTRA", SEM GARANTIA DE QUALQUER TIPO, EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO, ADEQUAÇÃO A UM FIM ESPECÍFICO E NÃO VIOLAÇÃO. EM NENHUMA CIRCUNSTÂNCIA OS AUTORES OU DETENTORES DOS DIREITOS AUTORAIS SERÃO RESPONSÁVEIS POR QUAISQUER REIVINDICAÇÕES, DANOS OU OUTRAS RESPONSABILIDADES, SEJA EM AÇÃO CONTRATUAL, EXTRACONTRATUAL OU DE OUTRA NATUREZA, DECORRENTES DE, OU RELACIONADAS COM, O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES COM O SOFTWARE.
''';

  void _showLicenseDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'MIT License',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(child: Text(_mitLicenseText)),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: color ?? Colors.grey[700],
        ),
      ),
    );
  }

  Future<void> _openRepository() async {
    final uri = Uri.parse('https://github.com/Luferat/oncredit');
    await launchUrl(uri);
  }

  Future<void> _openSupport() async {
    final uri = Uri.parse('https://github.com/Luferat/oncredit/issues');
    await launchUrl(uri);
  }

  Future<void> _resetLocalSettings() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resetar configurações'),
        content: const Text(
          'Isso apagará configurações locais e tema.\n\nContinuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configurações resetadas')));
  }
}
