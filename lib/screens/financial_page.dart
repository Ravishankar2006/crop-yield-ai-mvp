import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _cardController;
  late AnimationController _statsController;
  late AnimationController _floatingController;
  
  late Animation<double> _cardAnimation;
  late Animation<double> _statsAnimation;
  late Animation<double> _floatingAnimation;

  // Sample financial data
  final Map<String, dynamic> financialSummary = {
    'totalIncome': 45000,
    'totalExpenses': 32000,
    'netProfit': 13000,
    'availableCredit': 25000,
    'monthlyGrowth': 8.5,
  };

  final List<Map<String, dynamic>> loans = [
    {
      'lender': 'Agriculture Bank',
      'amount': 50000,
      'remainingAmount': 20000,
      'interestRate': 8.5,
      'dueDate': '2025-12-31',
      'monthlyPayment': 3500,
      'status': 'Active',
    },
    {
      'lender': 'Cooperative Society',
      'amount': 25000,
      'remainingAmount': 0,
      'interestRate': 6.0,
      'dueDate': '2024-08-15',
      'monthlyPayment': 0,
      'status': 'Paid',
    },
  ];

  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'Income',
      'description': 'Wheat harvest sale',
      'amount': 18000,
      'date': '2025-09-20',
      'category': 'Crop Sales',
    },
    {
      'type': 'Expense',
      'description': 'NPK fertilizer purchase',
      'amount': 3500,
      'date': '2025-09-18',
      'category': 'Fertilizers',
    },
    {
      'type': 'Income',
      'description': 'Rice harvest advance',
      'amount': 12000,
      'date': '2025-09-15',
      'category': 'Advance Payments',
    },
    {
      'type': 'Expense',
      'description': 'Diesel for tractor',
      'amount': 2800,
      'date': '2025-09-14',
      'category': 'Fuel',
    },
  ];

  final List<Map<String, dynamic>> marketPrices = [
    {
      'crop': 'Wheat',
      'currentPrice': 2400,
      'lastWeekPrice': 2350,
      'trend': 'up',
      'bestMarket': 'Eshwar Bazaar',
      'recommendation': 'Sell this week',
      'detailedRecommendations': [
        'Prices trending upward - expected to reach ₹2,500/quintal by next week',
        'Demand is high due to festival season approaching',
        'Transportation costs lowest on Tuesday and Wednesday',
        'Consider selling 70% now and hold 30% for potential price increase',
        'Quality premium of ₹100/quintal available for Grade A wheat',
        'Avoid selling on Monday due to low trader presence at Eshwar Bazaar',
      ],
      'marketTiming': 'Best selling hours: 9 AM - 12 PM',
      'weatherImpact': 'Rain expected next week may increase prices further',
      'competitorAnalysis': 'Local farmers selling at ₹2,380/quintal average',
    },
    {
      'crop': 'Rice',
      'currentPrice': 2100,
      'lastWeekPrice': 2180,
      'trend': 'down',
      'bestMarket': 'Local Farmers Market',
      'recommendation': 'Wait for better rates',
      'detailedRecommendations': [
        'Temporary price dip due to oversupply from neighboring districts',
        'Government procurement expected to start in 2 weeks at ₹2,250/quintal',
        'Export demand picking up - prices may recover by month-end',
        'Store properly with moisture content below 14% to maintain quality',
        'Consider direct selling to rice mills for better margins',
        'Basmati variety fetching ₹400 premium over regular rice',
      ],
      'marketTiming': 'Wait 10-15 days for price recovery',
      'weatherImpact': 'Dry weather will help maintain grain quality',
      'competitorAnalysis': 'Mills offering ₹2,150/quintal for bulk quantities',
    },
    {
      'crop': 'Corn',
      'currentPrice': 1800,
      'lastWeekPrice': 1750,
      'trend': 'up',
      'bestMarket': 'City Wholesale Market',
      'recommendation': 'Good time to sell',
      'detailedRecommendations': [
        'Poultry industry demand surge driving price increase',
        'Ethanol production units actively purchasing at premium rates',
        'Limited supply from major producing states pushing prices up',
        'Yellow corn variety in higher demand than white corn',
        'Early morning sales (6-8 AM) typically fetch better prices',
        'Consider contract farming for next season with current buyers',
      ],
      'marketTiming': 'Sell within next 3-5 days for optimal returns',
      'weatherImpact': 'Favorable weather supporting consistent supply',
      'competitorAnalysis': 'Traders paying up to ₹1,850/quintal for quality grain',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _statsController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );
    
    _statsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.easeOutBack),
    );
    
    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.linear),
    );

    _cardController.forward();
    _statsController.forward();
    _floatingController.repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cardController.dispose();
    _statsController.dispose();
    _floatingController.dispose();
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
              Colors.green[900]?.withValues(alpha: 0.1) ?? Colors.black,
              Colors.black,
              Colors.blue[900]?.withValues(alpha: 0.05) ?? Colors.black,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating background elements
            ...List.generate(5, (index) => _buildFloatingElement(index)),
            
            // Main content
            TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildLoansTab(),
                _buildTransactionsTab(),
                _buildMarketTab(),
              ],
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
          colors: [Colors.white, Colors.green[300] ?? Colors.green],
        ).createShader(bounds),
        child: Text(
          'Financials',
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
                  color: Colors.green[400]?.withValues(alpha: 0.15) ?? Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green[400]?.withValues(alpha: 0.3) ?? Colors.green.withValues(alpha: 0.3)),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(Icons.add, color: Colors.green[400] ?? Colors.green),
                  onPressed: _addTransaction,
                ),
              ),
            ),
          ),
        ),
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
                      colors: [Colors.green[400] ?? Colors.green, Colors.blue[500] ?? Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(icon: Icon(Icons.dashboard, size: 16), text: 'Overview'),
                    Tab(icon: Icon(Icons.account_balance, size: 16), text: 'Loans'),
                    Tab(icon: Icon(Icons.receipt_long, size: 16), text: 'History'),
                    Tab(icon: Icon(Icons.store, size: 16), text: 'Market'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        final progress = (_floatingAnimation.value + index * 0.2) % 1.0;
        final size = 10.0 + (index * 3);
        // Fixed: Removed Colors.emerald and used valid colors
        final colors = [Colors.green, Colors.blue, Colors.teal, Colors.cyan, Colors.indigo];
        
        return Positioned(
          left: (MediaQuery.of(context).size.width * progress) - size/2,
          top: 100 + (index * 120) + (math.sin(progress * 3 * math.pi) * 50),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors[index].withValues(alpha: 0.3),
                  colors[index].withValues(alpha: 0.1),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[index].withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          
          // Financial Summary Cards
          _buildAnimatedStatsGrid(),
          
          SizedBox(height: 24),
          Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 12),
          
          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Add Income',
                  Icons.add_circle,
                  [Colors.green[400] ?? Colors.green, Colors.green[600] ?? Colors.green],
                  () => _addTransaction(type: 'Income'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'Add Expense',
                  Icons.remove_circle,
                  [Colors.red[400] ?? Colors.red, Colors.red[600] ?? Colors.red],
                  () => _addTransaction(type: 'Expense'),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 12),
          
          // Recent Transactions
          ...transactions.take(3).map((transaction) => _buildTransactionCard(transaction)),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatsGrid() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatsCard('Total Income', '₹${financialSummary['totalIncome']}', Icons.trending_up, Colors.green, 0),
            _buildStatsCard('Total Expenses', '₹${financialSummary['totalExpenses']}', Icons.trending_down, Colors.red, 1),
            _buildStatsCard('Net Profit', '₹${financialSummary['netProfit']}', Icons.account_balance_wallet, Colors.blue, 2),
            _buildStatsCard('Growth', '${financialSummary['monthlyGrowth']}%', Icons.show_chart, Colors.purple, 3),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color, int index) {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        final delay = index * 0.2;
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _statsController,
            curve: Interval(delay, 1.0, curve: Curves.elasticOut),
          ),
        );
        
        return Transform.scale(
          scale: animation.value,
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
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
                        ),
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
                            color: Colors.grey[300],
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
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String label, IconData icon, List<Color> gradientColors, VoidCallback onPressed) {
    return SizedBox(
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
              border: Border.all(color: gradientColors[0].withValues(alpha: 0.3)),
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
    );
  }

  Widget _buildLoansTab() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      children: [
        Text('Loan Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 16),
        
        // Loan Summary Card
        _buildLoanSummaryCard(),
        SizedBox(height: 20),
        
        // Individual Loan Cards
        ...loans.map((loan) => _buildLoanCard(loan)),
      ],
    );
  }

  Widget _buildLoanSummaryCard() {
    return Container(
      constraints: BoxConstraints(minHeight: 120),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[700]?.withValues(alpha: 0.8) ?? Colors.blue.withValues(alpha: 0.8),
                  Colors.blue[500]?.withValues(alpha: 0.6) ?? Colors.blue.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[400]?.withValues(alpha: 0.3) ?? Colors.blue.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue[400]?.withValues(alpha: 0.3) ?? Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Outstanding', style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 4),
                Text('₹20,000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Flexible(
                  child: Text('Next Payment: ₹3,500 due in 5 days', 
                    style: TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    bool isPaid = loan['status'] == 'Paid';
    Color statusColor = isPaid ? Colors.green : Colors.orange;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      statusColor.withValues(alpha: 0.3),
                      statusColor.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPaid ? Icons.check_circle : Icons.account_balance,
                  color: statusColor,
                ),
              ),
              title: Text(loan['lender'] ?? 'Unknown Lender', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Container(
                constraints: BoxConstraints(minHeight: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text('Remaining: ₹${loan['remainingAmount'] ?? 0}', 
                      style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: loan['amount'] != null && loan['amount'] > 0 
                          ? (1 - ((loan['remainingAmount'] ?? 0) / loan['amount'])).toDouble() 
                          : 0.0,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildLoanDetailRow('Original Amount', '₹${loan['amount'] ?? 0}'),
                      _buildLoanDetailRow('Interest Rate', '${loan['interestRate'] ?? 0}%'),
                      _buildLoanDetailRow('Due Date', loan['dueDate'] ?? 'N/A'),
                      _buildLoanDetailRow('Monthly Payment', '₹${loan['monthlyPayment'] ?? 0}'),
                      _buildLoanDetailRow('Status', loan['status'] ?? 'Unknown'),
                      SizedBox(height: 16),
                      if (!isPaid)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _makePayment(loan),
                            child: Text('Make Payment', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          hintStyle: TextStyle(color: Colors.white60),
                          prefixIcon: Icon(Icons.search, color: Colors.white60),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[400]?.withValues(alpha: 0.2) ?? Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[400]?.withValues(alpha: 0.3) ?? Colors.blue.withValues(alpha: 0.3)),
                ),
                child: IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.blue[400] ?? Colors.blue),
                  onPressed: _showFilterDialog,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: transactions.length,
            itemBuilder: (context, index) => _buildTransactionCard(transactions[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    bool isIncome = transaction['type'] == 'Income';
    Color transactionColor = isIncome ? Colors.green : Colors.red;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      transactionColor.withValues(alpha: 0.3),
                      transactionColor.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                  color: transactionColor,
                ),
              ),
              title: Text(transaction['description'] ?? 'No description', style: TextStyle(color: Colors.white)),
              subtitle: Text('${transaction['category'] ?? 'Uncategorized'} • ${_formatDate(transaction['date'] ?? '')}', 
                style: TextStyle(color: Colors.white60)),
              trailing: Text(
                '${isIncome ? '+' : '-'}₹${transaction['amount'] ?? 0}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transactionColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarketTab() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      children: [
        Text('Market Prices & Smart Recommendations', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 16),
        
        ...marketPrices.map((price) => _buildEnhancedMarketCard(price)),
      ],
    );
  }

  Widget _buildEnhancedMarketCard(Map<String, dynamic> market) {
    bool isUp = market['trend'] == 'up';
    Color trendColor = isUp ? Colors.green : Colors.red;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
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
              border: Border.all(color: trendColor.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: trendColor.withValues(alpha: 0.2),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ExpansionTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [trendColor.withValues(alpha: 0.3), trendColor.withValues(alpha: 0.1)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: trendColor,
                ),
              ),
              title: Text(market['crop'] ?? 'Unknown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₹${market['currentPrice'] ?? 0}/quintal', 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: trendColor)),
                  SizedBox(height: 4),
                  Text(market['recommendation'] ?? 'No recommendation', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                ],
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('Current', '₹${market['currentPrice'] ?? 0}'),
                            _buildStatColumn('Last Week', '₹${market['lastWeekPrice'] ?? 0}'),
                            _buildStatColumn('Change', 
                              '${isUp ? '+' : ''}₹${((market['currentPrice'] ?? 0) - (market['lastWeekPrice'] ?? 0)).abs()}', 
                              color: trendColor),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Market Info
                      _buildMarketDetailRow('Best Market', market['bestMarket'] ?? 'N/A', Icons.location_on),
                      _buildMarketDetailRow('Optimal Timing', market['marketTiming'] ?? 'N/A', Icons.schedule),
                      _buildMarketDetailRow('Weather Impact', market['weatherImpact'] ?? 'N/A', Icons.cloud),
                      _buildMarketDetailRow('Competition', market['competitorAnalysis'] ?? 'N/A', Icons.trending_up),
                      
                      SizedBox(height: 16),
                      
                      // Detailed Recommendations
                      Text('Smart Recommendations:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: trendColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: trendColor.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lightbulb, color: trendColor, size: 20),
                                SizedBox(width: 8),
                                Text('Action Plan:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                            SizedBox(height: 12),
                            
                            ...(market['detailedRecommendations'] as List<dynamic>? ?? []).map<Widget>((recommendation) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.check_circle, color: trendColor, size: 16),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        recommendation?.toString() ?? '',
                                        style: TextStyle(fontSize: 14, height: 1.4, color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.phone),
                              label: Text('Contact Buyer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _contactBuyer(market),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.notifications),
                              label: Text('Price Alert'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: trendColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => _setPriceAlert(market),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.white)),
      ],
    );
  }

  Widget _buildMarketDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[400]),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white70)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: Colors.white))),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  void _addTransaction({String? type}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add ${type ?? 'Transaction'}', style: TextStyle(color: Colors.white)),
        content: Text('Add transaction dialog implementation', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: Colors.grey[400]))),
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Add', style: TextStyle(color: Colors.green[400]))),
        ],
      ),
    );
  }

  void _makePayment(Map<String, dynamic> loan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment functionality coming soon!'),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Filter Transactions', style: TextStyle(color: Colors.white)),
        content: Text('Filter options implementation', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Apply', style: TextStyle(color: Colors.blue[400]))),
        ],
      ),
    );
  }

  void _contactBuyer(Map<String, dynamic> market) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting buyers for ${market['crop']}...'),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _setPriceAlert(Map<String, dynamic> market) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Price alert set for ${market['crop']}!'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
