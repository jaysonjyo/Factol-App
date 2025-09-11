import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Route details.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedUnit;
  String? _selectedRoute;
  bool _isActive = false;

  List<String> units = [];
  List<Map<String, dynamic>> routes = [];
  List<String> steps = [];

  @override
  void initState() {
    super.initState();
    _fetchUnits();
    _fetchRoutes();
    _loadLocalData();
  }

  Future<void> _fetchUnits() async {
    final snapshot = await FirebaseFirestore.instance.collection("Unit").get();
    setState(() {
      units = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  Future<void> _fetchRoutes() async {
    final snapshot = await FirebaseFirestore.instance.collection("Route").get();
    setState(() {
      routes = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "name": data.containsKey("name") ? data["name"].toString() : "Unnamed",
          "steps": data.containsKey("steps")
              ? List<String>.from(data["steps"])
              : <String>[],
        };
      }).toList();
    });
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _productIdController.text = prefs.getString('productId') ?? '';
      _nameController.text = prefs.getString('productName') ?? '';
      _priceController.text = prefs.getString('productPrice') ?? '';
      _selectedUnit = prefs.getString('productUnit');
      _selectedRoute = prefs.getString('productRoute');
      _isActive = prefs.getBool('productActive') ?? false;

      final storedSteps = prefs.getString('productSteps');
      steps = storedSteps != null ? storedSteps.split('|') : [];

      if (_selectedRoute != null && steps.isEmpty) {
        _onRouteSelected(_selectedRoute);
      }
    });
  }

  Future<void> _saveLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('productId', _productIdController.text);
    await prefs.setString('productName', _nameController.text);
    await prefs.setString('productPrice', _priceController.text);
    if (_selectedUnit != null) await prefs.setString('productUnit', _selectedUnit!);
    if (_selectedRoute != null) await prefs.setString('productRoute', _selectedRoute!);

    await prefs.setBool('productActive', _isActive);
    await prefs.setString('productSteps', steps.join('|'));
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('productId');
    await prefs.remove('productName');
    await prefs.remove('productPrice');
    await prefs.remove('productUnit');
    await prefs.remove('productRoute');
    await prefs.remove('productActive');
    await prefs.remove('productSteps');
  }

  void _onRouteSelected(String? routeName) {
    setState(() {
      _selectedRoute = routeName;
      if (routeName == null) {
        steps = [];
      } else {
        final selected = routes.firstWhere(
              (r) => r["name"] == routeName,
          orElse: () => <String, Object>{"steps": <String>[]},
        );
        steps = List<String>.from(selected["steps"] ?? []);
      }
      _saveLocalData();
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Discard changes?"),
        content: const Text("Do you want to go back without saving?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Stay"),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Back"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () async {
              final shouldPop = await _showExitConfirmationDialog();
              if (shouldPop) Navigator.pop(context);
            },
          ),
          title: Text(
            "Create Product",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Basics",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Define the core attributes of your product.",
                      style: GoogleFonts.inter(color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      "Product ID (Optional)",
                      "Enter ProductID",
                      _productIdController,
                      onChanged: (_) => _saveLocalData(),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      "Name (Required)",
                      "Enter ProductName (2–60 characters)",
                      _nameController,
                      onChanged: (_) => _saveLocalData(),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      "Unit",
                      "Select",
                      units,
                      _selectedUnit,
                          (val) {
                        setState(() {
                          _selectedUnit = val;
                        });
                        _saveLocalData();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      "Price",
                      "0.00",
                      _priceController,
                      suffix: const Icon(Icons.attach_money),
                      onChanged: (_) => _saveLocalData(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Active",
                            style: GoogleFonts.inter(fontSize: 16)),
                        Switch(
                          value: _isActive,
                          onChanged: (val) {
                            setState(() {
                              _isActive = val;
                            });
                            _saveLocalData();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Route",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      "Select Route",
                      "Select Route",
                      routes.map((r) => r['name'].toString()).toList(),
                      _selectedRoute,
                      _onRouteSelected,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Steps",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    steps.isEmpty
                        ? Text("No steps found for this route",
                        style: GoogleFonts.inter(color: Colors.grey))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      itemBuilder: (ctx, i) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RouteStepsForm()));
                        },
                        child: ListTile(
                          title: Text(
                            steps[i],
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "Step ${i + 1}",
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border:
                Border(top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final shouldPop = await _showExitConfirmationDialog();
                      if (shouldPop) Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final documentid =
                      DateTime.now().microsecondsSinceEpoch.toString();
                      final docRef = _productIdController.text.trim().isNotEmpty
                          ? FirebaseFirestore.instance
                          .collection("Product")
                          .doc(_productIdController.text.trim())
                          : FirebaseFirestore.instance
                          .collection("Product").doc();

                      final List<Map<String, dynamic>> stepMaps =
                      steps.asMap().entries.map((entry) {
                        return {
                          "order": entry.key + 1,
                          "name": entry.value,
                        };
                      }).toList();

                      await docRef.set({
                        "id": documentid,
                        "productId": _productIdController.text.trim(),
                        "name": _nameController.text.trim(),
                        "price":
                        double.tryParse(_priceController.text) ?? 0.0,
                        "unit": _selectedUnit,
                        "active": _isActive,
                        "route": _selectedRoute,
                        "steps": stepMaps,
                        "createdAt": FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                      await _clearLocalData();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Save"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller,
      {Widget? suffix, ValueChanged<String>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String hint, List<String> items,
      String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          decoration: InputDecoration(
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
