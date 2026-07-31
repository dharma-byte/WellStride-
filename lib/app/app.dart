import 'package:flutter/material.dart';

import 'theme.dart';

class WellStrideApp extends StatelessWidget {
  const WellStrideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WellStride',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'WellStride',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
