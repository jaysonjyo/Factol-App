import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Steps.dart';

class RoutesScreen extends StatefulWidget {
  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final firestore=FirebaseFirestore.instance.collection("Route");

  void _addNewRoute() async {
    final TextEditingController nameController = TextEditingController();
    IconData? selectedIcon;

    final newRoute = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Add New Route"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(style: TextStyle(decorationThickness:0),
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // TextField(
                    //   controller: stepsController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     labelText: "Steps",
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    const Text("Choose an Icon:"),
                    Wrap(
                      spacing: 12,
                      children: [
                        for (var icon in [
                          Icons.checkroom,
                          Icons.umbrella,
                          Icons.local_mall,
                          Icons.star,
                        ])
                          GestureDetector(
                            onTap: () {
                              setDialogState(() => selectedIcon = icon);
                            },
                            child: CircleAvatar(
                              backgroundColor: selectedIcon == icon
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade200,
                              child: Icon(icon,
                                  color: selectedIcon == icon
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        selectedIcon == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Enter name and select icon")),
                      );
                      return;
                    }
                    Navigator.pop(ctx, {
                      'name': nameController.text.trim(),
                      'steps': <String>[],
                      'iconCodePoint': selectedIcon!.codePoint,
                     // save icon code
                    });
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );

    // if (newRoute != null) {
    //   await firestore.add(newRoute);
    // }
    if (newRoute != null) {
      // save to Firestore and get document reference
      final docRef = await firestore.add(newRoute);
print("newRoute = $newRoute");
      print("docRef.id = ${docRef.id}");
      // go to another page right after creation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewRoutePage(
            routeId: docRef.id,   // pass doc ID
            routeData: newRoute,

          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          "Routes",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed:_addNewRoute,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:firestore.snapshots(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Routes found"));
          }
          final routes = snapshot.data!.docs;
          return ListView.separated(
            itemCount: routes.length,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final routeData = routes[index].data() as Map<String, dynamic>;
              final name = routeData['name'] ?? "Unnamed";
              final steps = (routeData['steps'] as List<dynamic>? ?? []).cast<String>();
              final iconCodePoint = routeData['iconCodePoint'] ?? Icons.checkroom.codePoint;
              print("steps $steps");
              print("name $name");
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child:  Icon( IconData(iconCodePoint, fontFamily: 'MaterialIcons'), color: Colors.black),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${steps.length} steps"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final updatedSteps = await Navigator.of(context).push<List<String>>(
                      MaterialPageRoute(
                        builder: (_) => NewRoutePage(
                          routeId: routes[index].id,
                          routeData: routeData,),
                      ),
                    );

                    if (updatedSteps != null) {
                      // Update steps in Firestore
                      await firestore.doc(routes[index].id).update({
                        'steps': updatedSteps,
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
