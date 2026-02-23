import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:schedule_generator_app/services/gemini_service.dart';
import 'package:schedule_generator_app/task/task_model.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class SummaryPage extends StatefulWidget {
  final List<Task> tasks;

  const SummaryPage({super.key, required this.tasks});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String? aiSummary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateSummary();
    });
  }

  Future<void> generateSummary() async {
    log("Generating summary for ${widget.tasks.length} tasks...");
    // Menyiapkan teks tugas untuk dikirim ke AI
    String taskText = widget.tasks
        .map((task) {
          return "- ${task.title} (${task.startTime.format(context)} - ${task.endTime.format(context)})";
        })
        .join("\n");

    log("Task text prepared for AI:\n$taskText");

    final result = await GeminiService.summarizeTasks(taskText);

    log("AI Summary Result:\n$result");

    if (mounted) {
      log("Updating UI with AI summary...");
      setState(() {
        aiSummary = result;
        isLoading = false;
      });
    }

    log("Summary generation completed.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E4CD2), Color(0xFFC1BCE7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "AI Schedule Summary",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Analyzing ${widget.tasks.length} selected agendas...",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // CARD
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF5E4CD2),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Gemini is thinking...",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Markdown(
                        data: aiSummary ?? "Failed to generate summary.",
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                            color: Colors.black87,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
