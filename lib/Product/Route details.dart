import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteStepsForm extends StatefulWidget {
  const RouteStepsForm({super.key});

  @override
  State<RouteStepsForm> createState() => _RouteStepsFormState();
}

class _RouteStepsFormState extends State<RouteStepsForm> {
  final TextEditingController laborChargeCtrl = TextEditingController();
  final TextEditingController workingTimeCtrl = TextEditingController();
  final TextEditingController quantityCtrl = TextEditingController();

  String? selectedUnit;
  String? selectedMaterial;

  List<Map<String, String>> materialEntries = [];

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      workingTimeCtrl.text = "${time.hour}h ${time.minute}m";
    }
  }

  void addMaterialEntry() {
    if (selectedMaterial != null &&
        quantityCtrl.text.isNotEmpty &&
        selectedUnit != null) {
      setState(() {
        materialEntries.add({
          "material": selectedMaterial!,
          "quantity": quantityCtrl.text,
          "unit": selectedUnit!,
        });

        // Clear after adding
        selectedMaterial = null;
        quantityCtrl.clear();
        selectedUnit = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all material fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close, color: Colors.black)),
        title: const Text(
          "Route Steps",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Route Steps",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 16),

              const Text("Section 1 Labor Charge"),
              const SizedBox(height: 8),
              TextField(
                controller: laborChargeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "0.00",
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("\$",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Section 1 Working Time"),
              const SizedBox(height: 8),
              TextField(
                controller: workingTimeCtrl,
                readOnly: true,
                onTap: pickTime,
                decoration: InputDecoration(
                  hintText: "Select Time",
                  suffixIcon:
                  const Icon(Icons.access_time, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Section 1 Raw Material"),
              const SizedBox(height: 8),
              DropdownSearch<String>(
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                ),
                items: ["Steel", "Cement", "Wood", "Plastic", "Copper"],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Material",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onChanged: (val) {
                  setState(() => selectedMaterial = val);
                },
                selectedItem: selectedMaterial,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
                        labelText: "Quantity",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Unit",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text("Select"),
                      value: selectedUnit,
                      items: ["Kg", "Litre", "Piece"].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedUnit = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: addMaterialEntry,
                child: const Text("Add Material"),
              ),

              const SizedBox(height: 24),
              if (materialEntries.isNotEmpty)
                DataTable(
                  columns: const [
                    DataColumn(label: Text("Material")),
                    DataColumn(label: Text("Quantity")),
                    DataColumn(label: Text("Unit")),
                  ],
                  rows: materialEntries
                      .map(
                        (entry) => DataRow(
                      cells: [
                        DataCell(Text(entry["material"]!)),
                        DataCell(Text(entry["quantity"]!)),
                        DataCell(Text(entry["unit"]!)),
                      ],
                    ),
                  ).toList(),
                ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () async {
            if (laborChargeCtrl.text.isEmpty ||
                workingTimeCtrl.text.isEmpty ||
                materialEntries.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please complete the step before saving")),
              );
              return;
            }

            final prefs = await SharedPreferences.getInstance();
            final List<String> existingSteps =
                prefs.getStringList('savedRouteSteps') ?? [];

            final stepData = {
              "laborCharge": laborChargeCtrl.text,
              "workingTime": workingTimeCtrl.text,
              "materials": materialEntries.map((e) => "${e['material']}|${e['quantity']}|${e['unit']}").join(','),
            };

            existingSteps.add(stepData.entries.map((e) => "${e.key}=${e.value}").join(';'));

            await prefs.setStringList('savedRouteSteps', existingSteps);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Step saved locally")),
            );
print("stepData$stepData");
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Save Step", style: TextStyle(fontSize: 16)),
        ),

      ),
    );
  }
}
