import 'dart:developer';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class GeminiService {
  static Future<String> summarizeTasks(String tasksText) async {
    final response = await Gemini.instance.prompt(
      parts: [
        Part.text(
          "Here are my tasks:\n$tasksText\n\nPlease summarize my schedule and give short productivity advice.",
        ),
      ],
    );

    if (response != null) {
      log("Gemini response received:\n${response.output}");
      return response.output ?? "No summary generated.";
    } else {
      log("Gemini response is null.");
      return "Failed to generate summary.";
    }
  }
}
