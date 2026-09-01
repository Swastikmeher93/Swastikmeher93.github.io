import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class _SkillTag {
  final String name;
  final Color accent;
  const _SkillTag(this.name, this.accent);
}

class _Category {
  final String label;
  final Color headerAccent;
  final List<_SkillTag> skills;
  const _Category(this.label, this.headerAccent, this.skills);
}

const _categories = [
  _Category(
    'LANG',
    Color(0xFFB57BFF),
    [
      _SkillTag('Python',     Color(0xFF3776AB)),
      _SkillTag('Dart',       Color(0xFF0175C2)),
      _SkillTag('Kotlin',     Color(0xFF7F52FF)),
      _SkillTag('JS / TS',    Color(0xFFF7DF1E)),
      _SkillTag('HTML',       Color(0xFFE34F26)),
      _SkillTag('CSS',        Color(0xFF1572B6)),
    ],
  ),
  _Category(
    'FRAMEWORK',
    Color(0xFF54C5F8),
    [
      _SkillTag('Flutter',          Color(0xFF54C5F8)),
      _SkillTag('Jetpack Compose',   Color(0xFF4285F4)),
      _SkillTag('Android',          Color(0xFF3DDC84)),
      _SkillTag('iOS',              Color(0xFF999999)),
      _SkillTag('FastAPI',          Color(0xFF009688)),
      _SkillTag('React',            Color(0xFF61DAFB)),
      _SkillTag('Node.js',          Color(0xFF339933)),
    ],
  ),
  _Category(
    'INFRA & DATABASE',
    Color(0xFFFF9900),
    [
      _SkillTag('GCP',        Color(0xFF4285F4)),
      _SkillTag('AWS',        Color(0xFFFF9900)),
      _SkillTag('Linux',      Color(0xFFFCC624)),
      _SkillTag('PostgreSQL', Color(0xFF336791)),
      _SkillTag('Firebase',   Color(0xFFFFCA28)),
      _SkillTag('Supabase',   Color(0xFF3ECF8E)),
      _SkillTag('Redis',      Color(0xFFDC382D)),
      _SkillTag('Docker',     Color(0xFF2496ED)),
      _SkillTag('Kubernetes', Color(0xFF326CE5)),
      _SkillTag('Git / GitHub', Color(0xFFF05032)),
      _SkillTag('CI / CD',    Color(0xFF2088FF)),
    ],
  ),
];

// ── Main widget ───────────────────────────────────────────────────────────────
class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + _categories.length * 150),
    );

    _fadeAnims = List.generate(_categories.length, (i) {
      final start = (i * 0.2).clamp(0.0, 0.8);
      final end   = (start + 0.25).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    _slideAnims = List.generate(_categories.length, (i) {
      final start = (i * 0.2).clamp(0.0, 0.8);
      final end   = (start + 0.3).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      );
    });

    Future.delayed(const Duration(milliseconds: 500), () {
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
        // ── Section header ─────────────────────────────────────────────────
        _SectionHeader(),
        const SizedBox(height: 32),

        // ── Category cards ─────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(_categories.length, (i) {
                return FadeTransition(
                  opacity: _fadeAnims[i],
                  child: SlideTransition(
                    position: _slideAnims[i],
                    child: _CategoryCard(category: _categories[i]),
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

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SKILLS',
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

// ── Category card ─────────────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final _Category category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.category.headerAccent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 220,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? accent.withOpacity(0.07) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? accent.withOpacity(0.7) : const Color(0xFF2E2E2E),
            width: 1.2,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: accent.withOpacity(0.18), blurRadius: 22, spreadRadius: 2)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category label + accent bar
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: _hovered
                        ? [BoxShadow(color: accent.withOpacity(0.6), blurRadius: 8)]
                        : [],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.category.label,
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _hovered ? accent : accent.withOpacity(0.7),
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Skill pills
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.category.skills
                  .map((s) => _SkillPill(skill: s))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Skill pill ────────────────────────────────────────────────────────────────
class _SkillPill extends StatefulWidget {
  final _SkillTag skill;
  const _SkillPill({required this.skill});

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.skill.accent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? accent.withOpacity(0.15) : const Color(0xFF282828),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hovered ? accent.withOpacity(0.8) : const Color(0xFF383838),
            width: 1,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 10)]
              : [],
        ),
        child: Text(
          widget.skill.name,
          style: GoogleFonts.orbitron(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: _hovered ? accent : const Color(0xFF888888),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
