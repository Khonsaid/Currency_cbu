import 'package:flutter/material.dart';
import 'package:valyuta_kurslari/design/colors.dart';

class ItemLanguage extends StatelessWidget {
  final bool isSelected;
  final String text;
  final VoidCallback onTap;

  const ItemLanguage({super.key, required this.isSelected, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: isSelected ? AppColors.fontTernary : Colors.transparent)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.language),
                SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                      color: isSelected ? AppColors.fontTernary : AppColors.fontSecondary,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
                )
              ],
            ),
          ),
        ));
  }
}
