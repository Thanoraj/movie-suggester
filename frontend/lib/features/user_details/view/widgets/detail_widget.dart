import 'package:flutter/material.dart';
import 'package:frontend/features/user_details/model/detail.dart';
import 'package:searchfield/searchfield.dart';

class DetailWidget extends StatefulWidget {
  const DetailWidget(
      {super.key,
      required this.detailsList,
      required this.label,
      required this.selectedList});
  final List<Detail> detailsList;
  final List<Detail> selectedList;
  final String label;
  @override
  State<DetailWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 15,
        ),
        SearchField<Detail>(
          controller: searchController,
          onTapOutside: (p) {
            _focusNode.unfocus();
          },
          focusNode: _focusNode,
          searchInputDecoration: SearchInputDecoration(
            contentPadding: EdgeInsets.all(20),
          ),
          onSuggestionTap: (SearchFieldListItem<Detail> x) {
            _focusNode.unfocus();

            widget.selectedList.add(x.item!);
            widget.detailsList.remove(x.item);
            searchController.clear();
            setState(() {});
          },
          suggestions: widget.detailsList
              .where((detail) => !widget.selectedList.contains(detail))
              .map(
                (e) => SearchFieldListItem<Detail>(
                  e.name,
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
                        Text(e.name),
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
            widget.selectedList.length,
            (int index) {
              widget.detailsList.remove(widget.selectedList[index]);
              return InputChip(
                label: Text(widget.selectedList[index].name),
                onDeleted: () {
                  setState(() {
                    widget.detailsList.add(widget.selectedList[index]);
                    widget.selectedList.remove(widget.selectedList[index]);
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
