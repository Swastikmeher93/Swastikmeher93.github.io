import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/portfolio_data.dart';

class SocialLinksBar extends StatelessWidget {
  const SocialLinksBar({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < socialLinks.length; i++) ...[
          if (i > 0) ...[
            const SizedBox(width: 8),
            _Divider(),
            const SizedBox(width: 8),
          ],
          _SocialButton(
            link: socialLinks[i],
            onTap: () => _open(socialLinks[i].url),
          ),
        ],
      ],
    );
  }
}

// ── Vertical divider between links ───────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 14,
      color: const Color(0xFF3A3A3A),
    );
  }
}

// ── Individual social button ──────────────────────────────────────────────────
class _SocialButton extends StatefulWidget {
  final SocialLink link;
  final VoidCallback onTap;

  const _SocialButton({required this.link, required this.onTap});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFB57BFF).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFFB57BFF).withOpacity(0.5)
                  : const Color(0xFF333333),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon badge
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _hovered
                      ? const Color(0xFFB57BFF).withOpacity(0.2)
                      : const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  widget.link.icon,
                  style: GoogleFonts.orbitron(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: _hovered
                        ? const Color(0xFFB57BFF)
                        : const Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Label
              Text(
                widget.link.label,
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: _hovered
                      ? const Color(0xFFB57BFF)
                      : const Color(0xFF777777),
                ),
              ),
              // External link arrow
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(
                  Icons.open_in_new_rounded,
                  size: 12,
                  color: Color(0xFFB57BFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
