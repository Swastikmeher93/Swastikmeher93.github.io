import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/portfolio_data.dart';

// ── Embedded SVG logos ─────────────────────────────────────────────────────────
const _githubSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="white" d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
</svg>
''';

const _linkedinSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="white" d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 0 1-2.063-2.065 2.064 2.064 0 1 1 2.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
</svg>
''';

// ── NavBar ─────────────────────────────────────────────────────────────────────
class NavBar extends StatefulWidget {
  final void Function(String section)? onSectionTap;
  final ValueNotifier<String>? activeSection;
  const NavBar({super.key, this.onSectionTap, this.activeSection});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AnimationController _shimmerCtrl;

  final List<String> _items = ['About', 'Experience', 'Skills', 'Projects'];
  int? _hoveredNavIndex;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    _shimmerCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile  = w < 600;   // hide nav links
    final isCompact = w < 820;   // hide email chip

    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        height: 64,
        child: _LiquidGlassShell(
          shimmerCtrl: _shimmerCtrl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── LEFT: Logo ─────────────────────────────────────────────
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SSM',
                      style: GoogleFonts.pressStart2p(
                        fontSize: isMobile ? 10 : 13,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFB57BFF).withOpacity(0.8),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── CENTER: Nav links (desktop only) ───────────────────────
                if (!isMobile)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_items.length, (i) {
                      final activeNotifier = widget.activeSection ?? ValueNotifier<String>('About');
                      return ValueListenableBuilder<String>(
                        valueListenable: activeNotifier,
                        builder: (context, activeSection, child) {
                          final isActive = activeSection == _items[i];
                          final hovered = _hoveredNavIndex == i;
                          return MouseRegion(
                            onEnter: (_) => setState(() => _hoveredNavIndex = i),
                            onExit: (_) => setState(() => _hoveredNavIndex = null),
                            child: GestureDetector(
                              onTap: () => widget.onSectionTap?.call(_items[i]),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutBack,
                                scale: isActive ? 1.12 : (hovered ? 1.05 : 1.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  margin: EdgeInsets.only(
                                    left: i == 0 ? 0 : 4,
                                    right: i == _items.length - 1 ? 0 : 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: hovered
                                        ? Colors.white.withOpacity(0.08)
                                        : (isActive
                                            ? const Color(0xFFB57BFF).withOpacity(0.12)
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isActive
                                          ? const Color(0xFFB57BFF).withOpacity(0.3)
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  transform: Matrix4.translationValues(
                                    0,
                                    isActive ? -3.0 : (hovered ? -1.5 : 0.0),
                                    0.0,
                                  ),
                                  child: Text(
                                    _items[i],
                                    style: GoogleFonts.orbitron(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                      color: isActive
                                          ? const Color(0xFFB57BFF)
                                          : (hovered ? Colors.white : Colors.white.withOpacity(0.55)),
                                      shadows: isActive
                                          ? [
                                              Shadow(
                                                color: const Color(0xFFB57BFF).withOpacity(0.5),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                // ── RIGHT: Email chip + social icons ───────────────────────
                Expanded(
                  child: OverflowBox(
                    alignment: Alignment.centerRight,
                    maxWidth: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Email: hidden on compact / mobile
                        if (!isCompact) ...[
                          _GlassEmailChip(
                            onTap: () =>
                                _open('mailto:swastikmeher75@gmail.com'),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 18,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          const SizedBox(width: 10),
                        ],
                        // Resume button: hidden on mobile
                        if (!isMobile) ...[
                          _ResumeBtn(
                            onTap: () => _open(
                              'https://drive.google.com/file/d/1ZA_Mkw7OehjB23ITHiNtfXQQMHVBcMWY/view?usp=drive_link',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 18,
                            color: Colors.white.withOpacity(0.15),
                          ),
                          const SizedBox(width: 10),
                        ],
                        _GlassIconBtn(
                          svgData: _githubSvg,
                          label: 'GitHub',
                          onTap: () =>
                              _open('https://github.com/Swastikmeher93'),
                        ),
                        const SizedBox(width: 6),
                        _GlassIconBtn(
                          svgData: _linkedinSvg,
                          label: 'LinkedIn',
                          onTap: () => _open(
                            'https://www.linkedin.com/in/swastik-swarup-meher-107135176/',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Liquid Glass shell ─────────────────────────────────────────────────────────
class _LiquidGlassShell extends StatelessWidget {
  final AnimationController shimmerCtrl;
  final Widget child;

  const _LiquidGlassShell({
    required this.shimmerCtrl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Stack(
        children: [
          // Layer 1: Dark base + blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1C1C1E).withOpacity(0.82),
                    const Color(0xFF141416).withOpacity(0.88),
                    const Color(0xFF1A1020).withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),

          // Layer 2: Shimmer sweep
          AnimatedBuilder(
            animation: shimmerCtrl,
            builder: (context, _) {
              final t = shimmerCtrl.value;
              return Positioned(
                top: 0,
                bottom: 0,
                left: -200 + t * 1400,
                width: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Layer 3: Top specular edge
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Layer 4: Bottom shadow edge
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 1,
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Layer 5: Content
          child,
        ],
      ),
    );
  }
}

// ── Glass email chip ───────────────────────────────────────────────────────────
class _GlassEmailChip extends StatefulWidget {
  final VoidCallback onTap;
  const _GlassEmailChip({required this.onTap});

  @override
  State<_GlassEmailChip> createState() => _GlassEmailChipState();
}

class _GlassEmailChipState extends State<_GlassEmailChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withOpacity(0.14)
                : Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? Colors.white.withOpacity(0.35)
                  : Colors.white.withOpacity(0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 13,
                color: Colors.white.withOpacity(_hovered ? 0.9 : 0.55),
              ),
              const SizedBox(width: 7),
              Text(
                'swastikmeher75@gmail.com',
                style: GoogleFonts.orbitron(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  color: Colors.white.withOpacity(_hovered ? 0.9 : 0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Glass icon button ──────────────────────────────────────────────────────────
class _GlassIconBtn extends StatefulWidget {
  final String svgData;
  final String label;
  final VoidCallback onTap;

  const _GlassIconBtn({
    required this.svgData,
    required this.label,
    required this.onTap,
  });

  @override
  State<_GlassIconBtn> createState() => _GlassIconBtnState();
}

class _GlassIconBtnState extends State<_GlassIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered
                  ? Colors.white.withOpacity(0.18)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _hovered
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white.withOpacity(0.12),
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(_hovered ? 1.0 : 0.6),
                BlendMode.srcIn,
              ),
              child: SvgPicture.string(widget.svgData, width: 17, height: 17),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Resume button ──────────────────────────────────────────────────────────────
class _ResumeBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _ResumeBtn({required this.onTap});

  @override
  State<_ResumeBtn> createState() => _ResumeBtnState();
}

class _ResumeBtnState extends State<_ResumeBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: _hovered
                ? const LinearGradient(
                    colors: [Color(0xFFB57BFF), Color(0xFF7C3AED)],
                  )
                : null,
            color: _hovered ? null : Colors.transparent,
            border: Border.all(
              color: _hovered
                  ? const Color(0xFFB57BFF)
                  : const Color(0xFFB57BFF).withOpacity(0.45),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFB57BFF).withOpacity(0.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 13,
                color: _hovered
                    ? Colors.white
                    : const Color(0xFFB57BFF).withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                'Resume',
                style: GoogleFonts.orbitron(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: _hovered
                      ? Colors.white
                      : const Color(0xFFB57BFF).withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
