import 'package:flutter/material.dart';

class HourlyForecastCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String degree;

  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.icon,
    required this.degree
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8,),
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(height: 8,),
              Text('$degree °C')
            ],
          ),
        ));
  }
}
