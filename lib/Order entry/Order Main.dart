// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'order entry.dart';
//
// class OrderMain extends StatefulWidget {
//   const OrderMain({super.key});
//
//   @override
//   State<OrderMain> createState() => _OrderMainState();
// }
//
// class _OrderMainState extends State<OrderMain> {
//   final CollectionReference productsRef =
//   FirebaseFirestore.instance.collection('Product');
//   final CollectionReference ordersRef =
//   FirebaseFirestore.instance.collection('OrderEntry');
//
//   String? selectedProductName;
//   double? selectedProductPrice;
//   final TextEditingController orderNoController = TextEditingController();
//   final TextEditingController productQtyController = TextEditingController();
//   final TextEditingController totalPriceController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Entry"),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               showDialog<String?>(
//                 context: context,
//                 barrierDismissible: true,
//                 barrierColor: Colors.black.withOpacity(0.2),
//                 builder: (context) {
//                   return StatefulBuilder(
//                     builder: (context, dialogSetState) {
//                       return Stack(
//                         children: [
//                           BackdropFilter(
//                             filter:
//                             ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                             child: Container(color: Colors.transparent),
//                           ),
//                           Dialog(
//                             backgroundColor: Colors.transparent,
//                             insetPadding:
//                             EdgeInsets.symmetric(horizontal: 16),
//                             child: Container(
//                               constraints: BoxConstraints(
//                                   maxHeight:
//                                   MediaQuery.of(context).size.height *
//                                       0.9),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFFDFD),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               padding: const EdgeInsets.all(16),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.stretch,
//                                   children: [
//                                     Center(
//                                         child: Text("New Order Entry")),
//                                     SizedBox(height: 12),
//                                     TextField(
//                                       controller: orderNoController,
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black)),
//                                         labelText: 'Order No',
//                                       ),
//                                     ),
//                                     SizedBox(height: 12),
//                                     StreamBuilder<QuerySnapshot>(
//                                       stream: productsRef.snapshots(),
//                                       builder: (context, snapshot) {
//                                         if (snapshot.connectionState ==
//                                             ConnectionState.waiting) {
//                                           return CircularProgressIndicator();
//                                         }
//
//                                         if (!snapshot.hasData ||
//                                             snapshot.data!.docs.isEmpty) {
//                                           return Text(
//                                               "No products available");
//                                         }
//
//                                         List<QueryDocumentSnapshot> docs =
//                                             snapshot.data!.docs;
//
//                                         print(
//                                             'Product docs count: ${docs.length}');
//
//                                         List<DropdownMenuItem<String>>
//                                         productItems = docs.map((doc) {
//                                           final data = doc.data()
//                                           as Map<String, dynamic>;
//                                           final productName =
//                                               data['name'] ?? 'Unnamed';
//                                           return DropdownMenuItem<String>(
//                                             value: productName,
//                                             child: Text(productName),
//                                           );
//                                         }).toList();
//
//                                         return DropdownButtonFormField<String>(
//                                           value: selectedProductName,
//                                           decoration: InputDecoration(
//                                             border: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.black)),
//                                             labelText: 'Product Name',
//                                           ),
//                                           items: productItems,
//                                           onChanged: (value) {
//                                             dialogSetState(() {
//                                               selectedProductName = value;
//
//                                               final selectedDoc = docs.firstWhere(
//                                                       (doc) {
//                                                     final data = doc.data()
//                                                     as Map<String, dynamic>;
//                                                     return data['name'] == value;
//                                                   });
//
//                                               final data = selectedDoc.data()
//                                               as Map<String, dynamic>;
//                                               selectedProductPrice =
//                                               (data['price'] is int)
//                                                   ? (data['price']
//                                               as int)
//                                                   .toDouble()
//                                                   : (data['price']
//                                               as double? ??
//                                                   0.0);
//
//                                               totalPriceController.text =
//                                                   selectedProductPrice
//                                                       .toString();
//                                             });
//                                           },
//                                         );
//                                       },
//                                     ),
//                                     SizedBox(height: 12),
//                                     TextField(
//                                       controller: productQtyController,
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black)),
//                                         labelText: 'Product Qty',
//                                       ),
//                                     ),
//                                     SizedBox(height: 12),
//                                     TextField(
//                                       controller: totalPriceController,
//                                       readOnly: true,
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: Colors.black)),
//                                         labelText: 'Product Price',
//                                       ),
//                                     ),
//                                     SizedBox(height: 12),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text("Cancel"),
//                                         ),
//                                         TextButton(
//                                           onPressed: () async {
//                                             if (orderNoController
//                                                 .text.isEmpty ||
//                                                 selectedProductName == null ||
//                                                 productQtyController
//                                                     .text.isEmpty ||
//                                                 totalPriceController
//                                                     .text.isEmpty) {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(
//                                                 SnackBar(
//                                                     content: Text(
//                                                         'Please fill all fields')),
//                                               );
//                                               return;
//                                             }
//
//                                             final qty = int.tryParse(
//                                                 productQtyController.text) ??
//                                                 1;
//                                             final pricePerUnit = double.tryParse(
//                                                 totalPriceController.text) ??
//                                                 0.0;
//                                             final totalPrice =
//                                                 pricePerUnit * qty;
//
//                                             await ordersRef.add({
//                                               'orderNo':
//                                               orderNoController.text,
//                                               'productName': selectedProductName,
//                                               'productQty': qty,
//                                               'pricePerUnit': pricePerUnit,
//                                               'totalPrice': totalPrice,
//                                               'timestamp':
//                                               FieldValue.serverTimestamp(),
//                                             });
//
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                   content: Text(
//                                                       'Order saved successfully')),
//                                             );
//
//                                             Navigator.pop(context);
//                                           },
//                                           child: Text("Save"),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream:
//         ordersRef.orderBy('timestamp', descending: true).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//                 child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No orders yet"));
//           }
//
//           final docs = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;
//
//               final orderNo = data['orderNo'] ?? 'N/A';
//               final productName = data['productName'] ?? 'N/A';
//               final qty = data['productQty']?.toString() ?? '0';
//               final pricePerUnit =
//                   data['pricePerUnit']?.toString() ?? '0';
//               final totalPrice = data['totalPrice']?.toString() ?? '0';
//
//               return InkWell(onTap: () async {
//                 final productName = data['productName'] ?? '';
//
//                 // Get product data from Product collection
//                 final productSnapshot = await FirebaseFirestore.instance
//                     .collection('Product')
//                     .where('name', isEqualTo: productName)
//                     .limit(1)
//                     .get();
//
//                 Map<String, dynamic>? productData;
//                 if (productSnapshot.docs.isNotEmpty) {
//                   productData =
//                   productSnapshot.docs.first.data() as Map<String, dynamic>;
//                 }
//
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => OrderDetailPage(
//                       orderData: data,
//                       productData: productData,
//                     ),
//                   ),
//                 );
//               },
//
//                 child: Card(
//                   margin:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     title: Text('Order No: $orderNo'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Product: $productName'),
//                         Text('Qty: $qty'),
//                         Text('Price/Unit: $pricePerUnit'),
//                         Text('Total Price: $totalPrice'),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order entry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Entry App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const OrderMain(),
    );
  }
}

class OrderMain extends StatefulWidget {
  const OrderMain({super.key});

  @override
  State<OrderMain> createState() => _OrderMainState();
}

class _OrderMainState extends State<OrderMain> {
  final CollectionReference productsRef =
  FirebaseFirestore.instance.collection('Product');
  final CollectionReference ordersRef =
  FirebaseFirestore.instance.collection('OrderEntry');

  final TextEditingController orderNoController = TextEditingController();
  List<Map<String, dynamic>> selectedProducts = [];

  void addEmptyProduct() {
    selectedProducts.add({
      'name': null,
      'pricePerUnit': 0.0,
      'qty': 1,
      'totalPrice': 0.0,
    });
    setState(() {});
  }

  double calculateGrandTotal() {
    return selectedProducts.fold(
        0,
            (sum, item) =>
        sum + (item['pricePerUnit'] ?? 0) * (item['qty'] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Entry')),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('No orders yet'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final orderNo = data['orderNo'];
              final products = (data['products'] as List<dynamic>?) ?? [];
              final grandTotal = data['grandTotal'];

              return InkWell(onTap: () {
                final orderNo = data['orderNo'] ?? 'N/A';
                final products = (data['products'] as List<dynamic>?) ?? [];
                final grandTotal = data['grandTotal'] ?? 0.0;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrderDetailPage(
                      orderNo: orderNo,
                      products: products,
                      grandTotal: grandTotal,
                    ),
                  ),
                );
              },

                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Order No: $orderNo'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...products.map((p) => Text(
                            '${p['name']} - Qty: ${p['qty']} @ ${p['pricePerUnit']}')),
                        Text('Grand Total: $grandTotal'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          selectedProducts = [];
          addEmptyProduct();

          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, dialogSetState) {
                return AlertDialog(
                  title: const Text('New Order Entry'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: orderNoController,
                            decoration: const InputDecoration(
                              labelText: 'Order No',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(selectedProducts.length, (index) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: productsRef.snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const CircularProgressIndicator();

                                List<QueryDocumentSnapshot> docs =
                                    snapshot.data!.docs;

                                List<DropdownMenuItem<String>> productItems =
                                docs.map((doc) {
                                  final data =
                                  doc.data() as Map<String, dynamic>;
                                  return DropdownMenuItem<String>(
                                    value: data['name'],
                                    child: Text(data['name']),
                                  );
                                }).toList();

                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: selectedProducts[index]['name'],
                                      items: productItems,
                                      hint: const Text('Select Product'),
                                      onChanged: (value) {
                                        final doc = docs.firstWhere((doc) =>
                                        (doc.data() as Map<String, dynamic>)[
                                        'name'] ==
                                            value);
                                        final data = doc.data()
                                        as Map<String, dynamic>;
                                        dialogSetState(() {
                                          selectedProducts[index]['name'] =
                                              value;
                                          selectedProducts[index]
                                          ['pricePerUnit'] =
                                          (data['price'] is int)
                                              ? (data['price'] as int)
                                              .toDouble()
                                              : (data['price']
                                          as double?) ??
                                              0.0;
                                          selectedProducts[index]
                                          ['totalPrice'] =
                                              selectedProducts[index]
                                              ['pricePerUnit'] *
                                                  selectedProducts[index]['qty'];
                                        });
                                      },
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'Quantity'),
                                      onChanged: (val) {
                                        int qty = int.tryParse(val) ?? 1;
                                        dialogSetState(() {
                                          selectedProducts[index]['qty'] = qty;
                                          selectedProducts[index]
                                          ['totalPrice'] =
                                              selectedProducts[index]
                                              ['pricePerUnit'] *
                                                  qty;
                                        });
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                );
                              },
                            );
                          }),
                          TextButton(
                            onPressed: () {
                              dialogSetState(() {
                                addEmptyProduct();
                              });
                            },
                            child: const Text('Add Another Product'),
                          ),
                          const SizedBox(height: 16),
                          Text(
                              'Grand Total: ${calculateGrandTotal().toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () async {
                        if (orderNoController.text.isEmpty ||
                            selectedProducts.any(
                                    (p) => p['name'] == null || p['qty'] <= 0)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Fill Order No & all product details')),
                          );
                          return;
                        }

                        await ordersRef.add({
                          'orderNo': orderNoController.text,
                          'products': selectedProducts,
                          'grandTotal': calculateGrandTotal(),
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order Saved')),
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Save Order'),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}