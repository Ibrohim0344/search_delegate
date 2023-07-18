import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  List<String> countries;
  void Function(List<String> chips, int index) removeFromChip;

  CustomSearchDelegate({
    required String hintText,
    required this.countries,
    required this.removeFromChip,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  Widget buildLeading(BuildContext context) => const BackButton(
        color: Colors.black,
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestion = [];

    suggestion = countries
        .where(
          (e) => e.toLowerCase().startsWith(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(
          Icons.av_timer,
          color: Colors.grey,
        ),
        onTap: () {
          query = suggestion[index];
          forChips.add(suggestion[index]);
        },
        title: Text(suggestion[index]),
      ),
    );
  }

  List<String> forChips = [];

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 120,
          child: Column(
            // crossAxisAlignment: WrapCrossAlignment.start,
            // alignment: WrapAlignment.start,
            children: List.generate(
              forChips.length,
              (index) => Chip(
                padding: const EdgeInsets.all(5),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => removeFromChip(forChips, index),
                side: const BorderSide(
                  width: 1,
                  color: Colors.deepPurple,
                  strokeAlign: -5,
                ),
                visualDensity: VisualDensity.compact,
                label: Text(forChips[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> result = [];

    result = countries
        .where(
          (e) => e.toLowerCase().startsWith(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(result[index]),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => <Widget>[
        CloseButton(
          color: Colors.black,
          onPressed: () => query = "",
        ),
      ];
}
