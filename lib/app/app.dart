import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../providers/auth_provider.dart';
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
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) => user == null ? const _AuthFlow() : const ProfileScreen(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Something went wrong: $error'))),
    );
  }
}

class _AuthFlow extends StatefulWidget {
  const _AuthFlow();

  @override
  State<_AuthFlow> createState() => _AuthFlowState();
}

class _AuthFlowState extends State<_AuthFlow> {
  bool _showSignup = false;

  @override
  Widget build(BuildContext context) {
    return _showSignup
        ? SignupScreen(onLoginTap: () => setState(() => _showSignup = false))
        : LoginScreen(
            onCreateAccountTap: () => setState(() => _showSignup = true),
          );
  }
}
