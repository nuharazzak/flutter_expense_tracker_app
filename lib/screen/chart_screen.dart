import 'package:flutter/material.dart';
import 'package:my_expense_tracker_app/screen/chart.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: Text(
          "Chart",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 143, 123, 145),
          // image: DecorationImage(
          //   image: NetworkImage(
          //       "https://user-images.githubusercontent.com/54882818/130562917-33168e1a-beba-410a-a986-0fff4f117a6b.png"),
          // ),
        ),
        child: const Chart(),
      ),
    );
  }
}
