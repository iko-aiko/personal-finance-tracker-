
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

    final transactionRef =
        userRef.collection('transactions');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance Tracker'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
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
                      child: const Text('Logout'),
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
        children: [
          // SAPAAN PENGGUNA
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
                padding: const EdgeInsets.all(20),
                color: Colors.deepPurple.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $nama!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Selamat datang di Personal Finance Tracker',
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

              return Card(
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Icon(
                    Icons.receipt_long,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                  title: const Text('Total Transaksi'),
                  subtitle: Text('$total transaksi'),
                ),
              );
            },
          ),

          // RIWAYAT TRANSAKSI
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: transactionRef
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Terjadi kesalahan saat mengambil data'),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Belum ada transaksi'),
                  );
                }

                final transactions = snapshot.data!.docs;

                return ListView.builder(
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

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ListTile(
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
                          backgroundColor: isIncome
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),

                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          '$type\nRp ${amount.toStringAsFixed(0)}',
                        ),

                        isThreeLine: true,

                        trailing: PopupMenuButton<String>(
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
                                      child: const Text('Hapus'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddTransactionPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
