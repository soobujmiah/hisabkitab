import 'package:flutter/material.dart';

void main() => runApp(const HisabKitabApp());

class HisabKitabApp extends StatelessWidget {
  const HisabKitabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HisabKitab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF126B5A),
        scaffoldBackgroundColor: const Color(0xFFF7F8F6),
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.account_balance_wallet_rounded, size: 72),
              const SizedBox(height: 24),
              Text(
                'HisabKitab',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'আপনার ব্যবসার হিসাব, এক জায়গায়।',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'বিক্রি, বাকি, খরচ ও লাভ—সহজভাবে।',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('অ্যাকাউন্ট খুলুন'),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('লগইন'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () {}, child: const Text('অ্যাপটি ঘুরে দেখুন')),
            ],
          ),
        ),
      ),
    );
  }
}
