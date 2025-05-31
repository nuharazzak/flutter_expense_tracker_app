import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyProvider =
    StateProvider<String>((ref) => 'LKR' // Default currency,
        );
