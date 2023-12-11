import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_clone/constants/assets_constants.dart';
import 'package:twitter_clone/constants/ui_constants.dart';
import 'package:twitter_clone/features/tweet/views/create_tweet_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  void onPageChnage(int page) {
    setState(() {
      _page = page;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetView.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _page == 0 ? UIConstants.appBar() : null,
        floatingActionButton: FloatingActionButton(
          onPressed: onCreateTweet,
          child: const Icon(
            Icons.add,
            color: Pallete.whiteColor,
            size: 28,
          ),
        ),
        bottomNavigationBar: CupertinoTabBar(
            currentIndex: _page,
            onTap: onPageChnage,
            backgroundColor: Pallete.backgroundColor,
            items: [
              BottomNavigationBarItem(
                  icon: _page == 0
                      ? SvgPicture.asset(
                          AssetsConstants.homeFilledIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )
                      : SvgPicture.asset(
                          AssetsConstants.homeOutlinedIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )),
              BottomNavigationBarItem(
                  icon: _page == 1
                      ? SvgPicture.asset(
                          AssetsConstants.searchIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )
                      : SvgPicture.asset(
                          AssetsConstants.searchIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )),
              BottomNavigationBarItem(
                  icon: _page == 2
                      ? SvgPicture.asset(
                          AssetsConstants.notifFilledIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )
                      : SvgPicture.asset(
                          AssetsConstants.notifOutlinedIcon,
                          colorFilter: const ColorFilter.mode(
                              Pallete.whiteColor, BlendMode.srcIn),
                        )),
            ]),
        body: IndexedStack(
          index: _page,
          children: UIConstants.bottomTabBarPages,
        ));
  }
}
