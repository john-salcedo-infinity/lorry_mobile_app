import 'package:app_lorry/config/app_theme.dart';
import 'package:flutter/material.dart';

class SelectLoading extends StatelessWidget {
  const SelectLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Apptheme.backgroundColor,
        border: Border.all(
          color: Apptheme.lightGray,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Cargando..."),
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                  width: 12,
                  child: CircularProgressIndicator(
                    color: Apptheme.primary,
                    strokeWidth: 2,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
