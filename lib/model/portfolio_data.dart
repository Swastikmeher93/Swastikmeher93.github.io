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
  SocialLink(label: 'Email', url: 'mailto:swastikmeher75@gmail.com', icon: '@'),
];

// ── Project model ────────────────────────────────────────────────────────────
class Project {
  final String title;
  final String description;
  final String? githubUrl; // null if private / not available
  final String? liveUrl; // null if no live demo
  final String? storeUrl; // null if not on a store
  final List<String> tags; // tech stack tags

  const Project({
    required this.title,
    required this.description,
    this.githubUrl,
    this.liveUrl,
    this.storeUrl,
    required this.tags,
  });
}

const projects = [
  Project(
    title: 'Faith Connect',
    description:
        'A community-driven spiritual networking app built with Flutter. '
        'Connects users with faith-based communities, events, and resources, '
        'powered by Supabase for real-time data and Firebase for media storage.',
    githubUrl: null,
    liveUrl: 'https://appetize.io/app/b_aev24e3aeelfezs36vcfotmn6u',
    tags: ['Flutter', 'Dart', 'Supabase', 'Firebase'],
  ),
  Project(
    title: 'BookCare',
    description:
        'A full-featured healthcare app built with Flutter. Supports multi-role auth '
        '(patients, doctors, admins), interactive maps for clinic discovery, and a '
        'complete appointment booking system with slot management and notifications.',
    githubUrl: 'https://github.com/Swastikmeher93/bookcare',
    liveUrl: null,
    tags: ['Flutter', 'Dart', 'FastAPI', 'PostgreSQL', 'Supabase'],
  ),
  Project(
    title: 'Task Manager',
    description:
        'A clean and intuitive task management application with real-time updates, '
        'task categorisation, priority levels, and deadline tracking.',
    githubUrl: 'https://github.com/Swastikmeher93/task-manager',
    storeUrl:
        'https://play.google.com/store/apps/details?id=com.techcruise.myapp',
    liveUrl: null,
    tags: ['Flutter', 'Dart', 'Sqflite'],
  ),
  Project(
    title: 'Messaging App',
    description:
        'A real-time messaging application featuring one-on-one and group chats, '
        'media sharing, and push notifications backed by Firebase.',
    githubUrl: 'https://github.com/Swastikmeher93/messaging-app',
    liveUrl: null,
    tags: ['Flutter', 'Dart', 'Android', 'Platform-channel'],
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
  final String? companyUrl;

  const Experience({
    required this.company,
    required this.role,
    required this.period,
    this.badge,
    required this.accentColor,
    required this.bullets,
    this.companyUrl,
  });
}

const experiences = [
  Experience(
    company: 'AiBuzz Technoventures Pvt. Ltd.',
    role: 'Flutter Developer Intern',
    period: 'Nov 2025 – Present',
    accentColor: Color(0xFF3ECF8E),
    bullets: [
      '📱 Project 1 — Health Tech Application',
      'Built a full-featured healthcare app in Flutter & Dart with multi-role auth (patients, doctors, admins) backed by FastAPI + PostgreSQL.',
      'Integrated interactive maps for clinic/hospital discovery, location-based search, and a complete appointment booking system with scheduling, slot management, and push notifications.',
      '🛠️ Project 2 — SaaS Field Service Management Application',
      'Developed a multi-role SaaS platform supporting Customers, Field Engineers, and Vendors with role-specific dashboards and workflows.',
      'Implemented service request lifecycle management — from customer ticket creation, engineer assignment & on-site tracking, to vendor inventory coordination and resolution reporting.',
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
    company: 'Boxobit',
    role: 'Flutter Developer & Co-founder',
    period: 'Apr 2024 – Present',
    badge: '👾 Made with friends',
    accentColor: Color(0xFFB57BFF),
    companyUrl: 'https://boxobit.com/',
    bullets: [
      'Built and shipped production-level mobile apps using Flutter & Dart.',
      'Developed cross-platform and native Android applications at scale.',
      'Designed and deployed landing pages and business websites using WordPress.',
      'Collaborated closely with co-founders across design, development & delivery.',
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
  bio:
      'Fullstack Flutter developer with expertise in building highly scalable, '
      'cross-platform and native Android applications. Passionate about '
      'crafting performant backends and actively exploring the world of agentic AI.',
  initials: 'SSM',
);
