import 'package:flutter/material.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/features/home/view/widgets/custom_search_bar.dart';
import 'package:frontend/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedIndex;

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
          const SizedBox(
            height: 15,
          ),
          const CustomSearchBar(),
        ],
      )),
    );
  }
}
