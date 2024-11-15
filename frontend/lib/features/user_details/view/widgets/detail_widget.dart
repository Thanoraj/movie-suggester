import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class DetailWidget extends StatefulWidget {
  const DetailWidget({super.key});

  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? selectedIndex;
  List selectedLangs = [];
  final list = ['English', 'Tamil'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Languages",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 15,
        ),
        SearchField<String>(
          controller: searchController,
          onTapOutside: (p) {
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
          searchInputDecoration: SearchInputDecoration(
            contentPadding: EdgeInsets.all(20),
          ),
          onSuggestionTap: (SearchFieldListItem<String> x) {
            _focusNode.unfocus();
            selectedLangs.add(x.item);
            list.remove(x.item);
            searchController.clear();
            setState(() {});
          },
          suggestions: list
              .map(
                (e) => SearchFieldListItem<String>(
                  e,
                  item: e,
                  // Use child to show Custom Widgets in the suggestions
                  // defaults to Text widget
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(e),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 5.0,
          children: List<Widget>.generate(
            selectedLangs.length,
            (int index) {
              return InputChip(
                label: Text(selectedLangs[index]),
                onDeleted: () {
                  setState(() {
                    list.add(selectedLangs[index]);
                    selectedLangs.remove(selectedLangs[index]);
                  });
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
