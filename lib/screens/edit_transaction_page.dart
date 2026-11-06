
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTransactionPage extends StatefulWidget {
  final String documentId;
  final String title;
  final double amount;
  final String type;
  final String note;

  const EditTransactionPage({
    super.key,
    required this.documentId,
    required this.title,
    required this.amount,
    required this.type,
    required this.note,
  });

  @override
  State<EditTransactionPage> createState() =>
      _EditTransactionPageState();
}

class _EditTransactionPageState
    extends State<EditTransactionPage> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController noteController;

  late String type;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.title);

    amountController =
        TextEditingController(
          text: widget.amount.toString(),
        );

    noteController =
        TextEditingController(text: widget.note);

    type = widget.type;
  }

  Future<void> updateTransaction() async {
    final title = titleController.text.trim();
    final amount =
        double.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi data dengan benar!'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            // UID pengguna akan kita hubungkan melalui Firebase Auth
          )
          .collection('transactions')
          .doc(widget.documentId)
          .update({
        'title': title,
        'amount': amount,
        'type': type,
        'note': noteController.text.trim(),
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah: $e')),
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
        title: const Text('Edit Transaksi'),
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
              keyboardType:
                  const TextInputType.numberWithOptions(
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
                labelText: 'Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : updateTransaction,
              child: Text(
                isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
