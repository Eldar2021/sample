import 'package:flutter/material.dart';

import 'package.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePageView'),
      ),
      body: Center(
        child: Column(
          children: const [
            // MyExpansionTile(text: sameText),
            MyExpansionTileReadMore(
              title: Text(sameText),
            ),
            // ExpansionPanel(
            //   headerBuilder: (context, open) {
            //     return Text('data');
            //   },
            //   body: Text(text),
            // ),
          ],
        ),
      ),
    );
  }
}

class MyExpansionTile extends StatelessWidget {
  const MyExpansionTile({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(text),
      children: [
        Text(text),
      ],
    );
  }
}

const String sameText =
    'Build a custom color scheme to map dynamic color, use as fallback colors, or implement a branded theme. The color system automatically handles critical adjustments that provide accessible color contrast. Learn more about color roles.';
