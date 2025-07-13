import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isIncome;

  const BalanceCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.isIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                isIncome ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: isIncome ? Colors.green : Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            // Menggunakan FittedBox untuk mencegah overflow pada teks jumlah
            Expanded( // Menggunakan Expanded agar FittedBox punya batasan ruang
              child: FittedBox(
                fit: BoxFit.scaleDown, // Mengurangi ukuran teks jika tidak muat
                alignment: Alignment.topLeft, // Menjaga teks rata kiri atas
                child: Text(
                  currencyFormatter.format(amount),
                  style: TextStyle(
                    fontSize: 20, // Ukuran font dasar
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green[700] : Colors.red[700],
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