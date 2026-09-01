import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── About section ─────────────────────────────────────────────────────────────
class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 300), () {
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
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Column(
          children: [
            // ── Section header ───────────────────────────────────────────────
            _SectionHeader(),
            const SizedBox(height: 40),

            // ── Main card ────────────────────────────────────────────────────
            _AboutCard(isMobile: isMobile),

            const SizedBox(height: 24),

            // ── Stat pills row ───────────────────────────────────────────────
            _StatsRow(isMobile: isMobile),
          ],
        ),
      ),
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
          'ABOUT',
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

// ── About card ─────────────────────────────────────────────────────────────────
class _AboutCard extends StatefulWidget {
  final bool isMobile;
  const _AboutCard({required this.isMobile});

  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _hovered = false;

  static const _paragraph =
      "I'm Swastik Swarup Meher — a Fullstack Developer with a deep passion for "
      "building elegant, high-performance mobile and web applications. My primary "
      "weapon is Flutter, which I've used to ship production-grade apps across "
      "healthcare, gaming, and productivity domains. On the backend, I architect "
      "scalable REST APIs with FastAPI and PostgreSQL, and I'm well-versed in "
      "cloud infrastructure on GCP and AWS.\n\n"
      "Beyond code, I'm a co-founder at Boxobit — a small but mighty product studio "
      "where we design, build, and ship apps end-to-end. I'm actively exploring the "
      "world of agentic AI and love tinkering at the intersection of intelligent "
      "systems and beautiful interfaces. When I'm not shipping features, you'll find "
      "me contributing to open source or learning something new.";

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: EdgeInsets.all(widget.isMobile ? 20 : 32),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFFB57BFF).withOpacity(0.05)
              : const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered
                ? const Color(0xFFB57BFF).withOpacity(0.45)
                : const Color(0xFF2A2A2A),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFB57BFF).withOpacity(0.08),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Accent bar + label
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFB57BFF),
                        const Color(0xFF7C3AED).withOpacity(0.5),
                      ],
                    ),
                    boxShadow: _hovered
                        ? [
                            BoxShadow(
                              color: const Color(0xFFB57BFF).withOpacity(0.6),
                              blurRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Who am I?',
                  style: GoogleFonts.orbitron(
                    fontSize: widget.isMobile ? 11 : 13,
                    fontWeight: FontWeight.w700,
                    color: _hovered
                        ? const Color(0xFFB57BFF)
                        : const Color(0xFFB57BFF).withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFB57BFF).withOpacity(_hovered ? 0.25 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Paragraph
            Text(
              _paragraph,
              style: GoogleFonts.orbitron(
                fontSize: widget.isMobile ? 9.5 : 10.5,
                height: 2.0,
                color: const Color(0xFF999999),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stats row ──────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({required this.isMobile});

  static const _stats = [
    _Stat('11+', 'Months of\nExperience', Color(0xFFB57BFF)),
    _Stat('2+', 'Apps\nShipped', Color(0xFF3ECF8E)),
    _Stat('2', 'Companies\nWorked', Color(0xFF54C5F8)),
    _Stat('∞', 'Problems\nSolved', Color(0xFFF5A623)),
  ];

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _stats.map((s) => _StatPill(stat: s)).toList(),
          )
        : Row(
            children: _stats
                .map(
                  (s) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: s == _stats.last ? 0 : 12,
                      ),
                      child: _StatPill(stat: s),
                    ),
                  ),
                )
                .toList(),
          );
  }
}

class _Stat {
  final String value;
  final String label;
  final Color accent;
  const _Stat(this.value, this.label, this.accent);
}

// ── Stat pill ──────────────────────────────────────────────────────────────────
class _StatPill extends StatefulWidget {
  final _Stat stat;
  const _StatPill({required this.stat});

  @override
  State<_StatPill> createState() => _StatPillState();
}

class _StatPillState extends State<_StatPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.stat.accent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: _hovered ? accent.withOpacity(0.08) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? accent.withOpacity(0.5) : const Color(0xFF282828),
            width: 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: accent.withOpacity(0.15), blurRadius: 20)]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.stat.value,
              style: GoogleFonts.orbitron(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: _hovered ? accent : accent.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.stat.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                fontSize: 8,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
                letterSpacing: 1,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
