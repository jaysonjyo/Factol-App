import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<Map<String, dynamic>> routes = []; // keep id + name + steps
  List<String> steps = [];

  @override
  void initState() {
    super.initState();
    _fetchUnits();
    _fetchRoutes();

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
      print("routes$routes");
    });
  }
  void _onRouteSelected(String? routeName) {
    print("routeName$routeName");
    setState(() {
      _selectedRoute = routeName;

      if (routeName == null) {
        steps = [];
        print("steps$steps");
        return;
      }

      final selected = routes.firstWhere(
            (r) => r["name"] == routeName,
        orElse: () => <String, Object>{"steps": <String>[]},
      );

      print("selected$selected");
      steps = List<String>.from(selected["steps"] ?? []);
      print("steps$steps");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                  // Image placeholder
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

                  // Section title
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

                  // Product ID
                  _buildTextField("Product ID (Optional)", "Enter ProductID",
                      _productIdController),
                  const SizedBox(height: 16),

                  // Name
                  _buildTextField(
                      "Name (Required)",
                      "Enter ProductName (2–60 characters)",
                      _nameController),
                  const SizedBox(height: 16),

                  // Unit dropdown
                  _buildDropdown("Unit", "Select", units, _selectedUnit,
                          (val) => setState(() => _selectedUnit = val)),
                  const SizedBox(height: 16),

                  // Price field
                  _buildTextField("Price", "0.00", _priceController,
                      suffix: const Icon(Icons.attach_money)),
                  const SizedBox(height: 16),

                  // Active switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Active",
                          style: GoogleFonts.inter(fontSize: 16)),
                      Switch(
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Route section
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

                  // Steps section
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
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(
                        steps[i],
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Step ${i + 1}",
                        style: GoogleFonts.inter(color: Colors.grey),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer buttons
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final documentid = DateTime.now().microsecondsSinceEpoch.toString();
                    final docRef = _productIdController.text.trim().isNotEmpty
                        ? FirebaseFirestore.instance
                        .collection("Product")
                        .doc(_productIdController.text.trim()
                    )
                        : FirebaseFirestore.instance.collection("Product").doc();

                    // Convert steps list into structured map
                    final List<Map<String, dynamic>> stepMaps = steps.asMap().entries.map((entry) {
                      return {
                        "order": entry.key + 1, // step number
                        "name": entry.value,    // step name
                      };
                    }).toList();

                    await docRef.set({
                      "id":documentid,
                      "productId": _productIdController.text.trim(),
                      "name": _nameController.text.trim(),
                      "price": double.tryParse(_priceController.text) ?? 0.0,
                      "unit": _selectedUnit,
                      "active": _isActive,
                      "route": _selectedRoute,
                      "steps": stepMaps, // save as structured maps
                      "createdAt": FieldValue.serverTimestamp(),
                    }, SetOptions(merge: true));

                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Save"),
                ),



              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller,
      {Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
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
