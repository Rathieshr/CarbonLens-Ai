import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationScaffold({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ask'),
        backgroundColor: Colors.greenAccent,
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
        label: const Text('Ask CarbonLens', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        backgroundColor: Colors.black87,
        indicatorColor: Colors.greenAccent.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.greenAccent),
            label: 'Command Center',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: Colors.greenAccent),
            label: 'Carbon Intelligence',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            selectedIcon: Icon(Icons.timeline, color: Colors.greenAccent),
            label: 'Carbon Future',
          ),
          NavigationDestination(
            icon: Icon(Icons.bolt_outlined),
            selectedIcon: Icon(Icons.bolt, color: Colors.greenAccent),
            label: 'Impact Center',
          ),
        ],
      ),
    );
  }
}
