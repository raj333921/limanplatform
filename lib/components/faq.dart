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
        backgroundColor: Constants.primary,
        foregroundColor: Constants.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: FAQSearchDelegate());
            },
          ),
        ],
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
                value: index,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    leading: const Icon(
                      Icons.question_answer,
                      color: Constants.primary,
                    ),
                    title: Text(
                      item['question'].toString().tr(),
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
                    item['answer'].toString().tr(),
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

//
// SEARCH DELEGATE WITH WILDCARD MATCHING
//
class FAQSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => "search".tr();
  // Normalize text
  String normalize(String text) {
    return text.toLowerCase().trim();
  }

  // Wildcard/fuzzy-style matching: all words must exist somewhere in text
  bool wildcardMatch(String text, String query) {
    final t = normalize(text);
    final q = normalize(query);

    final words = q.split(" ").where((w) => w.isNotEmpty);

    // each word typed must appear somewhere in the text
    return words.every((w) => t.contains(w));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = Constants.faqs.where((item) {
      final question = item['question'].toString().tr();
      final answer = item['answer'].toString().tr();
      return wildcardMatch(question, query) || wildcardMatch(answer, query);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No results found"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ExpansionTile(
          title: Text(item['question'].toString().tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(item['answer'].toString().tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = Constants.faqs.where((item) {
      final question = item['question'].toString().tr();
      return wildcardMatch(question, query);
    }).toList();

    if (suggestions.isEmpty && query.isNotEmpty) {
      return Center(child: Text("suggestions".tr()));
    }

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return ListTile(
          title: Text(item['question'].toString().tr()),
          onTap: () {
            query = item['question'].toString();
            showResults(context);
          },
        );
      },
    );
  }
}
