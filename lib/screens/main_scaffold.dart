import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'educasi_screen.dart';
import 'settings_screen.dart';
import '../services/settings_service.dart';
import '../widgets/curved_bottom_nav.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

 static final List<Widget> _pages = [
  HomeScreen(),
  EducasiScreen(),
  SettingsScreen(),
];


  @override
  void initState() {
    super.initState();
    _loadLastIndex();
  }

  Future<void> _loadLastIndex() async {
    final idx = await SettingsService.getLastTabIndex();
    if (mounted) setState(() => _currentIndex = idx);
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    SettingsService.setLastTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CurvedBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
