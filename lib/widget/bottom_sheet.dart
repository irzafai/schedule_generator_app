import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule_generator_app/task/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(Task) onAdd;

  const AddTaskBottomSheet({super.key, required this.onAdd});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Style helper untuk input decoration
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple, size: 20),
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
      ),
    );
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // User nggak bisa pilih tanggal lampau
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void submit() {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      // Kasih feedback dikit kalau kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill title, date, and time")),
      );
      return;
    }

    final newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: selectedDate!,
      endDate: selectedDate!,
      startTime: selectedTime!,
      endTime: selectedTime!,
      createdAt: DateTime.now(),
    );

    widget.onAdd(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const Text(
                "Create New Agenda",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // Title Field
              TextField(
                controller: titleController,
                decoration: _inputStyle("Agenda Title", Icons.edit_calendar_rounded),
              ),

              const SizedBox(height: 16),

              // Description Field
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputStyle("Description (Optional)", Icons.notes_rounded),
              ),

              const SizedBox(height: 20),

              // Date & Time Selectors
              Row(
                children: [
                  Expanded(
                    child: _buildPickerButton(
                      label: "Date",
                      value: selectedDate == null
                          ? "Set Date"
                          : DateFormat('dd/MM/yy').format(selectedDate!),
                      icon: Icons.calendar_today_outlined,
                      onTap: pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPickerButton(
                      label: "Time",
                      value: selectedTime == null
                          ? "Set Time"
                          : selectedTime!.format(context),
                      icon: Icons.access_time_rounded,
                      onTap: pickTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E4CD2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Save Agenda",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Widget custom untuk tombol picker biar lebih cakep dari ElevatedButton biasa
  Widget _buildPickerButton({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}