
import 'package:flutter/material.dart';

class DetailTransactionPage extends StatelessWidget {
  final String title;
  final double amount;
  final String type;
  final String note;

  const DetailTransactionPage({
    super.key,
    required this.title,
    required this.amount,
    required this.type,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = type == 'Pemasukan';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Transaksi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: isIncome
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Icon(
                  isIncome
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 45,
                  color: isIncome
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Center(
              child: Text(
                'Rp ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const Text(
              'Judul Transaksi',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Jenis Transaksi',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              type,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Catatan',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              note.isEmpty ? 'Tidak ada catatan' : note,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
