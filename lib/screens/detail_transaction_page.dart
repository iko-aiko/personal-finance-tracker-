
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

    const pink = Color(0xFFD77FA5);
    const darkText = Color(0xFF554452);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),

      appBar: AppBar(
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8DCE8),
        foregroundColor: darkText,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: isIncome
                        ? const Color(0xFFE5F4E8)
                        : const Color(0xFFFCE4EC),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 40,
                      color: isIncome
                          ? Colors.green
                          : pink,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isIncome ? 'Pemasukan' : 'Pengeluaran',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Rp ${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Transaksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Judul Transaksi',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Jenis Transaksi',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 17,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Catatan',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    note.isEmpty ? 'Tidak ada catatan' : note,
                    style: const TextStyle(
                      fontSize: 17,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
