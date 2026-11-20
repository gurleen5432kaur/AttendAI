import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../auth/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
late AnimationController _gradientController;
late AnimationController _logoController;
late AnimationController _particleController;

late Animation<double> _logoScale;
late Animation<double> _logoOpacity;

@override
void initState() {
super.initState();

_gradientController = AnimationController(
vsync: this,
duration: const Duration(seconds: 8),
)..repeat(reverse: true);

_particleController = AnimationController(
vsync: this,
duration: const Duration(seconds: 15),
)..repeat();

_logoController = AnimationController(
vsync: this,
duration: const Duration(milliseconds: 1400),
);

_logoScale = Tween<double>(
begin: 0.75,
end: 1,
).animate(
CurvedAnimation(
parent: _logoController,
curve: Curves.easeOutBack,
),
);

_logoOpacity = Tween<double>(
begin: 0,
end: 1,
).animate(
CurvedAnimation(
parent: _logoController,
curve: Curves.easeIn,
),
);

_logoController.forward();

Timer(const Duration(seconds: 3), () {
if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => const RoleSelectionScreen(),
),
);
});
}

@override
void dispose() {
_gradientController.dispose();
_logoController.dispose();
_particleController.dispose();
super.dispose();
}

Widget buildParticle({
required double top,
required double left,
required double size,
required Color color,
}) {
return AnimatedBuilder(
animation: _particleController,
builder: (context, child) {
return Positioned(
top: top +
sin((_particleController.value * 2 * pi) + left / 50) * 18,
left: left +
cos((_particleController.value * 2 * pi) + top / 40) * 18,
child: Container(
width: size,
height: size,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: color,
boxShadow: [
BoxShadow(
color: color.withOpacity(0.45),
blurRadius: 30,
spreadRadius: 5,
),
],
),
),
);
},
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: AnimatedBuilder(
animation: _gradientController,
builder: (context, child) {
return Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color.lerp(
const Color(0xff081224),
const Color(0xff162447),
_gradientController.value,
)!,
Color.lerp(
const Color(0xff4F46E5),
const Color(0xff7C3AED),
_gradientController.value,
)!,
Color.lerp(
const Color(0xff0EA5E9),
const Color(0xff312E81),
_gradientController.value,
)!,
],
),
),
  child: Stack(
    children: [
      // Large glowing circles
      buildParticle(
        top: 120,
        left: 40,
        size: 180,
        color: Colors.blue.withOpacity(0.20),
      ),

      buildParticle(
        top: 520,
        left: 260,
        size: 150,
        color: Colors.purple.withOpacity(0.18),
      ),

      buildParticle(
        top: 700,
        left: 70,
        size: 100,
        color: Colors.cyan.withOpacity(0.20),
      ),

      buildParticle(
        top: 220,
        left: 260,
        size: 90,
        color: Colors.white.withOpacity(0.12),
      ),

      // Main Content
      Center(
        child: FadeTransition(
          opacity: _logoOpacity,
          child: ScaleTransition(
            scale: _logoScale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glass Logo Card
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white.withOpacity(0.10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.08),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 150,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "AttendAI",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "Smart Attendance Powered by AI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 16,
                    letterSpacing: 0.6,
                  ),
                ),

                const SizedBox(height: 50),

                LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.white,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ),

      Positioned(
        bottom: 45,
        left: 0,
        right: 0,
        child: Center(
          child: Text(
            "Version 1.0",
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 13,
            ),
          ),
        ),
      ),
    ],
  ),
);
},
),
);
}
}