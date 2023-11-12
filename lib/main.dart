import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/theme/app_theme.dart';

import 'features/auth/controller/auth_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Twitter Clone',
        theme: AppTheme.theme,
        home: ref.watch(userAccountProvider).when(data: (user) {
          if (user != null) {
            return const HomeView();
          }
          return const SignUpView();
        }, error: (e, st) {
          return const Text('Something went wrong!');
        }, loading: () {
          return const LoadingPage();
        }));
  }
}
