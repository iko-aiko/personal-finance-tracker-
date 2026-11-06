
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'add_transaction_page.dart';
import 'edit_transaction_page.dart';
import 'detail_transaction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('User belum login'),
        ),
      );
    }

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final transactionRef = userRef.collection('transactions');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),

      appBar: AppBar(
        title: const Text(
          'My Finance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        backgroundColor: const Color(0xFFF8DCE8),
        foregroundColor: const Color(0xFF554452),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text('Logout'),
                  content: const Text(
                    'Apakah kamu yakin ingin keluar?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Color(0xFFD77FA5),
                        ),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER DAN SAPAAN
          StreamBuilder<DocumentSnapshot>(
            stream: userRef.snapshots(),
            builder: (context, snapshot) {
              String nama = 'Pengguna';

              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data()
                    as Map<String, dynamic>;

                nama = data['nama'] ?? 'Pengguna';
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF8DCE8),
                      Color(0xFFE9DDF8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello, welcome back!',
                      style: TextStyle(
                        color: Color(0xFF8B7181),
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Halo, $nama! ♡',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF554452),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Yuk, kelola keuanganmu hari ini.',
                      style: TextStyle(
                        color: Color(0xFF806D7B),
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Color(0xFFD77FA5),
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Personal Finance Tracker',
                          style: TextStyle(
                            color: Color(0xFF554452),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // TOTAL TRANSAKSI
          StreamBuilder<QuerySnapshot>(
            stream: transactionRef.snapshots(),
            builder: (context, snapshot) {
              final total = snapshot.hasData
                  ? snapshot.data!.docs.length
                  : 0;

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE8A8C4)
                          .withOpacity(0.12),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8DCE8),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFFD77FA5),
                        size: 32,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Transaksi',
                          style: TextStyle(
                            color: Color(0xFF9B8995),
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '$total transaksi',
                          style: const TextStyle(
                            color: Color(0xFF554452),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 25),

          // JUDUL RIWAYAT
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: Color(0xFFD77FA5),
                ),
                SizedBox(width: 8),
                Text(
                  'Riwayat Transaksi',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF554452),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DAFTAR TRANSAKSI
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: transactionRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Terjadi kesalahan saat mengambil data',
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD77FA5),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          size: 65,
                          color: Color(0xFFE8C5D5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            color: Color(0xFF9B8995),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Yuk, tambahkan transaksi pertamamu!',
                          style: TextStyle(
                            color: Color(0xFFB69AA9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final transactions = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 90,
                    left: 16,
                    right: 16,
                  ),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final document = transactions[index];

                    final data = document.data()
                        as Map<String, dynamic>;

                    final title = data['title'] ?? '';
                    final amount =
                        (data['amount'] as num?)?.toDouble() ?? 0;
                    final type = data['type'] ?? 'Pemasukan';
                    final note = data['note'] ?? '';

                    final isIncome = type == 'Pemasukan';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE8A8C4)
                                .withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailTransactionPage(
                                title: title,
                                amount: amount,
                                type: type,
                                note: note,
                              ),
                            ),
                          );
                        },

                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: isIncome
                              ? const Color(0xFFE2F3E8)
                              : const Color(0xFFF8DCE8),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: isIncome
                                ? const Color(0xFF65A77B)
                                : const Color(0xFFD77FA5),
                          ),
                        ),

                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF554452),
                            fontSize: 15,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            type,
                            style: const TextStyle(
                              color: Color(0xFF9B8995),
                              fontSize: 12,
                            ),
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${amount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isIncome
                                    ? const Color(0xFF65A77B)
                                    : const Color(0xFFD77FA5),
                              ),
                            ),

                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xFFB69AA9),
                              ),
                              onSelected: (value) async {
                                // EDIT TRANSAKSI
                                if (value == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTransactionPage(
                                        documentId: document.id,
                                        title: title,
                                        amount: amount,
                                        type: type,
                                        note: note,
                                      ),
                                    ),
                                  );
                                }

                                // HAPUS TRANSAKSI
                                if (value == 'delete') {
                                  final confirm =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        'Hapus Transaksi',
                                      ),
                                      content: const Text(
                                        'Yakin ingin menghapus transaksi ini?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              false,
                                            );
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                              true,
                                            );
                                          },
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(
                                              color: Color(0xFFD77FA5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await transactionRef
                                        .doc(document.id)
                                        .delete();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Transaksi berhasil dihapus',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // TOMBOL TAMBAH TRANSAKSI
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE8A8C4),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionPage(),
            ),
          );
        },
      ),
    );
  }
}
