import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/portfolio_data.dart';

// ── GitHub SVG icon ────────────────────────────────────────────────────────────
const _githubSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="currentColor" d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12"/>
</svg>
''';

// Accent colour per project index
const _accentColors = [
  Color(0xFFF5A623), // amber  – Faith Connect
  Color(0xFF3ECF8E), // green  – BookCare
  Color(0xFFB57BFF), // purple – Task Manager
  Color(0xFF54C5F8), // blue   – Messaging App
];

// ── Main widget ───────────────────────────────────────────────────────────────
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + projects.length * 180),
    );

    _fadeAnims = List.generate(projects.length, (i) {
      final start = (i * 0.22).clamp(0.0, 0.8);
      final end   = (start + 0.3).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut)),
      );
    });

    _slideAnims = List.generate(projects.length, (i) {
      final start = (i * 0.22).clamp(0.0, 0.8);
      final end   = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.28), end: Offset.zero).animate(
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
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;

    return Column(
      children: [
        // ── Section header ─────────────────────────────────────────────────
        _SectionHeader(),
        const SizedBox(height: 40),

        // ── Project cards ──────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return isMobile
                // Single column on mobile
                ? Column(
                    children: List.generate(projects.length, (i) {
                      return FadeTransition(
                        opacity: _fadeAnims[i],
                        child: SlideTransition(
                          position: _slideAnims[i],
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: i < projects.length - 1 ? 20 : 0,
                            ),
                            child: _ProjectCard(
                              project: projects[i],
                              accent: _accentColors[i % _accentColors.length],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                // Responsive grid on wider screens
                : Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: List.generate(projects.length, (i) {
                      return FadeTransition(
                        opacity: _fadeAnims[i],
                        child: SlideTransition(
                          position: _slideAnims[i],
                          child: _ProjectCard(
                            project: projects[i],
                            accent: _accentColors[i % _accentColors.length],
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
          'PROJECTS',
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

// ── Project card ───────────────────────────────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final Project project;
  final Color accent;

  const _ProjectCard({required this.project, required this.accent});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 600;

    // Card is full-width on mobile, fixed 290 on desktop
    final cardWidth = isMobile ? double.infinity : 290.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: cardWidth,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _hovered ? accent.withOpacity(0.06) : const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? accent.withOpacity(0.55) : const Color(0xFF2A2A2A),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.14),
                    blurRadius: 28,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: accent bar + title + action buttons ─────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accent bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: _hovered
                        ? [BoxShadow(color: accent.withOpacity(0.7), blurRadius: 8)]
                        : [],
                  ),
                ),
                const SizedBox(width: 12),

                // Project title
                Expanded(
                  child: Text(
                    widget.project.title,
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _hovered ? accent : Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                // Buttons column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.project.liveUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _ActionBtn(
                          icon: Icons.play_circle_outline_rounded,
                          label: 'Demo',
                          accent: accent,
                          hovered: _hovered,
                          onTap: () => _launch(widget.project.liveUrl!),
                        ),
                      ),
                    if (widget.project.githubUrl != null)
                      Padding(
                        padding: widget.project.storeUrl != null
                            ? const EdgeInsets.only(bottom: 6)
                            : EdgeInsets.zero,
                        child: _ActionBtn(
                          icon: Icons.code_rounded,
                          label: 'GitHub',
                          accent: accent,
                          hovered: _hovered,
                          onTap: () => _launch(widget.project.githubUrl!),
                        ),
                      ),
                    if (widget.project.storeUrl != null)
                      _ActionBtn(
                        icon: Icons.shop_rounded,
                        label: 'Play Store',
                        accent: accent,
                        hovered: _hovered,
                        onTap: () => _launch(widget.project.storeUrl!),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Divider ────────────────────────────────────────────────────
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  accent.withOpacity(_hovered ? 0.3 : 0.08),
                  Colors.transparent,
                ]),
              ),
            ),

            const SizedBox(height: 14),

            // ── Description ────────────────────────────────────────────────
            Text(
              widget.project.description,
              style: GoogleFonts.orbitron(
                fontSize: 9,
                height: 1.8,
                color: const Color(0xFF888888),
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 18),

            // ── Tech tags ──────────────────────────────────────────────────
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: widget.project.tags
                  .map((tag) => _TagPill(label: tag, accent: accent))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable action button (GitHub / Demo) ────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final bool hovered;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.accent,
    required this.hovered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: hovered
                ? accent.withOpacity(0.15)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hovered
                  ? accent.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 12,
                color: hovered ? accent : Colors.white.withOpacity(0.5),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.orbitron(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: hovered ? accent : Colors.white.withOpacity(0.5),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tag pill ───────────────────────────────────────────────────────────────────
class _TagPill extends StatelessWidget {
  final String label;
  final Color accent;

  const _TagPill({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: accent.withOpacity(0.22), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.orbitron(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: accent.withOpacity(0.85),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
