import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
1. Introduction
Welcome to My Smart Wallet! Your privacy is important to us, and this policy explains how we collect, use, and protect your personal information while using our expense tracker app.

2. Information We Collect
We collect the following types of information:

- Personal Details: Name, email address, and account information.
- Financial Data: Expenses, income details, and payment methods.
- Usage Data: Device information, IP address, and user activity.

3. How We Use Your Information
We use your data to:
- Provide and improve expense tracking features.
- Send notifications and updates.
- Ensure security and fraud prevention.

4. Data Sharing & Security
We do not sell your personal data. We may share data:
- With third-party service providers for app functionality.
- When required by law or legal authorities.

We follow strict security measures to protect your data from unauthorized access.

5. Your Rights
You have the right to:
- Access and update your personal information.
- Request deletion of your data.
- Opt out of marketing communications.

6. Changes to This Privacy Policy
We may update this policy periodically. Any changes will be communicated through the app or our website.


''',
            style: const TextStyle(
              color: Colors.black, // Black text
              fontSize: 16, // Small size
              height: 1.5, // Optional: line height for readability
            ),
          ),
        ),
      ),
    );
  }
}
