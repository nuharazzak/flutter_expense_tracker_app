import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/screen/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 236, 10, 229),
);

var kDarkColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 63, 2, 56));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData().copyWith(
            backgroundColor: kColorScheme.primaryContainer,
            selectedItemColor: kColorScheme.onPrimaryContainer,
            unselectedItemColor:
                kColorScheme.onPrimaryContainer.withValues(alpha: 0.5),
          ),
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primary, // Button background color
              foregroundColor: kColorScheme.primaryContainer, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                side: const BorderSide(
                  color: Colors.white, // White border color
                  width: 2, // Border width
                ),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(
                color: Colors.white,
                width: 3,
              ),
            ),
          ),
          iconTheme: const IconThemeData().copyWith(
            color: kColorScheme.onPrimaryContainer,
          ),
          textTheme: GoogleFonts.robotoTextTheme(
            ThemeData.light().textTheme,
          ).copyWith(
            titleLarge: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.primaryContainer,
                fontSize: 30,
              ),
            ),
            bodyMedium: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.primary,
                fontSize: 25,
              ),
            ),
            bodySmall: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        darkTheme: ThemeData().copyWith(
          colorScheme: kDarkColorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: kDarkColorScheme.onPrimaryContainer,
            foregroundColor: kDarkColorScheme.primaryContainer,
          ),
          scaffoldBackgroundColor: const Color.fromARGB(3, 30, 30, 30),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: kDarkColorScheme.primaryContainer,
            selectedItemColor: kDarkColorScheme.onPrimaryContainer,
            unselectedItemColor:
                kDarkColorScheme.onPrimaryContainer.withOpacity(0.5),
          ),
          cardTheme: CardTheme(
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkColorScheme.primaryContainer,
            ),
          ),
          textTheme: GoogleFonts.robotoTextTheme(
            ThemeData.light().textTheme,
          ).copyWith(
            titleLarge: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.primaryContainer,
                fontSize: 25,
              ),
            ),
            bodyMedium: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.onPrimaryContainer,
                fontSize: 16,
              ),
            ),
            bodySmall: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
          iconTheme: IconThemeData(
            color: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    ),
  );
}
