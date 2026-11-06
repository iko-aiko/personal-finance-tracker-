
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String type = 'Pemasukan';
  bool isLoading = false;

  Future<void> saveTransaction() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi judul dan nominal dengan benar!'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
        'title': title,
        'amount': amount,
        'type': type,
        'note': noteController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Transaksi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Nominal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: type,
              decoration: const InputDecoration(
                labelText: 'Jenis Transaksi',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Pemasukan',
                  child: Text('Pemasukan'),
                ),
                DropdownMenuItem(
                  value: 'Pengeluaran',
                  child: Text('Pengeluaran'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            const SizedBox(height: 15),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : saveTransaction,
              child: Text(
                isLoading ? 'Menyimpan...' : 'Simpan Transaksi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
