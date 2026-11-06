
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
    final isIncome = type == 'Pemasukan';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),

      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF8DCE8),
        foregroundColor: const Color(0xFF554452),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Catat Keuanganmu ♡',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF554452),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Jangan lupa catat setiap transaksi kamu!',
              style: TextStyle(
                color: Color(0xFF9B8995),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            // FORM CARD
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE8A8C4)
                        .withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL
                  const Text(
                    'Judul Transaksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF554452),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Uang jajan',
                      prefixIcon: const Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFFD77FA5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFF7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // NOMINAL
                  const Text(
                    'Nominal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF554452),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan nominal',
                      prefixIcon: const Icon(
                        Icons.payments_outlined,
                        color: Color(0xFFD77FA5),
                      ),
                      prefixText: 'Rp ',
                      filled: true,
                      fillColor: const Color(0xFFFFF7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // JENIS TRANSAKSI
                  const Text(
                    'Jenis Transaksi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF554452),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              type = 'Pemasukan';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: type == 'Pemasukan'
                                  ? const Color(0xFFE2F3E8)
                                  : const Color(0xFFFFF7FA),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: type == 'Pemasukan'
                                    ? const Color(0xFF65A77B)
                                    : const Color(0xFFF0E5EB),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color(0xFF65A77B),
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Pemasukan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: type == 'Pemasukan'
                                        ? const Color(0xFF488B60)
                                        : const Color(0xFF9B8995),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              type = 'Pengeluaran';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: type == 'Pengeluaran'
                                  ? const Color(0xFFF8DCE8)
                                  : const Color(0xFFFFF7FA),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: type == 'Pengeluaran'
                                    ? const Color(0xFFD77FA5)
                                    : const Color(0xFFF0E5EB),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Color(0xFFD77FA5),
                                  size: 28,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Pengeluaran',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: type == 'Pengeluaran'
                                        ? const Color(0xFFD77FA5)
                                        : const Color(0xFF9B8995),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // CATATAN
                  const Text(
                    'Catatan (Opsional)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF554452),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan catatan...',
                      prefixIcon: const Icon(
                        Icons.notes_rounded,
                        color: Color(0xFFD77FA5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFF7FA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // BUTTON SIMPAN
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton.icon(
                      onPressed:
                          isLoading ? null : saveTransaction,
                      icon: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(
                        isLoading
                            ? 'Menyimpan...'
                            : 'Simpan Transaksi',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8A8C4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                isIncome
                    ? '♡ Semangat menabung!'
                    : '♡ Gunakan uang dengan bijak!',
                style: const TextStyle(
                  color: Color(0xFFB69AA9),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
