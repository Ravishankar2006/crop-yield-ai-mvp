import 'package:flutter/material.dart';
import 'dart:ui';
import '../main.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _gradientController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _gradientController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    // Create animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.linear),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
    _gradientController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Colors.black, Colors.green[900], _gradientAnimation.value * 0.3) ?? Colors.black,
                  Colors.black,
                  Color.lerp(Colors.black, Colors.green[800], _gradientAnimation.value * 0.2) ?? Colors.black,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ...List.generate(6, (index) => _buildBackgroundParticle(index)),
                
                // Main content
                SafeArea(
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Glassmorphic logo container
                            _buildGlassmorphicLogo(),
                            SizedBox(height: 40),
                            
                            // Welcome text with gradient
                            _buildAnimatedText(),
                            SizedBox(height: 60),
                            
                            // Glassmorphic begin button
                            _buildGlassmorphicButton(),
                          ],
                        ),
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

  Widget _buildBackgroundParticle(int index) {
    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        final progress = (_gradientAnimation.value + index * 0.2) % 1.0;
        final size = 20.0 + (index * 10);
        final opacity = 0.1 + (progress * 0.2);
        
        return Positioned(
          left: (MediaQuery.of(context).size.width * progress) - size/2,
          top: 100 + (index * 100) + (progress * 50),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green[400]?.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: Colors.green[400]?.withOpacity(opacity * 0.5) ?? Colors.transparent,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicLogo() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.green[400]?.withOpacity(0.3) ?? Colors.transparent,
            Colors.green[600]?.withOpacity(0.1) ?? Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green[400]?.withOpacity(0.3) ?? Colors.transparent,
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.eco,
              size: 80,
              color: Colors.green[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.white70, Colors.green[300]!, Colors.white70],
          ).createShader(bounds),
          child: Text(
            "Welcome to",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 10),
        
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.green[300]!, Colors.green[400]!, Colors.green[500]!],
          ).createShader(bounds),
          child: Text(
            "HarvestPro",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(height: 20),
        
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "AI-Powered Crop Yield Prediction\n& Smart Farm Management",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white60,
              height: 1.5,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassmorphicButton() {
    return GestureDetector(
      onTap: () {
        _navigateToMain();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              Colors.green[400]?.withOpacity(0.8) ?? Colors.transparent,
              Colors.green[600]?.withOpacity(0.9) ?? Colors.transparent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green[400]?.withOpacity(0.4) ?? Colors.transparent,
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Begin Journey",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMain() {
    // Add a cool transition animation before navigation
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green[400]?.withOpacity(0.8),
          ),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
      ),
    );
    
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pop(); // Close loading dialog
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    });
  }
}
