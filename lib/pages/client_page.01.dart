import 'package:flutter/material.dart';
import '../models/client.dart';
import '../templates/appbar.dart';

class ClientPage extends StatelessWidget {
  final Client client;

  const ClientPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text('CPF: ${client.cpf}'),
            const SizedBox(height: 16),

            // Aqui depois entra o resumo financeiro do cliente
            const Divider(),

            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Registrar compra'),
              onTap: () {
                // navegar para PurchasePage
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Registrar pagamento'),
              onTap: () {
                // navegar para PaymentPage
              },
            ),
          ],
        ),
      ),
    );
  }
}
