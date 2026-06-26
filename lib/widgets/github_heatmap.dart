// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubHeatmap extends StatefulWidget {
  final String username;
  const GitHubHeatmap({super.key, required this.username});

  @override
  State<GitHubHeatmap> createState() => _GitHubHeatmapState();
}

class _GitHubHeatmapState extends State<GitHubHeatmap> {
  static bool _registered = false;
  late final String _viewType;

  Future<void> _openGitHub() async {
    final uri = Uri.parse('https://github.com/${widget.username}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _viewType = 'gh-heatmap-${widget.username}';

    if (!_registered) {
      _registered = true;
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.backgroundColor = '#1C1C1C'
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.padding = '0';

        final img = html.ImageElement()
          ..src = 'https://ghchart.rshah.org/B57BFF/${widget.username}'
          ..style.width = '100%'
          ..style.height = 'auto'
          ..style.display = 'block'
          // invert(1)         → white becomes black (dark bg friendly)
          // hue-rotate(180deg) → rotates hue back so purple stays purple
          ..style.filter = 'invert(1) hue-rotate(180deg) brightness(0.95)';

        container.append(img);
        return container;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Section header (centered like Skills / Experience) ────────────
        _buildHeader(),
        const SizedBox(height: 28),

        // ── Card (constrained width, scales responsively) ────────────────
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  'GitHub Activity — Last 12 Months',
                  style: GoogleFonts.orbitron(
                    fontSize: 9,
                    color: const Color(0xFF555555),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Heatmap (LayoutBuilder for responsive height) ─────────
                LayoutBuilder(builder: (context, constraints) {
                  // ghchart SVG is ~719 × 112 → ratio ≈ 6.4
                  // Divide by 7.5 + tighter clamp for a slimmer bar
                  final h = (constraints.maxWidth / 7.5).clamp(58.0, 110.0);
                  return SizedBox(
                    height: h,
                    width: double.infinity,
                    child: HtmlElementView(viewType: _viewType),
                  );
                }),

                const SizedBox(height: 14),

                // ── Legend ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Less',
                        style: GoogleFonts.orbitron(
                            fontSize: 8, color: const Color(0xFF444444))),
                    const SizedBox(width: 6),
                    for (final op in [0.12, 0.28, 0.48, 0.70, 1.0])
                      Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB57BFF).withOpacity(op),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    const SizedBox(width: 6),
                    Text('More',
                        style: GoogleFonts.orbitron(
                            fontSize: 8, color: const Color(0xFF444444))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Section header ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'CONTRIBUTIONS',
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
        const SizedBox(height: 14),
        _GitHubLink(username: widget.username, onTap: _openGitHub),
      ],
    );
  }
}

// ── Clickable @username link ───────────────────────────────────────────────────
class _GitHubLink extends StatefulWidget {
  final String username;
  final VoidCallback onTap;
  const _GitHubLink({required this.username, required this.onTap});

  @override
  State<_GitHubLink> createState() => _GitHubLinkState();
}

class _GitHubLinkState extends State<_GitHubLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                color: _hovered
                    ? const Color(0xFFB57BFF)
                    : const Color(0xFF555555),
              ),
              child: Text('@${widget.username}'),
            ),
            const SizedBox(width: 5),
            AnimatedOpacity(
              opacity: _hovered ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: const Icon(Icons.open_in_new_rounded,
                  size: 12, color: Color(0xFFB57BFF)),
            ),
          ],
        ),
      ),
    );
  }
}
