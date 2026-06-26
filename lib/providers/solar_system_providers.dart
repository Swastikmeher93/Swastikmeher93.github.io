import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Models ────────────────────────────────────────────────────────────────────

class StarData {
  final double x, y, baseRadius, twinkleSpeed, twinklePhase;
  final int colorValue;

  const StarData({
    required this.x,
    required this.y,
    required this.baseRadius,
    required this.twinkleSpeed,
    required this.twinklePhase,
    required this.colorValue,
  });
}

enum PlanetType { mercury, venus, earth, mars, jupiter, saturn }

class PlanetData {
  final double orbitRadiusFraction;
  final double planetRadius;
  final int colorValue;
  final int glowColorValue;
  final double speed;
  final double startAngle;
  final double spinSpeed;
  final PlanetType type;
  final bool hasMoon;
  final double moonOrbitRadius;
  final double moonRadius;
  final int moonColorValue;
  final double moonSpeed;
  final double moonStartAngle;
  final List<int>? ringColorValues;

  const PlanetData({
    required this.orbitRadiusFraction,
    required this.planetRadius,
    required this.colorValue,
    required this.glowColorValue,
    required this.speed,
    required this.startAngle,
    required this.spinSpeed,
    required this.type,
    this.hasMoon = false,
    this.moonOrbitRadius = 0,
    this.moonRadius = 0,
    this.moonColorValue = 0xFFCCCCCC,
    this.moonSpeed = 0,
    this.moonStartAngle = 0,
    this.ringColorValues,
  });
}

// ─── Providers ─────────────────────────────────────────────────────────────────

/// Cached list of background stars — generated once, never changes.
final starsProvider = Provider<List<StarData>>((ref) {
  final rng = Random(42);
  const starColors = [
    0xFFFFFFFF, 0xFFCCDDFF, 0xFFFFEECC, 0xFFDDCCFF, 0xFFAADDFF,
  ];
  return List.generate(280, (_) => StarData(
    x: rng.nextDouble(),
    y: rng.nextDouble(),
    baseRadius: 0.6 + rng.nextDouble() * 1.8,
    twinkleSpeed: 0.3 + rng.nextDouble() * 1.5,
    twinklePhase: rng.nextDouble() * 2 * pi,
    colorValue: starColors[rng.nextInt(starColors.length)],
  ));
});

/// Cached planet configuration — static solar system data.
final planetsProvider = Provider<List<PlanetData>>((ref) => [
  // Mercury — fastest orbit
  PlanetData(
    orbitRadiusFraction: 0.115, planetRadius: 8,
    colorValue: 0xFFB5B5B5, glowColorValue: 0xFFB5B5B5,
    speed: 1 / 2, startAngle: 0.8,
    spinSpeed: 1.2,
    type: PlanetType.mercury,
  ),
  // Venus
  PlanetData(
    orbitRadiusFraction: 0.175, planetRadius: 12,
    colorValue: 0xFFE8C47A, glowColorValue: 0xFFE8C47A,
    speed: 1 / 3.5, startAngle: 2.3,
    spinSpeed: 0.9,
    type: PlanetType.venus,
  ),
  // Earth
  PlanetData(
    orbitRadiusFraction: 0.255, planetRadius: 14,
    colorValue: 0xFF4AABDB, glowColorValue: 0xFF2196F3,
    speed: 1 / 5, startAngle: 4.1,
    spinSpeed: 1.8,
    type: PlanetType.earth,
    hasMoon: true, moonOrbitRadius: 28, moonRadius: 4,
    moonColorValue: 0xFFCCCCCC, moonSpeed: 1 / 2.0, moonStartAngle: 1.2,
  ),
  // Mars
  PlanetData(
    orbitRadiusFraction: 0.325, planetRadius: 11,
    colorValue: 0xFFCC4B2E, glowColorValue: 0xFFCC4B2E,
    speed: 1 / 8, startAngle: 1.0,
    spinSpeed: 1.6,
    type: PlanetType.mars,
  ),
  // Jupiter
  PlanetData(
    orbitRadiusFraction: 0.405, planetRadius: 24,
    colorValue: 0xFFD2A679, glowColorValue: 0xFFD2A679,
    speed: 1 / 13, startAngle: 3.5,
    spinSpeed: 3.0,
    type: PlanetType.jupiter,
  ),
  // Saturn
  PlanetData(
    orbitRadiusFraction: 0.480, planetRadius: 20,
    colorValue: 0xFFE8D5A3, glowColorValue: 0xFFE8D5A3,
    speed: 1 / 18, startAngle: 5.8,
    spinSpeed: 2.5,
    type: PlanetType.saturn,
    ringColorValues: [0xFFD4B896, 0xFFBFA882, 0xFFA08860],
  ),
]);

/// Current animation tick value (0.0 – 1.0).
/// Updated every frame by the SolarSystemBackground widget.
final animationValueProvider = StateProvider<double>((ref) => 0.0);

// ─── World Clock ───────────────────────────────────────────────────────────────

class CityData {
  final String city;
  final String country;
  final String flag;       // emoji flag
  final int utcOffsetMin;  // offset from UTC in minutes

  const CityData({
    required this.city,
    required this.country,
    required this.flag,
    required this.utcOffsetMin,
  });

  /// Returns the current local time for this city.
  DateTime get now =>
      DateTime.now().toUtc().add(Duration(minutes: utcOffsetMin));
}

/// The three cities to cycle through.
const List<CityData> worldCities = [
  CityData(
    city: 'Bengaluru',
    country: 'India',
    flag: '🇮🇳',
    utcOffsetMin: 330, // IST = UTC+5:30 (no DST)
  ),
  CityData(
    city: 'San Francisco',
    country: 'United States',
    flag: '🇺🇸',
    utcOffsetMin: -420, // PDT = UTC−7 (summer)
  ),
  CityData(
    city: 'London',
    country: 'United Kingdom',
    flag: '🇬🇧',
    utcOffsetMin: 60, // BST = UTC+1 (summer)
  ),
];

/// Ticks every second — drives the live clock display.
final clockTickProvider = StreamProvider.autoDispose<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

/// Index into [worldCities] — cycles 0 → 1 → 2 → 0 every 3 seconds.
/// The WorldClockWidget sets up a Timer to advance this automatically.
final activeCityProvider = StateProvider<int>((ref) => 0);

