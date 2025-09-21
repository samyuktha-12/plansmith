import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_page.dart';
import 'screens/destination_details_screen.dart';
import 'screens/itinerary_screen.dart';
import 'screens/expense_tracking_screen.dart';
import 'screens/booking_confirmation_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/creator_zone_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/user_search_screen.dart';
import 'screens/trip_management_screen.dart';
import 'screens/group_trip_details_screen.dart';
import 'screens/trip_map_screen.dart';
import 'screens/live_events_weather_screen.dart';
import 'screens/animated_itinerary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanSmith',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E4F55),
          brightness: Brightness.light,
        ),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0E4F55),
          ),
          displayMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          displaySmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          titleLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
          titleMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0E4F55),
          ),
          titleSmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0E4F55),
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0E4F55),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0E4F55),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E4F55),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0E4F55),
            side: const BorderSide(color: Color(0xFF0E4F55)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0E4F55),
            textStyle: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0E4F55), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          hintStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF0E4F55),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/destination': (context) => const DestinationDetailsScreen(
          destinationName: 'Moscow',
          country: 'Russia',
          description: 'Russia is most historical destinations',
          imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
          rating: 4.9,
          price: '256',
        ),
        '/itinerary': (context) => const ItineraryScreen(
          destinationName: 'Moscow',
          country: 'Russia',
        ),
        '/expenses': (context) => const ExpenseTrackingScreen(),
        '/booking': (context) => const BookingConfirmationScreen(
          destinationName: 'Moscow',
          country: 'Russia',
          confirmationNumber: 'PS-2024-001234',
          bookedItems: [
            {
              'title': 'Hotel Booking',
              'description': '3 nights at Grand Hotel Moscow',
              'price': '450',
              'date': 'Dec 15-17, 2024',
              'icon': Icons.hotel_rounded,
              'color': Color(0xFF0E4F55),
            },
            {
              'title': 'City Tour',
              'description': 'Guided city walking tour',
              'price': '85',
              'date': 'Dec 16, 2024',
              'icon': Icons.tour_rounded,
              'color': Color(0xFF1976D2),
            },
          ],
        ),
        '/gallery': (context) => const GalleryScreen(
          destinationName: 'Moscow',
          country: 'Russia',
          imageUrls: [
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
            'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&h=600&fit=crop',
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop',
          ],
        ),
        '/creator': (context) => const CreatorZoneScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/user-search': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return UserSearchScreen(
            tripId: args['tripId'],
            tripName: args['tripName'],
          );
        },
        '/trip-management': (context) => const TripManagementScreen(),
        '/group-trip-details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return GroupTripDetailsScreen(trip: args);
        },
        '/trip-map': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return TripMapScreen(trip: args);
        },
        '/live-events': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return LiveEventsWeatherScreen(trip: args);
        },
        '/animated-itinerary': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return AnimatedItineraryScreen(trip: args);
        },
      },
    );
  }
}

