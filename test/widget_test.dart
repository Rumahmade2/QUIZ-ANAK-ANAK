import 'package:flutter/material.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF3E8FF),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, 'Home', 0),
                _navItem(Icons.school, 'Educasi', 1),
                _navItem(Icons.settings, 'Pengaturan', 2),
              ],
            ),
          ),

          // Floating active icon
          Positioned(
            top: 0,
            child: _activeIcon(),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: active ? Colors.transparent : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: active ? Colors.transparent : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeIcon() {
    IconData icon;
    String label;

    switch (currentIndex) {
      case 1:
        icon = Icons.school;
        label = 'Educasi';
        break;
      case 2:
        icon = Icons.settings;
        label = 'Pengaturan';
        break;
      default:
        icon = Icons.home;
        label = 'Home';
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFF7C3AED),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF7C3AED),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
