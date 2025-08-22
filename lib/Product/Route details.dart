import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

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

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      workingTimeCtrl.text = "${time.hour}h ${time.minute}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.close, color: Colors.black),
        title: const Text(
          "Route Steps",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // leave space for button
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

              // Section 1 Labor Charge
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

              // Section 1 Working Time
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

              // Section 1 Raw Material
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
              ),

              const SizedBox(height: 16),

              // Quantity + Unit Row
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

            ],
          ),
        ),
      ),

      // Bottom Save Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            // save logic here
            debugPrint("Labor: ${laborChargeCtrl.text}");
            debugPrint("Time: ${workingTimeCtrl.text}");
            debugPrint("Material: $selectedMaterial");
            debugPrint("Qty: ${quantityCtrl.text} $selectedUnit");
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Save", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
