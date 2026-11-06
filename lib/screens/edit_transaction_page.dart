
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    titleController = TextEditingController(text: widget.title);
    amountController = TextEditingController(
      text: widget.amount.toString(),
    );
    noteController = TextEditingController(text: widget.note);

    type = widget.type;
  }

  Future<void> updateTransaction() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(
      amountController.text.trim(),
    );

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi data dengan benar!'),
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
          .doc(widget.documentId)
          .update({
        'title': title,
        'amount': amount,
        'type': type,
        'note': noteController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil diperbarui!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengubah: $e'),
        ),
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
      backgroundColor: const Color(0xFFFFF7FA),

      appBar: AppBar(
        title: const Text(
          'Edit Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            const Text(
              'Edit Keuanganmu ♡',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF554452),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Perbarui informasi transaksi kamu.',
              style: TextStyle(
                color: Color(0xFF9B8995),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

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
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color(0xFF65A77B),
                                  size: 28,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Pemasukan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF488B60),
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
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Color(0xFFD77FA5),
                                  size: 28,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Pengeluaran',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD77FA5),
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
                    'Catatan',
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

                  // BUTTON UPDATE
                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton.icon(
                      onPressed:
                          isLoading ? null : updateTransaction,
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
                            : 'Simpan Perubahan',
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

            const Center(
              child: Text(
                '♡ Keep your finances organized!',
                style: TextStyle(
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
