import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/solar_system_providers.dart';

class WorldClockWidget extends ConsumerStatefulWidget {
  const WorldClockWidget({super.key});

  @override
  ConsumerState<WorldClockWidget> createState() => _WorldClockWidgetState();
}

class _WorldClockWidgetState extends ConsumerState<WorldClockWidget> {
  Timer? _cityTimer;

  @override
  void initState() {
    super.initState();
    _cityTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      final current = ref.read(activeCityProvider);
      ref.read(activeCityProvider.notifier).state =
          (current + 1) % worldCities.length;
    });
  }

  @override
  void dispose() {
    _cityTimer?.cancel();
    super.dispose();
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final cityIndex = ref.watch(activeCityProvider);
    ref.watch(clockTickProvider); // rebuild every second

    final city  = worldCities[cityIndex];
    final now   = city.now;

    // 12-hour conversion
    final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm   = now.hour < 12 ? 'AM' : 'PM';
    final time   = '${_pad(hour12)}:${_pad(now.minute)}:${_pad(now.second)}';

    return Center(
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.5),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text.rich(
            key: ValueKey(cityIndex),
            TextSpan(
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              children: [
                // Flag
                TextSpan(
                  text: '${city.flag}  ',
                  style: const TextStyle(fontSize: 15),
                ),
                // City · Country
                TextSpan(
                  text: '${city.city} · ${city.country}  ',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.5,
                  ),
                ),
                // Time (12-hr)
                TextSpan(
                  text: time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                  ),
                ),
                // AM / PM
                TextSpan(
                  text: '  $ampm',
                  style: TextStyle(
                    color: const Color(0xFFAADDFF).withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
    );
  }
}
