import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HashTagText extends StatelessWidget {
  final String text;
  const HashTagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )));
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blueColor,
              fontSize: 16,
            )));
      } else {
        textSpans.add(TextSpan(
            text: '$element ',
            style: const TextStyle(
              fontSize: 16,
            )));
      }
    });

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }
}
