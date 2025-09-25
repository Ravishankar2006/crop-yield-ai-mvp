import 'package:flutter/material.dart';
import 'dart:ui';

class CropInsightsPage extends StatefulWidget {
  const CropInsightsPage({super.key});

  @override
  State<CropInsightsPage> createState() => _CropInsightsPageState();
}

class _CropInsightsPageState extends State<CropInsightsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _cardController;
  late AnimationController _chartController;
  late AnimationController _progressController;
  
  late Animation<double> _cardAnimation;
  late Animation<double> _chartAnimation;
  late Animation<double> _progressAnimation;

  String _selectedFilter = 'All';
  bool _isCompareMode = false;
  final Set<String> _selectedCrops = {};

  final List<Map<String, dynamic>> crops = [
    {
      'name': 'Rice',
      'yield': '19 quintals',
      'status': 'Healthy',
      'progress': 0.75,
      'fertilizerAdvice': 'Apply NPK in 3 days',
      'waterStatus': 'Adequate',
      'plantingDate': '2024-01-15',
      'harvestDate': '2024-05-20',
      'diseaseRisk': 'Low',
      'marketPrice': '₹2,400/quintal',
      'profitMargin': '+15%',
      'weatherRisk': 'Moderate',
      'soilHealth': 85,
      'detailedRecommendations': [
        'Apply 25kg NPK fertilizer per acre on Friday morning',
        'Increase irrigation frequency from 3 to 4 days due to rising temperatures',
        'Scout for brown plant hopper in lower leaves next week',
        'Consider applying potassium sulfate after 10 days for better grain filling',
        'Monitor weather forecast - rain expected next Tuesday may delay fertilizer application',
      ],
    },
    {
      'name': 'Wheat',
      'yield': '24 quintals',
      'status': 'Excellent',
      'progress': 0.85,
      'fertilizerAdvice': 'Apply Urea this week',
      'waterStatus': 'Sufficient',
      'plantingDate': '2024-02-01',
      'harvestDate': '2024-06-15',
      'diseaseRisk': 'Very Low',
      'marketPrice': '₹2,100/quintal',
      'profitMargin': '+20%',
      'weatherRisk': 'Low',
      'soilHealth': 92,
      'detailedRecommendations': [
        'Apply 30kg Urea fertilizer per acre within 2 days for optimal grain development',
        'Reduce irrigation to twice weekly as soil moisture is excellent',
        'Harvest timing is perfect - maintain current care routine',
        'Apply fungicide spray this weekend as preventive measure for rust',
        'Start arranging harvesting equipment - ready in 3-4 weeks',
      ],
    },
    {
      'name': 'Corn',
      'yield': '15 quintals',
      'status': 'Needs Attention',
      'progress': 0.60,
      'fertilizerAdvice': 'Apply Potash next week',
      'waterStatus': 'Monitor soil moisture',
      'plantingDate': '2024-01-20',
      'harvestDate': '2024-06-01',
      'diseaseRisk': 'Medium',
      'marketPrice': '₹1,800/quintal',
      'profitMargin': '+8%',
      'weatherRisk': 'High',
      'soilHealth': 70,
      'detailedRecommendations': [
        'URGENT: Apply 20kg Potash fertilizer immediately to boost yield potential',
        'Install drip irrigation in sections showing water stress symptoms',
        'Inspect plants for corn borer damage - treat with approved insecticide if found',
        'Consider side-dressing with nitrogen if leaf yellowing continues',
        'Monitor closely for next 2 weeks - yield prediction may improve with proper care',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _chartController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutBack),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _cardController.forward();
    _chartController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardController.dispose();
    _chartController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildGlassmorphicAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[900]!.withValues(alpha: 0.1),
              Colors.black,
              Colors.green[800]!.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildAnalyticsTab(),
          ],
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
          'Crop Insights',
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
        _buildCompactActionButton(
          icon: _isCompareMode ? Icons.compare : Icons.compare_arrows,
          onPressed: () => setState(() => _isCompareMode = !_isCompareMode),
        ),
        _buildCompactFilterButton(),
        SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.dashboard, size: 18),
                          SizedBox(width: 6),
                          Text('Overview'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timeline, size: 18),
                          SizedBox(width: 6),
                          Text('Analytics'),
                        ],
                      ),
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

  Widget _buildCompactActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      margin: EdgeInsets.only(right: 6),
      width: 36,
      height: 36,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 18,
              icon: Icon(icon, color: Colors.white),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactFilterButton() {
    return Container(
      margin: EdgeInsets.only(right: 6),
      width: 36,
      height: 36,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.green[400]?.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green[400]?.withValues(alpha: 0.3) ?? Colors.transparent),
          ),
          child: Icon(Icons.filter_list, color: Colors.green[400], size: 18),
        ),
        onSelected: (value) => setState(() => _selectedFilter = value),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'All', child: Text('All Crops')),
          PopupMenuItem(value: 'Healthy', child: Text('Healthy Only')),
          PopupMenuItem(value: 'Attention', child: Text('Needs Attention')),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final filteredCrops = _selectedFilter == 'All'
        ? crops
        : crops.where((crop) {
            if (_selectedFilter == 'Healthy') return crop['status'] == 'Healthy' || crop['status'] == 'Excellent';
            if (_selectedFilter == 'Attention') return crop['status'] == 'Needs Attention';
            return true;
          }).toList();

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 24,
      ),
      itemCount: filteredCrops.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _cardAnimation,
          builder: (context, child) {
            final delay = index * 0.2;
            final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _cardController,
                curve: Interval(delay, 1.0, curve: Curves.elasticOut),
              ),
            );
            
            return Transform.translate(
              offset: Offset(0, 30 * (1 - animation.value)),
              child: Opacity(
                opacity: animation.value,
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: _buildMorphingCropCard(filteredCrops[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMorphingCropCard(Map<String, dynamic> crop) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor(crop['status']).withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ExpansionTile(
            leading: _isCompareMode
                ? Checkbox(
                    value: _selectedCrops.contains(crop['name']),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedCrops.add(crop['name']);
                        } else {
                          _selectedCrops.remove(crop['name']);
                        }
                      });
                    },
                  )
                : _buildGlowingAvatar(crop),
            title: Text(
              crop['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  'Predicted: ${crop['yield']}',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 12),
                _buildAnimatedProgressBar(crop),
                SizedBox(height: 8),
                _buildStatusChip(crop['status']),
              ],
            ),
            children: [
              _buildDetailedContent(crop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingAvatar(Map<String, dynamic> crop) {
    final statusColor = _getStatusColor(crop['status']);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            statusColor.withValues(alpha: 0.3),
            statusColor.withValues(alpha: 0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.2),
        child: Icon(Icons.eco, color: statusColor, size: 28),
      ),
    );
  }

  Widget _buildAnimatedProgressBar(Map<String, dynamic> crop) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [Colors.grey[800]!, Colors.grey[700]!],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: crop['progress'] * _progressAnimation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(crop['status'])),
                  minHeight: 8,
                ),
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(crop['progress'] * _progressAnimation.value * 100).toInt()}% Complete',
                  style: TextStyle(
                    color: _getStatusColor(crop['status']),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  crop['harvestDate'],
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDetailedContent(Map<String, dynamic> crop) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricsGrid(crop),
          SizedBox(height: 24),
          _buildRecommendationsSection(crop),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> crop) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildMetricCard('Market Price', crop['marketPrice'], Icons.attach_money, Colors.green),
        _buildMetricCard('Profit Margin', crop['profitMargin'], Icons.trending_up, Colors.blue),
        _buildMetricCard('Soil Health', '${crop['soilHealth']}%', Icons.landscape, Colors.orange),
        _buildMetricCard('Disease Risk', crop['diseaseRisk'], Icons.bug_report, Colors.red),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection(Map<String, dynamic> crop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.yellow[600], size: 20),
            SizedBox(width: 8),
            Text(
              'Smart Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getStatusColor(crop['status']).withValues(alpha: 0.1),
                _getStatusColor(crop['status']).withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(crop['status']).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: crop['detailedRecommendations'].asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final recommendation = entry.value;
              
              return AnimatedBuilder(
                animation: _cardAnimation,
                builder: (context, child) {
                  final delay = 0.5 + (index * 0.1);
                  final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _cardController,
                      curve: Interval(delay, 1.0, curve: Curves.easeOut),
                    ),
                  );
                  
                  return Opacity(
                    opacity: animation.value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - animation.value), 0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getStatusColor(crop['status']),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedYieldChart(),
          SizedBox(height: 24),
          _buildHealthOverview(),
        ],
      ),
    );
  }

  Widget _buildAnimatedYieldChart() {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yield Comparison',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: crops.asMap().entries.map((entry) {
                    final index = entry.key;
                    final crop = entry.value;
                    return _buildAnimatedYieldBar(crop, index);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedYieldBar(Map<String, dynamic> crop, int index) {
    final yieldValue = int.parse(crop['yield'].split(' ')[0]);
    final maxYield = 30;
    
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        final delay = index * 0.2;
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _chartController,
            curve: Interval(delay, 1.0, curve: Curves.elasticOut),
          ),
        );
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 60,
              height: 150 * (yieldValue / maxYield) * animation.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    _getStatusColor(crop['status']),
                    _getStatusColor(crop['status']).withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(crop['status']).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              crop['name'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            Text(
              '${yieldValue}q',
              style: TextStyle(
                color: _getStatusColor(crop['status']),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHealthOverview() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildHealthCard('Excellent', 1, Colors.green)),
              SizedBox(width: 12),
              Expanded(child: _buildHealthCard('Healthy', 1, Colors.blue)),
              SizedBox(width: 12),
              Expanded(child: _buildHealthCard('Attention', 1, Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, int count, Color color) {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _chartAnimation.value,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Colors.green[400]!;
      case 'healthy':
        return Colors.blue[400]!;
      case 'needs attention':
        return Colors.orange[400]!;
      case 'critical':
        return Colors.red[400]!;
      default:
        return Colors.grey[400]!;
    }
  }
}
