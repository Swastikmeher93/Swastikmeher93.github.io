import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/portfolio_data.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + experiences.length * 200),
    );

    _fadeAnims = List.generate(experiences.length, (i) {
      final start = (i * 0.25).clamp(0.0, 0.8);
      final end   = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    _slideAnims = List.generate(experiences.length, (i) {
      final start = (i * 0.25).clamp(0.0, 0.8);
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      );
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(),
        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Column(
              children: List.generate(experiences.length, (i) {
                return FadeTransition(
                  opacity: _fadeAnims[i],
                  child: SlideTransition(
                    position: _slideAnims[i],
                    child: _ExperienceCard(
                      exp: experiences[i],
                      isLast: i == experiences.length - 1,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'EXPERIENCE',
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF555555),
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 2,
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

// ── Experience card ────────────────────────────────────────────────────────────
class _ExperienceCard extends StatefulWidget {
  final Experience exp;
  final bool isLast;
  const _ExperienceCard({required this.exp, required this.isLast});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.exp.accentColor;

    return LayoutBuilder(builder: (context, constraints) {
      // Adapt layout based on available card width
      final narrow    = constraints.maxWidth < 520;
      final timelineW = narrow ? 28.0 : 48.0;
      final cardPad   = narrow ? 14.0 : 24.0;
      final companyFs = narrow ? 13.0 : 16.0;
      final roleFs    = narrow ? 9.0  : 10.0;
      final bulletFs  = narrow ? 9.0  : 10.0;
      final dotTop    = narrow ? 16.0 : 20.0;

      return Stack(
        children: [
          // ── Connector line (behind everything, stretches to row height) ────
          if (!widget.isLast)
            Positioned(
              left: timelineW / 2 - 0.5,
              top: dotTop + 16,
              bottom: 0,
              child: Container(width: 1, color: const Color(0xFF2A2A2A)),
            ),

          // ── Row: dot + card body ───────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline dot
              SizedBox(
                width: timelineW,
                child: Column(
                  children: [
                    SizedBox(height: dotTop),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hovered ? accent : const Color(0xFF2E2E2E),
                        border: Border.all(
                          color: _hovered ? accent : const Color(0xFF444444),
                          width: 2,
                        ),
                        boxShadow: _hovered
                            ? [BoxShadow(color: accent.withOpacity(0.4), blurRadius: 10)]
                            : [],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Card body ─────────────────────────────────────────────────
              Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hovered = true),
                  onExit:  (_) => setState(() => _hovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 24),
                    padding: EdgeInsets.all(cardPad),
                    decoration: BoxDecoration(
                      color: _hovered
                          ? accent.withOpacity(0.06)
                          : const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _hovered
                            ? accent.withOpacity(0.5)
                            : const Color(0xFF2A2A2A),
                        width: 1,
                      ),
                      boxShadow: _hovered
                          ? [BoxShadow(
                              color: accent.withOpacity(0.12),
                              blurRadius: 24,
                              spreadRadius: 2,
                            )]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header (stacks on narrow) ────────────────────────
                        if (narrow) ...[
                          Text(
                            widget.exp.company,
                            style: GoogleFonts.orbitron(
                              fontSize: companyFs,
                              fontWeight: FontWeight.w800,
                              color: _hovered ? accent : Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.exp.role,
                            style: GoogleFonts.orbitron(
                              fontSize: roleFs,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF888888),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _PeriodPill(
                              accent: accent,
                              period: widget.exp.period,
                              fontSize: 7),
                          if (widget.exp.badge != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              widget.exp.badge!,
                              style: GoogleFonts.orbitron(
                                fontSize: 7,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ] else ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.exp.company,
                                      style: GoogleFonts.orbitron(
                                        fontSize: companyFs,
                                        fontWeight: FontWeight.w800,
                                        color: _hovered ? accent : Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      widget.exp.role,
                                      style: GoogleFonts.orbitron(
                                        fontSize: roleFs,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF888888),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _PeriodPill(
                                      accent: accent,
                                      period: widget.exp.period,
                                      fontSize: 8),
                                  if (widget.exp.badge != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.exp.badge!,
                                      style: GoogleFonts.orbitron(
                                        fontSize: 8,
                                        color: const Color(0xFF666666),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 16),

                        // ── Divider ────────────────────────────────────────────
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              accent.withOpacity(_hovered ? 0.3 : 0.1),
                              Colors.transparent,
                            ]),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Bullet points ──────────────────────────────────────
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.exp.bullets.map((b) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 9),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: narrow ? 4 : 5,
                                      right: narrow ? 7 : 10,
                                    ),
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: accent.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      b,
                                      style: GoogleFonts.orbitron(
                                        fontSize: bulletFs,
                                        height: 1.7,
                                        color: const Color(0xFF999999),
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

// ── Period pill ────────────────────────────────────────────────────────────────
class _PeriodPill extends StatelessWidget {
  final Color accent;
  final String period;
  final double fontSize;

  const _PeriodPill({
    required this.accent,
    required this.period,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.3), width: 1),
      ),
      child: Text(
        period,
        style: GoogleFonts.orbitron(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: accent,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
