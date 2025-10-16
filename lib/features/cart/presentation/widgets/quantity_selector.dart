import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int>? onChanged;

  const QuantitySelector({super.key, required this.quantity, this.onChanged});

  Widget _verticalDivider() => SizedBox(
    height: 24,
    child: VerticalDivider(
      color: Colors.grey.shade400,
      thickness: 1,
      width: 16,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove_circle_outline_rounded, () {
            if (quantity > 1) onChanged?.call(quantity - 1);
          }),
          _verticalDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          _verticalDivider(),
          _buildButton(
            Icons.add_circle_outline_rounded,
            () => onChanged?.call(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 20),
        ),
      ),
    );
  }
}
