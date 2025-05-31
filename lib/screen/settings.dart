import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expense_tracker_app/provider/currency_provider.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  final List<Map<String, String>> currencies = [
    {'symbol': 'LKR', 'label': 'LKR (Sri Lankan Rupee)'},
    {'symbol': '\$', 'label': '\$ (US Dollar)'},
    {'symbol': '₹', 'label': '₹ (Indian Rupee)'},
    {'symbol': '€', 'label': '€ (Euro)'},
    {'symbol': '£', 'label': '£ (British Pound)'},
    {'symbol': '¥', 'label': '¥ (Japanese Yen)'},
    {'symbol': '₩', 'label': '₩ (South Korean Won)'},
    {'symbol': '₽', 'label': '₽ (Russian Ruble)'},
    {'symbol': '₺', 'label': '₺ (Turkish Lira)'},
    {'symbol': 'R\$', 'label': 'R\$ (Brazilian Real)'},
    {'symbol': '₫', 'label': '₫ (Vietnamese Dong)'},
    {'symbol': '₪', 'label': '₪ (Israeli Shekel)'},
    {'symbol': '₦', 'label': '₦ (Nigerian Naira)'},
    {'symbol': '₱', 'label': '₱ (Philippine Peso)'},
    {'symbol': '฿', 'label': '฿ (Thai Baht)'},
    {'symbol': '₴', 'label': '₴ (Ukrainian Hryvnia)'},
    {'symbol': '₡', 'label': '₡ (Costa Rican Colón)'},
    {'symbol': '₲', 'label': '₲ (Paraguayan Guarani)'},
    {'symbol': '₵', 'label': '₵ (Ghanaian Cedi)'},
    {'symbol': '₸', 'label': '₸ (Kazakhstani Tenge)'},
    {'symbol': 'ر.س', 'label': 'SAR (Saudi Riyal)'},
    {'symbol': 'د.إ', 'label': 'AED (UAE Dirham)'},
    {'symbol': 'د.ب', 'label': 'BHD (Bahraini Dinar)'},
    {'symbol': 'د.ك', 'label': 'KWD (Kuwaiti Dinar)'},
    {'symbol': 'ر.ع.', 'label': 'OMR (Omani Rial)'},
    {'symbol': 'ر.ق', 'label': 'QAR (Qatari Riyal)'},
    // Add more as needed
  ];

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    final updateCurrency = ref.read(currencyProvider.notifier);
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            'Select Currency',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          children: currencies.map((currency) {
            return SimpleDialogOption(
              child: Text(
                currency['label']!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onPressed: () {
                updateCurrency.state = currency['symbol']!;
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final items = [
            {
              'icon': Icons.person,
              'title': 'Account',
              'onTap': () {
                // Handle account tap
              },
            },
            {
              'icon': Icons.login,
              'title': 'Login',
              'onTap': () {
                // Handle account tap
              },
            },
            {
              'icon': Icons.lock,
              'title': 'Privacy',
              'onTap': () {
                // Handle account tap
              },
            },
            {
              'icon': Icons.currency_exchange,
              'title': 'Change Currency',
              'onTap': () => _showCurrencyPicker(context, ref),
            },
          ];
          return ListTile(
            leading: Icon(items[index]['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              items[index]['title'] as String,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: items[index]['onTap'] as void Function(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
