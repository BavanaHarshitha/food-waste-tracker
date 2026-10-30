import 'package:flutter/material.dart';

import '../models/waste_model.dart';
import '../services/database_service.dart';
import 'record_waste_screen.dart';

class WasteScreen extends StatefulWidget {
  const WasteScreen({super.key});

  @override
  State<WasteScreen> createState() => _WasteScreenState();
}

class _WasteScreenState extends State<WasteScreen> {
  final DatabaseService databaseService = DatabaseService();

  List<WasteRecord> wasteRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWasteRecords();
  }

  Future<void> loadWasteRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final records = await databaseService.getWasteRecords();

      if (!mounted) return;

      setState(() {
        wasteRecords = records;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading waste records: $e'),
        ),
      );
    }
  }

  Future<void> deleteWasteRecord(WasteRecord waste) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Waste Record'),
          content: Text(
            'Are you sure you want to delete the waste record for "${waste.foodName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 111, 213, 236),
                foregroundColor: const Color.fromARGB(255, 171, 229, 156),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await databaseService.deleteWaste(waste.id);

      await loadWasteRecords();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waste record deleted successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting record: $e'),
        ),
      );
    }
  }

  Future<void> openRecordWasteScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecordWasteScreen(),
      ),
    );

    if (result == true) {
      await loadWasteRecords();
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management'),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: loadWasteRecords,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : wasteRecords.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 180,
                      ),
                      Icon(
                        Icons.delete_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'No waste records found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Record your wasted food to track it here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: wasteRecords.length,
                    itemBuilder: (context, index) {
                      final waste = wasteRecords[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 239, 42, 42).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Color.fromARGB(255, 218, 53, 67),
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      waste.foodName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'Quantity: ${waste.quantity} ${waste.unit}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      'Reason: ${waste.reason}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      'Date: ${formatDate(waste.wasteDate)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      'Money wasted: ₹${waste.moneyWasted.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    if (waste.notes.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Notes: ${waste.notes}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  deleteWasteRecord(waste);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 221, 37, 58),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openRecordWasteScreen,
        icon: const Icon(Icons.add),
        label: const Text('Record Waste'),
      ),
    );
  }
}