import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import 'dart:math' as math;

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> with TickerProviderStateMixin {
  File? _image;
  String _diagnosisResult = "";
  bool _isAnalyzing = false;
  
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _resultController;
  late AnimationController _floatingController;
  
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _resultAnimation;
  late Animation<double> _floatingAnimation;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    
    _scanController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _resultController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.linear),
    );

    _pulseController.repeat(reverse: true);
    _floatingController.repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _resultController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, maxWidth: 800);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _diagnosisResult = "";
        _isAnalyzing = true;
      });

      // Start scanning animation
      _scanController.forward();

      // Simulate AI analysis
      await Future.delayed(Duration(seconds: 3));

      // Stop scanning and show result
      _scanController.reset();
      setState(() {
        _isAnalyzing = false;
        _diagnosisResult = _generateDiagnosis();
      });
      
      _resultController.forward();
    }
  }

  String _generateDiagnosis() {
    final diagnoses = [
      "🌱 Plant is healthy! No diseases detected.\n\nRecommendations:\n• Continue current care routine\n• Monitor for changes weekly\n• Ensure adequate watering",
      "⚠️ Early signs of leaf blight detected.\n\nRecommendations:\n• Apply fungicide spray\n• Reduce leaf wetness\n• Improve air circulation",
      "🐛 Pest activity detected on leaves.\n\nRecommendations:\n• Apply organic pesticide\n• Remove affected leaves\n• Monitor daily for changes",
      "💧 Signs of overwatering detected.\n\nRecommendations:\n• Reduce watering frequency\n• Improve soil drainage\n• Check root health",
    ];
    return diagnoses[math.Random().nextInt(diagnoses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGlassmorphicAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Colors.teal[900]!.withValues(alpha: 0.1),
              Colors.black,
              Colors.green[900]!.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating background elements
            ...List.generate(5, (index) => _buildFloatingElement(index)),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    _buildImageContainer(),
                    SizedBox(height: 30),
                    _buildActionButtons(),
                    SizedBox(height: 30),
                    if (_diagnosisResult.isNotEmpty) _buildResultCard(),
                    if (_isAnalyzing) _buildAnalyzingWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar() {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.white, Colors.teal[300]!],
        ).createShader(bounds),
        child: Text(
          'Plant Diagnosis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 56,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal[400]?.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal[400]?.withValues(alpha: 0.3) ?? Colors.transparent),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(Icons.history, color: Colors.teal[400]),
                  onPressed: () {
                    _showSnackBar("History feature coming soon!", Colors.teal[400]!);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElement(int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final progress = (_floatingAnimation.value + index * 0.2) % 1.0;
        final size = 12.0 + (index * 4);
        final colors = [Colors.teal, Colors.green, Colors.blue, Colors.cyan, Colors.lime];
        
        return Positioned(
          left: (MediaQuery.of(context).size.width * progress) - size/2,
          top: 100 + (index * 100) + (math.sin(progress * 4 * math.pi) * 40),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors[index].withValues(alpha: 0.4),
                  colors[index].withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[index].withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // Main image container
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal[400]!.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: _image == null
                    ? _buildPlaceholderContent()
                    : _buildImageContent(),
              ),
            ),
          ),
          
          // Scanning overlay when analyzing
          if (_isAnalyzing) _buildScanningOverlay(),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.teal[400]!.withValues(alpha: 0.3),
                        Colors.teal[600]!.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 60,
                    color: Colors.teal[300],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "No image selected",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tap camera or gallery to start",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Image.file(
        _image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.black.withValues(alpha: 0.3),
          ),
          child: Stack(
            children: [
              // Scanning line
              Positioned(
                left: 0,
                right: 0,
                top: 280 * _scanAnimation.value - 2,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.teal[400]!,
                        Colors.cyan[300]!,
                        Colors.teal[400]!,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal[400]!.withValues(alpha: 0.8),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Corner indicators
              ...List.generate(4, (index) => _buildCornerIndicator(index)),
              
              // Center analyzing text
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.teal[400]!.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400]!),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "AI Analyzing...",
                        style: TextStyle(
                          color: Colors.teal[300],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCornerIndicator(int index) {
    final positions = [
      {'top': 16.0, 'left': 16.0}, // Top-left
      {'top': 16.0, 'right': 16.0}, // Top-right
      {'bottom': 16.0, 'left': 16.0}, // Bottom-left
      {'bottom': 16.0, 'right': 16.0}, // Bottom-right
    ];
    
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: positions[index]['top'],
          left: positions[index]['left'],
          right: positions[index]['right'],
          bottom: positions[index]['bottom'],
          child: Opacity(
            opacity: 0.3 + (_scanAnimation.value * 0.7),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: index < 2 ? BorderSide(color: Colors.teal[400]!, width: 3) : BorderSide.none,
                  bottom: index >= 2 ? BorderSide(color: Colors.teal[400]!, width: 3) : BorderSide.none,
                  left: index % 2 == 0 ? BorderSide(color: Colors.teal[400]!, width: 3) : BorderSide.none,
                  right: index % 2 == 1 ? BorderSide(color: Colors.teal[400]!, width: 3) : BorderSide.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGlassmorphicButton(
          icon: Icons.camera_alt,
          label: "Camera",
          onPressed: () => _pickImage(ImageSource.camera),
          gradientColors: [Colors.teal[400]!, Colors.cyan[500]!],
        ),
        SizedBox(width: 20),
        _buildGlassmorphicButton(
          icon: Icons.photo_library,
          label: "Gallery",
          onPressed: () => _pickImage(ImageSource.gallery),
          gradientColors: [Colors.green[400]!, Colors.teal[500]!],
        ),
      ],
    );
  }

  Widget _buildGlassmorphicButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required List<Color> gradientColors,
  }) {
    return Expanded(
      child: SizedBox(
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradientColors[0].withValues(alpha: 0.3),
                    gradientColors[1].withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gradientColors[0].withValues(alpha: 0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onPressed,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: gradientColors[0], size: 24),
                        SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzingWidget() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.teal[400]!.withValues(alpha: 0.3),
                      Colors.cyan[500]!.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[400]!),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "AI Analysis in Progress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Scanning for diseases and pests...",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultCard() {
    return AnimatedBuilder(
      animation: _resultAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _resultAnimation.value,
          child: Opacity(
            opacity: _resultAnimation.value,
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.teal[400]!.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal[400]!.withValues(alpha: 0.2),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.teal[400]?.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.psychology,
                                color: Colors.teal[400],
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "AI Diagnosis Results",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            _diagnosisResult,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.cyan[300], size: 16),
                            SizedBox(width: 8),
                            Text(
                              "Powered by HarvestPro AI",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.cyan[300],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
