import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:limanplatform/constants.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: Constants.background,
        foregroundColor: Constants.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Constants.background, Constants.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: ExpansionPanelList.radio(
            expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 10),
            children: Constants.faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return ExpansionPanelRadio(
                value: index, // unique value for single expand
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    leading: const Icon(
                      Icons.question_answer,
                      color: Constants.primary,
                    ),
                    title: Text(
                      item['question'].toString().tr()!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Constants.primary,
                      ),
                    ),
                  );
                },
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Constants.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['answer'].toString().tr()!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Constants.primary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
