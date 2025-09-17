import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductStepsPage extends StatelessWidget {
  final String productName;
  final List<dynamic> steps;

  const ProductStepsPage({
    super.key,
    required this.productName,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Steps for $productName')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            final step = steps[index] as Map<String, dynamic>;
            return ListTile(
              title: Text(step['stepName'] ?? 'Unnamed Step'),
              subtitle: Text('Order: ${step['order']}'),
            );
          },
        ),
      ),
    );
  }
}


