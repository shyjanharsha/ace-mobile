import 'dart:math';
import 'package:flutter/material.dart';

class WinnerConfetti extends StatefulWidget {
  const WinnerConfetti({super.key});

  @override
  State<WinnerConfetti> createState() => _WinnerConfettiState();
}

class _WinnerConfettiState extends State<WinnerConfetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Generate initial particles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.sizeOf(context);
      for (int i = 0; i < 80; i++) {
        _particles.add(_ConfettiParticle(
          x: _random.nextDouble() * size.width,
          y: -_random.nextDouble() * size.height,
          color: _randomColor(),
          size: _random.nextDouble() * 8 + 6,
          speed: _random.nextDouble() * 3 + 2,
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.1,
          drift: (_random.nextDouble() - 0.5) * 0.8,
        ));
      }
    });
  }

  Color _randomColor() {
    final colors = [
      const Color(0xFF38B6FF), // Cyan
      const Color(0xFFFF4D4D), // Red
      const Color(0xFFFFB300), // Gold
      const Color(0xFF10B981), // Green
      const Color(0xFFE02424), // Crimson
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Purple
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update particles
        for (final p in _particles) {
          p.y += p.speed;
          p.x += p.drift;
          p.rotation += p.rotationSpeed;

          // Wrap around if falls off bottom
          if (p.y > size.height) {
            p.y = -20;
            p.x = _random.nextDouble() * size.width;
          }
        }

        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(particles: _particles),
        );
      },
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double speed;
  double rotation;
  final double rotationSpeed;
  final double drift;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
    required this.drift,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      paint.color = p.color;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      // Draw a small rectangle or circle
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: p.size,
        height: p.size * 1.6,
      );
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(rrect, paint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
