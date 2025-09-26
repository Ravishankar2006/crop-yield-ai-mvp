import 'package:flutter/material.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({Key? key}) : super(key: key);

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> with TickerProviderStateMixin {
  late TabController _tabController;

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
    },
    {
      'crop': 'Rice',
      'currentPrice': 2100,
      'lastWeekPrice': 2180,
      'trend': 'down',
      'bestMarket': 'Local Farmers Market',
      'recommendation': 'Wait for better rates',
    },
    {
      'crop': 'Corn',
      'currentPrice': 1800,
      'lastWeekPrice': 1750,
      'trend': 'up',
      'bestMarket': 'City Wholesale Market',
      'recommendation': 'Good time to sell',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Financials',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.account_balance), text: 'Loans'),
            Tab(icon: Icon(Icons.receipt_long), text: 'History'),
            Tab(icon: Icon(Icons.store), text: 'Market'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
            Colors.black,
            Colors.grey[900]!,
        ],
      ),
    ),

        child: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildLoansTab(),
            _buildTransactionsTab(),
            _buildMarketTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Summary', 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 16),
          
          // Financial Summary Cards
          _buildStatsGrid(),
          
          SizedBox(height: 24),
          Text('Quick Actions', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 12),
          
          // Quick Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton('Add Income', Icons.add_circle, Colors.green, () {}),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildActionButton('Add Expense', Icons.remove_circle, Colors.red, () {}),
              ),
            ],
          ),
          
          SizedBox(height: 24),
          Text('Recent Activity', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 12),
          
          // Recent Transactions
          ...transactions.take(3).map((transaction) => _buildTransactionCard(transaction)).toList(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatsCard('Total Income', '₹${financialSummary['totalIncome']}', Icons.trending_up, Colors.green),
        _buildStatsCard('Total Expenses', '₹${financialSummary['totalExpenses']}', Icons.trending_down, Colors.red),
        _buildStatsCard('Net Profit', '₹${financialSummary['netProfit']}', Icons.account_balance_wallet, Colors.blue),
        _buildStatsCard('Growth', '${financialSummary['monthlyGrowth']}%', Icons.show_chart, Colors.purple),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildLoansTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Loan Management', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 16),
        
        // Loan Summary Card
        Card(
          color: Colors.blue[700],
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Outstanding', style: TextStyle(color: Colors.white70)),
                Text('₹20,000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Next Payment: ₹3,500 due in 5 days', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        
        // Individual Loan Cards
        ...loans.map((loan) => _buildLoanCard(loan)).toList(),
      ],
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    bool isPaid = loan['status'] == 'Paid';
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(
          isPaid ? Icons.check_circle : Icons.account_balance,
          color: isPaid ? Colors.green : Colors.orange,
        ),
        title: Text(loan['lender'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining: ₹${loan['remainingAmount']}', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: (1 - (loan['remainingAmount'] / loan['amount'])).toDouble(),
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(isPaid ? Colors.green : Colors.blue),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLoanDetailRow('Original Amount', '₹${loan['amount']}'),
                _buildLoanDetailRow('Interest Rate', '${loan['interestRate']}%'),
                _buildLoanDetailRow('Due Date', loan['dueDate']),
                _buildLoanDetailRow('Monthly Payment', '₹${loan['monthlyPayment']}'),
                _buildLoanDetailRow('Status', loan['status']),
                SizedBox(height: 16),
                if (!isPaid)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text('Make Payment'),
                  ),
              ],
            ),
          ),
        ],
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
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search transactions...',
              hintStyle: TextStyle(color: Colors.white60),
              prefixIcon: Icon(Icons.search, color: Colors.white60),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
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
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isIncome ? Colors.green : Colors.red,
          child: Icon(
            isIncome ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(transaction['description'], style: TextStyle(color: Colors.white)),
        subtitle: Text('${transaction['category']} • ${transaction['date']}', 
          style: TextStyle(color: Colors.white60)),
        trailing: Text(
          '${isIncome ? '+' : '-'}₹${transaction['amount']}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMarketTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Market Prices', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 16),
        
        ...marketPrices.map((market) => _buildMarketCard(market)).toList(),
      ],
    );
  }

  Widget _buildMarketCard(Map<String, dynamic> market) {
    bool isUp = market['trend'] == 'up';
    Color trendColor = isUp ? Colors.green : Colors.red;
    
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(market['crop'], 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Icon(
                  isUp ? Icons.trending_up : Icons.trending_down,
                  color: trendColor,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('₹${market['currentPrice']}/quintal', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: trendColor)),
            Text('Last week: ₹${market['lastWeekPrice']}/quintal', 
              style: TextStyle(color: Colors.white70)),
            SizedBox(height: 12),
            Text('Best Market: ${market['bestMarket']}', 
              style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: trendColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: trendColor, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(market['recommendation'], 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Text('Contact Buyer'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: trendColor),
                    child: Text('Price Alert'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

