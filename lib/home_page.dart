import 'package:flutter/material.dart';
import 'package:flutter_custom_overflow/custom_ellipsis.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Custom Overflow Ellipsis",
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            width: MediaQuery.of(context).size.width,
            height: 150,
            color: Theme.of(context).colorScheme.primary,
            child: const CustomEllipsis(
              ellipsis: Text(
                "...more",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              scaleUp: 2.0,
              maxLines: 1,
              text: TextSpan(
                text: "dsalkjfjkl slkajlk dslks ljkal fjklsl",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
