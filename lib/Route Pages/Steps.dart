import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewRoutePage extends StatefulWidget {
  final String? routeId;
  final Map<String, dynamic>? routeData;

  const NewRoutePage({super.key,
    this.routeId,
     this.routeData,
   });

  @override
  State<NewRoutePage> createState() => _NewRoutePageState();
}

class _NewRoutePageState extends State<NewRoutePage> {

  late List<String> steps;
  @override
  void initState() {
    // TODO: implement initState
    steps = (widget.routeData?['steps'] as List<dynamic>? ?? []).cast<String>();
    _fetchSections();
    super.initState();
  }
  void _showAddStepSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      showDragHandle: true,
      isDismissible: false,
      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, bottomSheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Step",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Step ${steps.length + 1}",
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// 🔹 Constant highlight container (middle slot)
                      Container(
                        height: 40,
                        // margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),

                      /// 🔹 The scrollable list
                      SizedBox(
                        height: 100,
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          controller: FixedExtentScrollController(
                            initialItem: currentIndex,
                          ),
                          physics: FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            bottomSheetSetState(() {
                              currentIndex = index;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              if (index < 0 || index >= items.length)
                                return null;
                              bool isSelected = index == currentIndex;
                              return Container(
                                alignment: Alignment.centerRight,
                                // 👈 Right align text
                                padding: EdgeInsets.only(right: 20),
                                // space from border
                                child: Text(
                                  items[index],
                                  style: TextStyle(
                                    fontSize: isSelected ? 16 : 14,
                                    color:
                                    isSelected ? Colors.black : Colors.grey,
                                    fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel button
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 10),
                      // Save button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx,steps);
                          setState(() {
                            steps.add(items[currentIndex]);
                          });
                          print("steps $steps");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<String> items = [];

  int currentIndex = 0;
  Future<void> _fetchSections() async {
    final snapshot = await FirebaseFirestore.instance.collection("Section").get();

    setState(() {
      items = snapshot.docs
          .map((doc) => doc['name'] as String) // pick the `name` field
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "New Route",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "${steps.length} steps",
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text("    "),
              ),
            ),
            const SizedBox(height: 16),
            // Image Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/shirt.png"),
                  // replace with your asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Steps Section
            // Steps Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Steps",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  if (steps.isEmpty)
                    Text(
                      "No steps yet",
                      style: GoogleFonts.inter(color: Colors.grey),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true, // ✅ lets it size correctly inside Column
                      physics: const NeverScrollableScrollPhysics(), // ✅ prevent nested scroll
                      itemCount: steps.length,
                      itemBuilder: (ctx, i) => Row(
                        children: [
                          Text("Step ${i + 1} - ${steps[i]}"),
                          const Spacer(),
                          InkWell(onTap: () {  },
                          child: Icon(Icons.more_vert)),
                        ],
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 15),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Add Step Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black,
                  elevation: 0,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _showAddStepSheet,
                child: const Text("Add Step"),
              ),
            ),
        
            // Save Route Button
        
          ],
        ),
      ),
      bottomSheet:   Container(
        padding: const EdgeInsets.all(2),
        width: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("Route")
                  .doc(widget.routeId)
                  .update({
                "steps": steps,
              });
              Navigator.pop(context,steps);
            },
            child: const Text(
              "Save Route",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
