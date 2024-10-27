import 'package:astrum_test_app/services/auth/bloc/auth_bloc.dart';
import 'package:astrum_test_app/services/auth/firebase_auth_provider.dart';
import 'package:astrum_test_app/services/location/cubit/trip_cubit.dart';
import 'package:astrum_test_app/services/crud/bloc/storage_bloc.dart';
import 'package:astrum_test_app/views/auth/onboarding_view.dart';
import 'package:astrum_test_app/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(create: (context) => StorageBloc()),
        BlocProvider(create: (context) => TripCubit())
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorSchemeSeed: Colors.amber,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Astradevs test app',
        home: const RootPage(),
      ),
    );
  }
}

final rootPageKey = GlobalKey<_RootPageState>();

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInit());
    context.read<TripCubit>().askForLocationPermissions();
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        state.shouldPop ? Navigator.pop(context) : null;
      },
      builder: (context, state) {
        return switch (state.authStatus) {
          AuthStatus.initial => const SplashScreen(),
          AuthStatus.signedOut => const OnboardingView(),
          AuthStatus.signedIn => const HomePage(),
        };
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('We are loading ....')),
    );
  }
}
