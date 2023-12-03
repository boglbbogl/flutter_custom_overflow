import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            height: 100,
            color: Theme.of(context).colorScheme.primary,
            child: CustomEllipsis(
              onTap: () {
                print("onTap");
              },
              ellipsis: Text(
                "...more",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
              // scaleUp: 1.0,
              maxLines: 1,
              text: TextSpan(
                text:
                    "dsalkjdsa  fjk  l slkl 21., 2m,21, 12, 2 1221 k3 l1k2 l 12lkl 1l2 2l121  kl21 l 12ks lj 21 2  12 1 12 21 21 21 21 21  2  112 12 12 3 kal fjk lsl",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
