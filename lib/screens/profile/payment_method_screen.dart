import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────

class PaymentCard {
  final String type; // 'Visa' / 'Mastercard'
  final String last4;
  final String expires;

  PaymentCard({
    required this.type,
    required this.last4,
    required this.expires,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT METHOD SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Data kartu — bisa disambungkan ke backend/database nanti
  final List<PaymentCard> _cards = [
    PaymentCard(type: 'Visa', last4: '8122', expires: '07 2028'),
    PaymentCard(type: 'Mastercard', last4: '4771', expires: '03 2029'),
  ];

  // ── Warna sesuai tema CryptoWise ──
  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _cardBg = Color(0xFF1C1C1C);
  static const Color _gold = Color(0xFFD4A017);
  static const Color _goldDark = Color(0xFF8B6914);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey = Color(0xFF888888);
  static const Color _red = Color(0xFFE53935);

  // ── Hapus kartu dengan konfirmasi dialog ──
  void _confirmDelete(int index) {
    final card = _cards[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Card?',
          style: TextStyle(color: _white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${card.type} •••• ${card.last4}',
              style: const TextStyle(color: _white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'This action cannot be undone',
              style: TextStyle(color: _grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _white, fontSize: 15),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cards.removeAt(index));
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                  color: _red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tambah kartu baru ──
  void _addCard() {
    final typeController = TextEditingController();
    final last4Controller = TextEditingController();
    final expiresController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1C),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Card',
              style: TextStyle(
                  color: _white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _inputField('Card Type (Visa / Mastercard)', typeController),
            const SizedBox(height: 12),
            _inputField('Last 4 Digits', last4Controller,
                keyboardType: TextInputType.number, maxLength: 4),
            const SizedBox(height: 12),
            _inputField('Expires (MM YYYY)', expiresController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (typeController.text.isNotEmpty &&
                      last4Controller.text.length == 4 &&
                      expiresController.text.isNotEmpty) {
                    setState(() {
                      _cards.add(PaymentCard(
                        type: typeController.text.trim(),
                        last4: last4Controller.text.trim(),
                        expires: expiresController.text.trim(),
                      ));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Save Card',
                  style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(color: _white),
      cursorColor: _gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _grey),
        counterText: '',
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      // ── App Bar ──
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: _white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
              color: _white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // ── Daftar kartu ──
            ..._cards.asMap().entries.map((entry) {
              final i = entry.key;
              final card = entry.value;
              return _CardTile(
                card: card,
                onDelete: () => _confirmDelete(i),
              );
            }),

            const SizedBox(height: 16),

            // ── Tombol Add More Card ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _goldDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _addCard,
                child: const Text(
                  '+ Add More Card',
                  style: TextStyle(
                      color: _white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD TILE WIDGET
// ─────────────────────────────────────────────────────────────────────────────

class _CardTile extends StatelessWidget {
  final PaymentCard card;
  final VoidCallback onDelete;

  const _CardTile({required this.card, required this.onDelete});

  static const Color _cardBg = Color(0xFF1C1C1C);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey = Color(0xFF888888);
  static const Color _gold = Color(0xFFD4A017);
  static const Color _red = Color(0xFFE53935);

  IconData get _cardIcon {
    if (card.type.toLowerCase() == 'mastercard') {
      return Icons.credit_card;
    }
    return Icons.credit_card;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 0.8),
      ),
      child: Row(
        children: [
          // ── Icon kartu ──
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.credit_card, color: _gold, size: 22),
          ),
          const SizedBox(width: 14),

          // ── Info kartu ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.type} •••• ${card.last4}',
                  style: const TextStyle(
                      color: _white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  'Expires ${card.expires}',
                  style: const TextStyle(color: _grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Tombol hapus ──
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: _red, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}