import 'package:flutter/material.dart';

const _navy = Color(0xFF0C1A30);
const _blue = Color(0xFF3669C9);

Widget buildStepIndicator({required int step}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    child: Row(
      children: List.generate(3, (i) {
        final stepNum = i + 1;
        final isActive = stepNum == step;
        final isDone = stepNum < step;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone || isActive ? _blue : Colors.grey.shade200,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '$stepNum',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                ['Shipping', 'Payment', 'Review'][i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? _blue : Colors.grey.shade500,
                ),
              ),
              if (i < 2)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    ),
  );
}

Widget buildBottomButton({required String label, required VoidCallback? onTap}) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    ),
  );
}
