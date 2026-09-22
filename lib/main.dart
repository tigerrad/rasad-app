import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

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

  List<dynamic> _products = [];
  bool _loading = true;
  String? _error;

  static const String _apiBase = 'http://192.168.1.5:8000';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.get(
        Uri.parse('$_apiBase/api/products?q=لپ'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        setState(() {
          _products = data['products'] ?? [];
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'خطای سرور: ${res.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'اتصال به سرور ممکن نشد: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = <Widget>[
      Center(child: Text(l10n.navDemand)),
      _buildPricePage(),
      Center(child: Text(l10n.navSupplier)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: const Color(0xFF0A4D68),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProducts,
          ),
        ],
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

  Widget _buildPricePage() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchProducts,
                child: const Text('تلاش دوباره'),
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(child: Text('محصولی پیدا نشد'));
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, i) {
        final p = _products[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.shopping_bag, color: Color(0xFF0A4D68)),
            title: Text(p['name'] ?? ''),
            subtitle: Text(p['shop'] ?? ''),
            trailing: Text(
              '${p['price']} تومان',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A4D68),
              ),
            ),
          ),
        );
      },
    );
  }
}
