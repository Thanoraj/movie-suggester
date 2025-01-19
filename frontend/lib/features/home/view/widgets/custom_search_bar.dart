import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: false,
      viewOnChanged: (val) {
        print(val);
      },
      viewOnSubmitted: (_) {
        print("view submitted");
      },
      viewConstraints: const BoxConstraints(maxHeight: 300),
      builder: (BuildContext context, SearchController controller) {
        print("building");
        return SearchBar(
          focusNode: _focusNode,
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            print("clicked");
            controller.openView();
          },
          onChanged: (value) {
            print("changed");
            controller.openView();
          },
          onTapOutside: (_) {
            print("Tapped outside");
            if (_focusNode.hasFocus) {
              _focusNode.unfocus();
            }
          },

          onSubmitted: (_) {
            print("submitted");
          },

          leading: const Icon(Icons.search),
          // trailing: <Widget>[
          //   Tooltip(
          //     message: 'Change brightness mode',
          //     child: IconButton(
          //       isSelected: isDark,
          //       onPressed: () {
          //         setState(() {
          //           isDark = !isDark;
          //         });
          //       },
          //       icon: const Icon(Icons.wb_sunny_outlined),
          //       selectedIcon: const Icon(Icons.brightness_2_outlined),
          //     ),
          //   )
          // ],
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(
          5,
          (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                print("Tapped");
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          },
        );
      },
    );
  }
}
