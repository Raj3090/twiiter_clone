// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import '../../../theme/pallete.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({
    Key? key,
    required this.count,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$count',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Pallete.whiteColor)),
        const SizedBox(
          width: 16,
        ),
        Text(text,
            style: const TextStyle(fontSize: 25, color: Pallete.greyColor)),
      ],
    );
  }
}
