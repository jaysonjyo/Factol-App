import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:factolapp/Order%20entry/product%20route%20details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class OrderDetailPage extends StatelessWidget {
  final String orderNo;
  final List<dynamic> products;
  final double grandTotal;

  const OrderDetailPage({
    super.key,
    required this.orderNo,
    required this.products,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details - $orderNo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order No: $orderNo',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index] as Map<String, dynamic>;
                  final productName = product['name'] ?? 'Unnamed Product';

                  return ListTile(
                    title: Text(productName),
                    subtitle: Text(
                        'Qty: ${product['qty']}, Price/Unit: ${product['pricePerUnit']}, Total: ${product['totalPrice']}'),
                      onTap: () async {
                        final snapshot = await FirebaseFirestore.instance
                            .collection('Product')
                            .where('name', isEqualTo: productName)
                            .limit(1)
                            .get();

                        if (snapshot.docs.isNotEmpty) {
                          final productData =
                          snapshot.docs.first.data() as Map<String, dynamic>;

                          final steps = (productData['steps'] as List<dynamic>?) ?? [];

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductStepsPage(
                                productName: productData['name'],
                                steps: steps,
                              ),
                            ),
                          );
                        }
                      }
                  );
                },
              ),

            ),
            const Divider(),
            Text('Grand Total: $grandTotal',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

