import 'package:flutter/material.dart';
import 'package:liquid_glass_bridge/liquid_glass_bridge.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liquid Glass Bridge Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF267BFF)),
        useMaterial3: true,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  LiquidGlassMode _mode = LiquidGlassMode.auto;
  LiquidGlassQuality _quality = LiquidGlassQuality.medium;
  double _blur = 18;
  double _noise = 0.05;
  int _currentIndex = 0;

  static const List<LiquidGlassNavItem> _items = <LiquidGlassNavItem>[
    LiquidGlassNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    LiquidGlassNavItem(icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search'),
    LiquidGlassNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: LiquidGlassNavigationBar(
        mode: _mode,
        quality: _quality,
        blurSigma: _blur,
        noiseOpacity: _noise,
        title: const Text('Liquid Glass Bridge'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: LiquidGlassBottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: (int value) => setState(() => _currentIndex = value),
        mode: _mode,
        quality: _quality,
        blurSigma: _blur,
        noiseOpacity: _noise,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFFB9D6FF),
              Color(0xFFF9D7FF),
              Color(0xFFD4FFE7),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: <Widget>[
              _buildControls(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: <Widget>[
                  LiquidGlassButton(
                    mode: _mode,
                    quality: _quality,
                    blurSigma: _blur,
                    noiseOpacity: _noise,
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add),
                        SizedBox(width: 6),
                        Text('New'),
                      ],
                    ),
                  ),
                  LiquidGlassButton(
                    mode: _mode,
                    quality: _quality,
                    blurSigma: _blur,
                    noiseOpacity: _noise,
                    onPressed: () {},
                    child: const Text('Continue'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List<Widget>.generate(8, (int index) {
                return LiquidGlassSurface(
                  mode: _mode,
                  quality: _quality,
                  blurSigma: _blur,
                  noiseOpacity: _noise,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.4),
                        child: Text('${index + 1}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Glass Card #${index + 1}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return LiquidGlassSurface(
      mode: _mode,
      quality: _quality,
      blurSigma: _blur,
      noiseOpacity: _noise,
      margin: const EdgeInsets.only(top: 8),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _enumDropdown<LiquidGlassMode>(
                label: 'Mode',
                value: _mode,
                values: LiquidGlassMode.values,
                onChanged: (LiquidGlassMode value) => setState(() => _mode = value),
              ),
              _enumDropdown<LiquidGlassQuality>(
                label: 'Quality',
                value: _quality,
                values: LiquidGlassQuality.values,
                onChanged: (LiquidGlassQuality value) =>
                    setState(() => _quality = value),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Blur: ${_blur.toStringAsFixed(1)}'),
          Slider(
            value: _blur,
            min: 0,
            max: 32,
            onChanged: (double value) => setState(() => _blur = value),
          ),
          Text('Noise: ${_noise.toStringAsFixed(2)}'),
          Slider(
            value: _noise,
            min: 0,
            max: 0.2,
            onChanged: (double value) => setState(() => _noise = value),
          ),
        ],
      ),
    );
  }

  Widget _enumDropdown<T extends Enum>({
    required String label,
    required T value,
    required List<T> values,
    required ValueChanged<T> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('$label: '),
        DropdownButton<T>(
          value: value,
          onChanged: (T? next) {
            if (next != null) {
              onChanged(next);
            }
          },
          items: values
              .map(
                (T e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
