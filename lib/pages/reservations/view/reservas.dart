import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/reservations/widget/fieldcard.dart';
import 'package:hotel_real_merced/pages/reservations/widget/guestscard.dart';
import 'package:hotel_real_merced/pages/reservations/widget/sumaryrow.dart';

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
    final initial = isCheckIn
        ? (_checkIn ?? now)
        : (_checkOut ?? now.add(const Duration(days: 1)));
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
              const Text(
                'Último paso',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),

              Fieldcard(
                title: 'Check‑in',
                subtitle: _checkIn == null
                    ? 'Selecciona fecha'
                    : _formatDate(_checkIn!),
                icon: Icons.login,
                onTap: () => _pickDate(isCheckIn: true),
              ),
              const SizedBox(height: 12),
              Fieldcard(
                title: 'Check‑out',
                subtitle: _checkOut == null
                    ? 'Selecciona fecha'
                    : _formatDate(_checkOut!),
                icon: Icons.logout,
                onTap: () => _pickDate(isCheckIn: false),
              ),
              const SizedBox(height: 12),
              Guestscard(
                value: _huespedes,
                onChanged: (v) => setState(() => _huespedes = v),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Resumen',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Sumaryrow(
                label: 'Tipo de habitación',
                value: 'Suite Deluxe',
              ),
              Sumaryrow(label: 'Huéspedes', value: '$_huespedes'),
              Sumaryrow(label: 'Noches', value: _nightsLabel()),
              const Sumaryrow(label: 'Precio por noche', value: '\$120'),
              const Sumaryrow(label: 'Impuestos', value: 'Incluidos'),
              const SizedBox(height: 12),
              Sumaryrow(label: 'Total', value: _totalLabel(), bold: true),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _canPay()
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reserva confirmada (demo).'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Confirmar y pagar'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canPay() =>
      _checkIn != null && _checkOut != null && !_checkOut!.isBefore(_checkIn!);
  String _nightsLabel() {
    if (_checkIn == null || _checkOut == null) return '-';
    return _checkOut!.difference(_checkIn!).inDays.toString();
  }

  String _totalLabel() {
    if (_checkIn == null || _checkOut == null) return '-';
    final nights = _checkOut!.difference(_checkIn!).inDays;
    final total = 120 * (nights > 0 ? nights : 1);
    return '\$$total';
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
