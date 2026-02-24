import 'package:flutter/material.dart';

class SubjectCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final int questionCount;
  final VoidCallback onTap;
  final Color backgroundColor;

  const SubjectCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.questionCount,
    required this.onTap,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(curve: Curves.easeOutBack, parent: _controller),
    );

    _rotate = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(curve: Curves.easeOut, parent: _controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),

          /// ⭐ BOX DECORATION BARU — BIKIN HIDUP
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.backgroundColor.withOpacity(0.95),
                widget.backgroundColor.withOpacity(0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(24),

            // 💎 Border glossy tipis
            border: Border.all(
              color: Colors.white.withOpacity(.25),
              width: 2,
            ),

            // 🌟 Shadow luar + inner kesan timbul
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withOpacity(.45),
                blurRadius: 18,
                offset: const Offset(0, 10),
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.white24,
                blurRadius: 6,
                offset: Offset(-2, -2),
                spreadRadius: -2,
              ),
            ],
          ),

          child: Stack(
            children: [
              /// 🎈 dekor gelembung lucu
              Positioned(
                top: 10,
                right: 14,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.white.withOpacity(.25),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 12,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.white.withOpacity(.20),
                ),
              ),

              /// 🌟 konten utama
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotate,
                    builder: (context, child) => Transform.rotate(
                      angle: _rotate.value,
                      child: child,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        widget.icon,
                        color: widget.backgroundColor,
                        size: 32,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${widget.questionCount} soal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
