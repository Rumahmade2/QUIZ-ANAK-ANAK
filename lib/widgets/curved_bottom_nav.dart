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
    return SizedBox(
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ===== BAR DENGAN LEKUKAN DINAMIS =====
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: CurvedNavPainter(currentIndex),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _item(Icons.home, 'Home', 0),
                    _item(Icons.bar_chart, 'Education', 1),
                    _item(Icons.person, 'Profile', 2),
                  ],
                ),
              ),
            ),
          ),

          // ===== ICON AKTIF (GESER + HALUS) =====
          AnimatedAlign(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeInOutCubic,
            alignment: _alignmentForIndex(),
            child: _activeIcon(),
          ),
        ],
      ),
    );
  }

  // ================= ITEM =================
  Widget _item(IconData icon, String label, int index) {
    final active = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? Colors.transparent : Colors.grey),
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

  // ================= ICON AKTIF =================
  Widget _activeIcon() {
    IconData icon;
    String label;

    switch (currentIndex) {
      case 1:
        icon = Icons.bar_chart;
        label = 'Education';
        break;
      case 2:
        icon = Icons.person;
        label = 'Profile';
        break;
      default:
        icon = Icons.home;
        label = 'Home';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedScale(
          scale: 1.05,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF7C3AED),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C3AED),
          ),
        ),
      ],
    );
  }

  // ================= POSISI ICON (NAIK DIKIT) =================
  Alignment _alignmentForIndex() {
    switch (currentIndex) {
      case 0:
        return const Alignment(-0.75, -1.25);
      case 1:
        return const Alignment(0, -1.25);
      case 2:
        return const Alignment(0.75, -1.25);
      default:
        return const Alignment(0, -1.25);
    }
  }
}

// ================= PAINTER LEKUKAN =================
class CurvedNavPainter extends CustomPainter {
  final int index;
  CurvedNavPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    final centerX = switch (index) {
      0 => size.width * 0.17,
      1 => size.width * 0.5,
      2 => size.width * 0.83,
      _ => size.width * 0.5,
    };

    final path = Path()
      ..moveTo(0, 22)
      ..lineTo(centerX - 65, 22)
      ..quadraticBezierTo(centerX, -30, centerX + 65, 22)
      ..lineTo(size.width, 22)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black26, 10, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CurvedNavPainter oldDelegate) {
    return oldDelegate.index != index;
  }
}
