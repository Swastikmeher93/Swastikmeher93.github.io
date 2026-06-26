/// Central data model for the portfolio.
/// Update the values here to reflect on the entire site.
import 'package:flutter/material.dart';

// ── Social / external links ──────────────────────────────────────────────────
class SocialLink {
  final String label;
  final String url;
  final String icon; // short text symbol shown in UI

  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });
}

const socialLinks = [
  SocialLink(
    label: 'GitHub',
    url: 'https://github.com/Swastikmeher93',
    icon: 'GH',
  ),
  SocialLink(
    label: 'LinkedIn',
    url: 'https://www.linkedin.com/in/swastik-swarup-meher-107135176/',
    icon: 'LI',
  ),
  SocialLink(
    label: 'Email',
    url: 'mailto:swastikmeher75@gmail.com',
    icon: '@',
  ),
];

// ── Project model ────────────────────────────────────────────────────────────
class Project {
  final String title;
  final String description;
  final String? githubUrl;   // null if private / not available
  final String? liveUrl;     // null if no live demo
  final List<String> tags;   // tech stack tags

  const Project({
    required this.title,
    required this.description,
    this.githubUrl,
    this.liveUrl,
    required this.tags,
  });
}

const projects = [
  Project(
    title: 'Flutter Portfolio',
    description: 'Personal developer portfolio built with Flutter Web, '
        'featuring animated grid backgrounds, typewriter effects and skill cards.',
    githubUrl: 'https://github.com/swastikmeher/portfolio',
    liveUrl: null,
    tags: ['Flutter', 'Dart', 'Web'],
  ),
  Project(
    title: 'FastAPI Backend',
    description: 'Scalable REST API backend with FastAPI, PostgreSQL, Redis '
        'caching and Docker-based deployment on GCP.',
    githubUrl: 'https://github.com/swastikmeher/fastapi-backend',
    liveUrl: null,
    tags: ['FastAPI', 'Python', 'PostgreSQL', 'Redis', 'GCP'],
  ),
  Project(
    title: 'Android App',
    description: 'Cross-platform Android application built with Flutter, '
        'backed by Firebase and Supabase for real-time data.',
    githubUrl: 'https://github.com/swastikmeher/android-app',
    liveUrl: null,
    tags: ['Flutter', 'Firebase', 'Supabase'],
  ),
];

// ── Experience model ─────────────────────────────────────────────────────────
class Experience {
  final String company;
  final String role;
  final String period;
  final String? badge;
  final Color accentColor;
  final List<String> bullets;

  const Experience({
    required this.company,
    required this.role,
    required this.period,
    this.badge,
    required this.accentColor,
    required this.bullets,
  });
}

const experiences = [
  Experience(
    company: 'Boxobit',
    role: 'Flutter Developer & Co-founder',
    period: 'Apr 2024 – Present',
    badge: '👾 Made with friends',
    accentColor: Color(0xFFB57BFF),
    bullets: [
      'Built and shipped production-level mobile apps using Flutter & Dart.',
      'Developed cross-platform and native Android applications at scale.',
      'Designed and deployed landing pages and business websites using WordPress.',
      'Collaborated closely with co-founders across design, development & delivery.',
    ],
  ),
  Experience(
    company: 'TheGoodGameTheory',
    role: 'Flutter Developer Intern',
    period: 'Sept 2025 – Nov 2025',
    accentColor: Color(0xFF54C5F8),
    bullets: [
      'Contributed to a gamified learning platform built with Flutter & Dart.',
      'Worked on a production-level codebase, delivering real features to end users.',
      'Collaborated with the team to improve app performance and user experience.',
    ],
  ),
  Experience(
    company: 'AiBuzz Technoventures Pvt. Ltd.',
    role: 'Flutter Developer Intern',
    period: 'Nov 2025 – Jun 2026',
    accentColor: Color(0xFF3ECF8E),
    bullets: [
      'Developed a full-featured healthcare application using Flutter & Dart.',
      'Implemented multi-role user authentication (patients, doctors, admins) backed by a FastAPI + PostgreSQL stack.',
      'Integrated interactive maps for clinic/hospital discovery and location-based search.',
      'Built a complete appointment booking system with scheduling, slot management, and notifications.',
      'Collaborated with backend and design teams to deliver a production-ready, scalable healthcare platform.',
    ],
  ),
];

// ── Owner info ───────────────────────────────────────────────────────────────
class Owner {
  final String name;
  final String title;
  final String bio;
  final String initials;

  const Owner({
    required this.name,
    required this.title,
    required this.bio,
    required this.initials,
  });
}

const owner = Owner(
  name: 'Swastik Swarup Meher',
  title: 'Fullstack Developer',
  bio: 'Fullstack Flutter developer with expertise in building highly scalable, '
      'cross-platform and native Android applications. Passionate about '
      'crafting performant backends and actively exploring the world of agentic AI.',
  initials: 'SSM',
);
