import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  List<String> countries;
  ScrollController scrollController;
  ValueNotifier<Set<String>> chipItems = ValueNotifier<Set<String>>(<String>{});

  CustomSearchDelegate({
    required String hintText,
    required this.countries,
    required this.scrollController,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  void _scrollDown() => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
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
          query = "";

          Set<String> temp = chipItems.value.toSet();
          temp.add(suggestion[index]);
          chipItems.value = temp;

          /// * shart emas
          Future.delayed(
            const Duration(milliseconds: 150),
            _scrollDown,
          );
        },
        title: Text(suggestion[index]),
      ),
    );
  }

  @override
  PreferredSizeWidget buildBottom(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SizedBox(
        height: 115,
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: List.generate(
            1,
            (_) => ValueListenableBuilder(
              valueListenable: chipItems,
              builder: (context, value, child) {
                return Wrap(
                  children: List.generate(
                    value.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.5),
                      child: InputChip(
                        label: Text(value.elementAt(index)),
                        shape: const StadiumBorder(),
                        deleteIcon: const Icon(
                          Icons.clear,
                          size: 16,
                        ),
                        onDeleted: () {
                          Set<String> temp = chipItems.value.toSet();
                          temp.removeWhere((e) => e == value.elementAt(index));
                          chipItems.value = temp;
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            growable: false,
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
