import 'dart:math' as math;
import 'package:flutter/material.dart';

class GridAnimationBackground extends StatefulWidget {
  const GridAnimationBackground({super.key});

  @override
  State<GridAnimationBackground> createState() =>
      _GridAnimationBackgroundState();
}

class _GridAnimationBackgroundState extends State<GridAnimationBackground>
    with TickerProviderStateMixin {
  // Controls the overall fade-in on load
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  // Controls random cell glow cycling
  late final AnimationController _glowCtrl;

  final math.Random _rng = math.Random(42);
  late final List<_GlowCell> _glowCells;

  static const int _cellSize = 28;
  static const int _glowCellCount = 18;

  @override
  void initState() {
    super.initState();

    // Fade-in on open: 0 → 1 over 1.2 s
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();

    // Glow cells cycle every 2.5 s
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Pre-generate fixed random glow cell positions (fractional 0–1)
    _glowCells = List.generate(_glowCellCount, (i) {
      return _GlowCell(
        fx: _rng.nextDouble(),
        fy: _rng.nextDouble(),
        phase: _rng.nextDouble(),
      );
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnim, _glowCtrl]),
      builder: (context, _) {
        return CustomPaint(
          painter: _GridPainter(
            fadeProgress: _fadeAnim.value,
            glowProgress: _glowCtrl.value,
            glowCells: _glowCells,
            cellSize: _cellSize.toDouble(),
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _GlowCell {
  final double fx;
  final double fy;
  final double phase;
  const _GlowCell({required this.fx, required this.fy, required this.phase});
}

class _GridPainter extends CustomPainter {
  final double fadeProgress;
  final double glowProgress;
  final List<_GlowCell> glowCells;
  final double cellSize;

  const _GridPainter({
    required this.fadeProgress,
    required this.glowProgress,
    required this.glowCells,
    required this.cellSize,
  });

  static const Color _gridColor = Color(0xFF2E2E2E);
  static const Color _glowColor = Color(0xFFB57BFF);

  @override
  void paint(Canvas canvas, Size size) {
    // ── 1. Draw grid lines ──────────────────────────────────────────────────
    final linePaint = Paint()
      ..color = _gridColor.withOpacity(0.7 * fadeProgress)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (double x = 0; x <= size.width; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // ── 2. Draw glowing cells ───────────────────────────────────────────────
    for (final cell in glowCells) {
      final t = (glowProgress + cell.phase) % 1.0;
      final brightness = math.sin(t * math.pi);
      if (brightness <= 0) continue;

      final cellX = (cell.fx * size.width / cellSize).floor() * cellSize;
      final cellY = (cell.fy * size.height / cellSize).floor() * cellSize;
      final rect = Rect.fromLTWH(cellX, cellY, cellSize, cellSize);

      // Cell fill glow
      canvas.drawRect(
        rect,
        Paint()
          ..color = _glowColor.withOpacity(0.06 * brightness * fadeProgress)
          ..style = PaintingStyle.fill,
      );

      // Cell border highlight
      canvas.drawRect(
        rect,
        Paint()
          ..color = _glowColor.withOpacity(0.4 * brightness * fadeProgress)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke,
      );

      // Corner dot glow
      canvas.drawCircle(
        Offset(cellX, cellY),
        2.0,
        Paint()
          ..color = _glowColor.withOpacity(0.7 * brightness * fadeProgress)
          ..style = PaintingStyle.fill,
      );
    }

    // ── 3. Radial vignette to fade edges ────────────────────────────────────
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height) / 2;

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            const Color(0xFF1A1A1A).withOpacity(0.6 * fadeProgress),
          ],
          stops: const [0.55, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius)),
    );
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.fadeProgress != fadeProgress || old.glowProgress != glowProgress;
}
