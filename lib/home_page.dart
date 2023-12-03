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
          RichText(
            text: TextSpan(
              text:
                  " k;dsja;fk s lkd  dklsd kaksdakl f kasd asd   sj dfsakl k fdakakl dlld fldksf addkldslfkdal ff jfjdsl asldka jklsdaaf ljd dsljd slkjd lk",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            // maxLines: 2,
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            width: MediaQuery.of(context).size.width,
            height: 60,
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
              scaleUp: 2.0,
              maxLines: 2,
              text: TextSpan(
                text:
                    "dsalkjdsa  fjk  l slkl 21., 2m,21, 12, 2 1221 k3 l1k2 l 12lkl 1l2 2l121  kl21 l 12ks lj 21 2  12 1 12 21 21 21 21 21  2  112 12 12 3 kal fjk lsl",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
