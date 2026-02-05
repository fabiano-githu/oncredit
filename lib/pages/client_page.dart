import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/finance_service.dart';
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

            const SizedBox(height: 16),
            const Divider(),

            FutureBuilder<Map<String, double>>(
              future: FinanceService().getClientSummary(client.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                final summary = snapshot.data!;

                return Card(
                  margin: const EdgeInsets.only(top: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumo financeiro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _line('Total em compras', summary['purchases']!),
                        _line('Total pago', summary['payments']!),
                        const Divider(),
                        _line('Saldo atual', summary['balance']!, bold: true),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
