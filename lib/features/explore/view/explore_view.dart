import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/explore/controller/explore_controller.dart';
import 'package:twitter_clone/features/explore/widgets/search_tile.dart';
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
            onSubmitted: (value) {
              setState(() {});
            },
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
      body: ref.watch(searchUserByNameProvider(searchController.text)).when(
          data: (userList) {
        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return SearchTile(
              userModel: userList[index],
            );
          },
        );
      }, error: (error, stackTrace) {
        return Text(error.toString());
      }, loading: () {
        return const Loader();
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
