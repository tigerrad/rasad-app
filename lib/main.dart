import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const RasadApp());
}

class RasadApp extends StatelessWidget {
  const RasadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رصد',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fa'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A4D68),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = <Widget>[
      Center(child: Text(l10n.navDemand)),
      Center(child: Text(l10n.navPrice)),
      Center(child: Text(l10n.navSupplier)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: const Color(0xFF0A4D68),
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.trending_up),
            label: l10n.navDemand,
          ),
          NavigationDestination(
            icon: const Icon(Icons.attach_money),
            label: l10n.navPrice,
          ),
          NavigationDestination(
            icon: const Icon(Icons.business),
            label: l10n.navSupplier,
          ),
        ],
      ),
    );
  }
}
