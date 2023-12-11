import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/theme/pallete.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();

  final textFiledBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Pallete.searchBarColor));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10).copyWith(left: 24),
                hintText: 'Search here',
                fillColor: Pallete.searchBarColor,
                filled: true,
                enabledBorder: textFiledBorderStyle,
                focusedBorder: textFiledBorderStyle),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
