import 'package:flutter/material.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? selectedIndex;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${user!.name}",
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text("Welcome to $appName"),
                ],
              ),
              const Spacer(),
              const CircleAvatar(
                radius: 30,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SearchAnchor(
            isFullScreen: false,
            viewConstraints: const BoxConstraints(maxHeight: 300),
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
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
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(
                5,
                (int index) {
                  final String item = 'item $index';
                  return ListTile(
                    title: Text(item),
                    onTap: () {
                      setState(() {
                        controller.closeView(item);
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      )),
    );
  }
}
