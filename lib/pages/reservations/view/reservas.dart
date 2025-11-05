import 'package:flutter/material.dart';

class Reservas extends StatefulWidget {
  const Reservas({super.key});

  @override
  State<Reservas> createState() => _ReservasState();
}

class _ReservasState extends State<Reservas> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _huespedes = 2;

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final initial = isCheckIn ? (_checkIn ?? now) : (_checkOut ?? now.add(const Duration(days: 1)));
    final result = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: initial,
    );
    if (result != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = result;
          if (_checkOut != null && _checkOut!.isBefore(_checkIn!)) {
            _checkOut = _checkIn!.add(const Duration(days: 1));
          }
        } else {
          _checkOut = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Último paso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              _FieldCard(
                title: 'Check‑in',
                subtitle: _checkIn == null ? 'Selecciona fecha' : _formatDate(_checkIn!),
                icon: Icons.login,
                onTap: () => _pickDate(isCheckIn: true),
              ),
              const SizedBox(height: 12),
              _FieldCard(
                title: 'Check‑out',
                subtitle: _checkOut == null ? 'Selecciona fecha' : _formatDate(_checkOut!),
                icon: Icons.logout,
                onTap: () => _pickDate(isCheckIn: false),
              ),
              const SizedBox(height: 12),
              _GuestsCard(
                value: _huespedes,
                onChanged: (v) => setState(() => _huespedes = v),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text('Resumen', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const _SummaryRow(label: 'Tipo de habitación', value: 'Suite Deluxe'),
              _SummaryRow(label: 'Huéspedes', value: '$_huespedes'),
              _SummaryRow(label: 'Noches', value: _nightsLabel()),
              const _SummaryRow(label: 'Precio por noche', value: '\$120'),
              const _SummaryRow(label: 'Impuestos', value: 'Incluidos'),
              const SizedBox(height: 12),
              _SummaryRow(label: 'Total', value: _totalLabel(), bold: true),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _canPay()
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reserva confirmada (demo).')),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Confirmar y pagar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canPay() => _checkIn != null && _checkOut != null && !_checkOut!.isBefore(_checkIn!);
  String _nightsLabel() {
    if (_checkIn == null || _checkOut == null) return '-';
    return _checkOut!.difference(_checkIn!).inDays.toString();
  }

  String _totalLabel() {
    if (_checkIn == null || _checkOut == null) return '-';
    final nights = _checkOut!.difference(_checkIn!).inDays;
    final total = 120 * (nights > 0 ? nights : 1);
    return '\$'+total.toString();
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.title, required this.subtitle, required this.icon, this.onTap});
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF667eea)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _GuestsCard extends StatelessWidget {
  const _GuestsCard({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.people_outline, color: Color(0xFF667eea)),
          const SizedBox(width: 12),
          const Expanded(child: Text('Huéspedes')),
          IconButton(
            onPressed: value > 1 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}
