import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

import '../widgets/experience_section.dart';
import '../widgets/github_heatmap.dart';
import '../widgets/grid_animation_background.dart';
import '../widgets/nav_bar.dart';
import '../widgets/skills_section.dart';
import '../widgets/world_clock_widget.dart';

// Shared scroll progress notifier (0.0 → 1.0)
final _scrollProgress = ValueNotifier<double>(0.0);

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          // Layer 1: Animated grid background
          const GridAnimationBackground(),

          // Layer 2: Scrollable foreground content
          const _ForegroundContent(),

          // Layer 3: Scroll progress bar — sits flush below the navbar
          Positioned(
            top: 64,
            left: 0,
            right: 0,
            height: 3,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollProgress,
              builder: (_, progress, __) {
                return Stack(
                  children: [
                    // Track
                    Container(color: const Color(0xFF2A2A2A)),
                    // Fill
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFB57BFF), Color(0xFF54C5F8)],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Layer 4: Fixed navbar (always on top)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64,
            child: NavBar(),
          ),
        ],
      ),
    );
  }
}

class _ForegroundContent extends StatefulWidget {
  const _ForegroundContent();

  @override
  State<_ForegroundContent> createState() => _ForegroundContentState();
}

class _ForegroundContentState extends State<_ForegroundContent> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final max = _scrollCtrl.position.maxScrollExtent;
      if (max > 0) {
        _scrollProgress.value = _scrollCtrl.offset / max;
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;
    final isTablet  = w < 1024;
    final hPad = isMobile ? 16.0 : isTablet ? 32.0 : 64.0;
    final vGap = isMobile ? 48.0 : 80.0;

    return SingleChildScrollView(
      controller: _scrollCtrl,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Padding(
            padding: EdgeInsets.only(
              top: isMobile ? 72 : 88,
              bottom: 80,
              left: hPad,
              right: hPad,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const WorldClockWidget(),
                const SizedBox(height: 24),
                const _AnimatedName(),
                const SizedBox(height: 14),
                _RoleTag(),
                const SizedBox(height: 22),
                const _TypewriterParagraph(),
                SizedBox(height: vGap),
                const SkillsSection(),
                SizedBox(height: vGap),
                const ExperienceSection(),
                SizedBox(height: vGap),
                const GitHubHeatmap(username: 'Swastikmeher93'),
                SizedBox(height: vGap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated shimmer name ─────────────────────────────────────────────────────
class _AnimatedName extends StatefulWidget {
  const _AnimatedName();

  @override
  State<_AnimatedName> createState() => _AnimatedNameState();
}

class _AnimatedNameState extends State<_AnimatedName>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final angle = _ctrl.value * 2 * math.pi;
            return LinearGradient(
              begin: Alignment(math.cos(angle), math.sin(angle)),
              end: Alignment(-math.cos(angle), -math.sin(angle)),
              colors: const [
                Color(0xFFFFFFFF),
                Color(0xFFB0B0B0),
                Color(0xFFFFFFFF),
                Color(0xFFB57BFF),
                Color(0xFFFFFFFF),
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            'Swastik Swarup Meher',
            textAlign: TextAlign.center,
            style: GoogleFonts.pressStart2p(
              fontSize: 36,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              color: Colors.white,
              height: 1.6,
            ),
          ),
        );
      },
    );
  }
}

// ── Role tag with accent underline ───────────────────────────────────────────
class _RoleTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fullstack Developer',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFAAAAAA),
            letterSpacing: 4.0,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Color(0xFFB57BFF), Color(0xFF7C3AED)],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Typewriter paragraph ──────────────────────────────────────────────────────
class _TypewriterParagraph extends StatefulWidget {
  const _TypewriterParagraph();

  @override
  State<_TypewriterParagraph> createState() => _TypewriterParagraphState();
}

class _TypewriterParagraphState extends State<_TypewriterParagraph>
    with SingleTickerProviderStateMixin {
  static const String _fullText =
      'Fullstack Flutter developer with expertise in building highly scalable, '
      'cross-platform and native Android applications. Passionate about '
      'crafting performant backends and actively exploring the world of agentic AI.';

  static const int _startDelayMs = 800;
  static const int _msPerChar = 28;

  late final AnimationController _cursorCtrl;
  int _visibleChars = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();

    _cursorCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: _startDelayMs), _tick);
  }

  void _tick() {
    if (!mounted) return;
    if (_visibleChars < _fullText.length) {
      setState(() => _visibleChars++);
      Future.delayed(const Duration(milliseconds: _msPerChar), _tick);
    } else {
      setState(() => _done = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _cursorCtrl.stop();
      });
    }
  }

  @override
  void dispose() {
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _fullText.substring(0, _visibleChars);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: AnimatedBuilder(
        animation: _cursorCtrl,
        builder: (context, _) {
          final showCursor = !_done || _cursorCtrl.value > 0.5;
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.orbitron(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
                letterSpacing: 0.8,
                height: 1.9,
              ),
              children: [
                TextSpan(text: visible),
                if (showCursor)
                  TextSpan(
                    text: '|',
                    style: GoogleFonts.orbitron(
                      color: const Color(0xFFB57BFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
