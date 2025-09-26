import 'package:flutter/material.dart';
import 'dart:ui';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _statsController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _statsAnimation;

  // Enhanced sample data
  String predictedYield = "26 quintals";
  String cropHealth = "Healthy - No major risks";
  String weather = "Sunny, 28°C";
  String nextIrrigation = "Tomorrow";
  double cropProgress = 0.75;
  
  List<Map<String, dynamic>> alerts = [
    {
      'title': 'Uneven soil moisture detected',
      'severity': 'medium',
      'icon': Icons.water_drop,
    },
    {
      'title': 'Pest scouting recommended',
      'severity': 'low', 
      'icon': Icons.bug_report,
    },
  ];

  List<Map<String, dynamic>> quickActions = [
    {'title': 'Add Task', 'icon': Icons.add_task, 'color': Colors.green},
    {'title': 'Weather', 'icon': Icons.cloud, 'color': Colors.blue},
    {'title': 'Reports', 'icon': Icons.analytics, 'color': Colors.orange},
    {'title': 'Market', 'icon': Icons.store, 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _statsController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _statsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _statsController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGlassmorphicAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Colors.green[900]!.withOpacity(0.1),
              Colors.black,
              Colors.green[800]!.withOpacity(0.05),
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedWelcomeCard(),
                  SizedBox(height: 20),
                  _buildNeuomorphicStatsGrid(),
                  SizedBox(height: 20),
                  _buildGlassmorphicQuickActions(),
                  SizedBox(height: 20),
                  _buildAnimatedProgressCard(),
                  SizedBox(height: 20),
                  _buildPremiumActivityFeed(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassmorphicAppBar() {
    return AppBar(
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.white, Colors.green[300]!],
        ).createShader(bounds),
        child: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
        ),
      ),
      actions: [
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.red[400]!.withOpacity(0.3),
                  Colors.red[600]!.withOpacity(0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red[400]!.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${alerts.length}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => _showAlertsDialog(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedWelcomeCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[700]!.withOpacity(0.9),
            Colors.green[500]!.withOpacity(0.8),
            Colors.green[800]!.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green[400]!.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated background pattern
            ...List.generate(3, (index) => _buildFloatingIcon(index)),
            
            // Content
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Good Morning, Farmer!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your farm is thriving today",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.wb_sunny, color: Colors.yellow[300], size: 32),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Perfect for farming",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingIcon(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final progress = (_animationController.value + index * 0.3) % 1.0;
        return Positioned(
          right: 20 + (index * 40) - (progress * 20),
          top: 20 + (index * 30) + (progress * 10),
          child: Opacity(
            opacity: 0.1 + (progress * 0.2),
            child: Icon(
              [Icons.eco, Icons.water_drop, Icons.wb_sunny][index],
              size: 40 + (index * 10),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNeuomorphicStatsGrid() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildNeuomorphicStatCard("Predicted Yield", predictedYield, Icons.grain, Colors.green, 0),
            _buildNeuomorphicStatCard("Health Status", "Excellent", Icons.eco, Colors.blue, 1),
            _buildNeuomorphicStatCard("Efficiency", "94%", Icons.trending_up, Colors.orange, 2),
            _buildNeuomorphicStatCard("Revenue", "₹45K", Icons.attach_money, Colors.purple, 3),
          ],
        );
      },
    );
  }

  Widget _buildNeuomorphicStatCard(String title, String value, IconData icon, Color color, int index) {
    final delay = index * 0.2;
    final cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsController,
      curve: Interval(delay, 1.0, curve: Curves.elasticOut),
    ));

    return AnimatedBuilder(
      animation: cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: cardAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                // Neumorphic shadows
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(8, 8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Colors.grey[800]!.withOpacity(0.1),
                  offset: Offset(-8, -8),
                  blurRadius: 16,
                ),
                // Inner glow
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildGlassActionButton(action, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlassActionButton(Map<String, dynamic> action, int index) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: action['color'].withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          action['icon'],
                          color: action['color'],
                          size: 24,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        action['title'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressCard() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green[400], size: 24),
              SizedBox(width: 12),
              Text(
                "Crop Growth Progress",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: _statsAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: cropProgress * _statsAnimation.value,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green[400]!),
                    minHeight: 8,
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(cropProgress * _statsAnimation.value * 100).toInt()}% Complete",
                        style: TextStyle(
                          color: Colors.green[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Expected harvest: 15 days",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumActivityFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Activity",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _buildActivityItem("Irrigation completed", "2 hours ago", Icons.check_circle, Colors.green),
        _buildActivityItem("Weather update received", "4 hours ago", Icons.cloud, Colors.blue),
        _buildActivityItem("Fertilizer applied to Section A", "1 day ago", Icons.eco, Colors.orange),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Active Alerts", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: alerts.map((alert) => ListTile(
            leading: Icon(alert['icon'], color: _getAlertColor(alert['severity'])),
            title: Text(alert['title'], style: TextStyle(color: Colors.white)),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.green[400])),
          ),
        ],
      ),
    );
  }

  Color _getAlertColor(String severity) {
    switch (severity) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.yellow;
      default: return Colors.grey;
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Refresh data here
    });
  }
}

