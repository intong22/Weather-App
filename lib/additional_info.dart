import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String description;
  final String measure;


  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.description,
    required this.measure
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon, 
          size: 32
        ),
        const SizedBox(height: 8,),
        Text(description),
        const SizedBox(height: 8,),
        Text(
          measure,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
