import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Application router with authentication guards.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthLoading = authState.isLoading;
      final isAuthenticated = authState.value != null;

      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // Wait for auth state to load
      if (isAuthLoading) {
        return null;
      }

      // Redirect to dashboard if authenticated and trying to access auth screens
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return '/';
      }

      // Redirect to login if not authenticated and not on auth screens
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // ═══════════════════════════════════════════════════════════
      // AUTH ROUTES
      // ═══════════════════════════════════════════════════════════
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),

      // ═══════════════════════════════════════════════════════════
      // MAIN APP ROUTES
      // ═══════════════════════════════════════════════════════════
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const Scaffold(
            body: Center(
              child: Text('Dashboard - Coming Soon'),
            ),
          ),
        ),
      ),

      // Add more routes here as features are implemented
      // GoRoute(
      //   path: '/projects',
      //   name: 'projects',
      //   pageBuilder: (context, state) => ...
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
