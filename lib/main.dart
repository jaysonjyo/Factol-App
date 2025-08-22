import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Material Page/Material home screen.dart';
import 'Product/Prdouct create.dart';
import 'Route Pages/Route.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
        ColorScheme.fromSeed(
        seedColor: Colors.deepPurple
        ),
      ),
      home:CreateProductPage(),
    );
  }
}


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Main Menu",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Factory Adding (Simple Text Only)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FactoryAddingScreen(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  child: Text(
                    "Factory Adding",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // 🔹 Flow Adding (Styled)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlowAddingScreen(sections: []), // pass sections if needed
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green.withOpacity(0.15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.compare_arrows,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Flow Adding",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Section Adding (Styled)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SectionAddingScreen(),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange.withOpacity(0.15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.dashboard_customize,
                            color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Section Adding",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionAddingScreen extends StatefulWidget {
  const SectionAddingScreen({super.key});

  @override
  State<SectionAddingScreen> createState() => _SectionAddingScreenState();
}

class _SectionAddingScreenState extends State<SectionAddingScreen> {
  final TextEditingController _sectionController = TextEditingController();
  final List<String> _sections = [];

  void _addSection() {
    final text = _sectionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _sections.add(text);
      });
      _sectionController.clear();
    }
  }

  void _deleteSection(int index) {
    setState(() {
      _sections.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Section Adding",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input field + button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sectionController,
                    decoration: InputDecoration(
                      labelText: "Enter Section Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Section list
            Expanded(
              child: _sections.isEmpty
                  ? Center(
                child: Text(
                  "No sections added yet",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        _sections[index],
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteSection(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlowAddingScreen extends StatefulWidget {
  final List<String> sections; // ✅ Pass from SectionAddingScreen

  const FlowAddingScreen({super.key, required this.sections});

  @override
  State<FlowAddingScreen> createState() => _FlowAddingScreenState();
}

class _FlowAddingScreenState extends State<FlowAddingScreen> {
  List<List<String>> flows = []; // ✅ Stores multiple flows
  List<String> flowNames = [];   // ✅ Stores flow names

  void _createNewFlow() {
    setState(() {
      flows.add([]); // Start with empty flow
      flowNames.add("Flow ${flows.length}"); // Default name
    });
  }

  void _removeFlow(int index) {
    setState(() {
      flows.removeAt(index);
      flowNames.removeAt(index);
    });
  }

  void _renameFlow(int index) async {
    final controller = TextEditingController(text: flowNames[index]);

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rename Flow"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Flow Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (newName != null && newName.trim().isNotEmpty) {
      setState(() {
        flowNames[index] = newName.trim();
      });
    }
  }

  /// 🔹 Open flow editor (to add/edit section route)
  void _editFlow(int flowIndex) async {
    final updatedFlow = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {

        final textController = TextEditingController();
        List<List<String>> tempFlows = [List.from(flows[flowIndex])];
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int row = 0; row < tempFlows.length; row++) ...[
                    // 🔹 Flow index title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        "Flow ${row + 1}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // 🔹 Existing chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < tempFlows[row].length; i++) ...[
                            Chip(
                              label: Text(tempFlows[row][i]),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setModalState(() {
                                  tempFlows[row].removeAt(i);
                                });
                              },
                            ),
                            if (i < tempFlows[row].length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.arrow_forward, size: 18),
                              ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 TextField only for the last row
                    if (row == tempFlows.length - 1)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter section for Flow ${row + 1}",
                                border: const OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  setModalState(() {
                                    tempFlows[row].add(value.trim());
                                  });
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              // handled by onSubmitted
                            },
                          ),
                        ],
                      ),

                    const Divider(),

                    // 🔹 Add new flow button only after last row
                    if (row == tempFlows.length - 1)
                      TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            tempFlows.add([]); // new empty row
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Another Flow"),
                      ),
                  ],
                ],
              )


            );
          },
        );
      },
    );

    if (updatedFlow != null) {
      setState(() {
        flows[flowIndex] = updatedFlow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Flow Adding",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _createNewFlow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Create New Flow"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: flows.length,
                itemBuilder: (context, flowIndex) {
                  final flow = flows[flowIndex];
                  return InkWell(
                    onTap: () => _editFlow(flowIndex), // 🔹 open editor on tap
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Column(
                        children: [
                          // 🔹 Flow title + rename + delete
                          ListTile(
                            title: Text(
                              flowNames[flowIndex],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                  const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _renameFlow(flowIndex),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _removeFlow(flowIndex),
                                ),
                              ],
                            ),
                          ),

                          // 🔹 Show selected sections (like a preview)
                          if (flow.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 8,
                                children: flow
                                    .map((s) => Chip(label: Text(s)))
                                    .toList(),
                              ),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class FactoryAddingScreen extends StatelessWidget {
  const FactoryAddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Factory Adding",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(
        child: Text("Factory Adding Screen Content Here"),
      ),
    );
  }
}
