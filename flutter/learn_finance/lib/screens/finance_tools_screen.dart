import 'dart:math';
import 'package:flutter/material.dart';

class FinanceToolsScreen extends StatefulWidget {
  const FinanceToolsScreen({super.key});

  @override
  State<FinanceToolsScreen> createState() => _FinanceToolsScreenState();
}

class _FinanceToolsScreenState extends State<FinanceToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Compound Interest Controllers
  final _initialCapitalController = TextEditingController(text: '10000');
  final _monthlyContribController = TextEditingController(text: '500');
  final _annualReturnController = TextEditingController(text: '8.5');
  final _yearsController = TextEditingController(text: '20');
  double _compoundTotal = 0;
  double _totalContributions = 0;
  double _totalInterest = 0;

  // DCF Calculator Controllers
  final _fcfController = TextEditingController(text: '1000'); // Millions
  final _growthRateController = TextEditingController(text: '10'); // % FCF growth
  final _waccController = TextEditingController(text: '9.0'); // % discount rate
  final _terminalGrowthController = TextEditingController(text: '2.5'); // % perpetual growth
  final _sharesController = TextEditingController(text: '100'); // Millions of shares
  double _intrinsicValuePerShare = 0;

  // FIRE Calculator Controllers
  final _annualExpensesController = TextEditingController(text: '48000');
  final _currentNetWorthController = TextEditingController(text: '50000');
  final _annualSavingsController = TextEditingController(text: '18000');
  final _fireReturnController = TextEditingController(text: '7.0');
  double _fireNumber = 0;
  double _yearsToFire = 0;

  // Rule of 72 Controller
  final _rule72ReturnController = TextEditingController(text: '8.0');
  double _yearsToDouble = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _calculateCompound();
    _calculateDCF();
    _calculateFIRE();
    _calculateRule72();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _initialCapitalController.dispose();
    _monthlyContribController.dispose();
    _annualReturnController.dispose();
    _yearsController.dispose();
    _fcfController.dispose();
    _growthRateController.dispose();
    _waccController.dispose();
    _terminalGrowthController.dispose();
    _sharesController.dispose();
    _annualExpensesController.dispose();
    _currentNetWorthController.dispose();
    _annualSavingsController.dispose();
    _fireReturnController.dispose();
    _rule72ReturnController.dispose();
    super.dispose();
  }

  void _calculateCompound() {
    final double p = double.tryParse(_initialCapitalController.text) ?? 0;
    final double pmt = double.tryParse(_monthlyContribController.text) ?? 0;
    final double r = (double.tryParse(_annualReturnController.text) ?? 0) / 100;
    final double t = double.tryParse(_yearsController.text) ?? 0;

    if (t <= 0) return;

    double total = p * pow(1 + r / 12, 12 * t);
    double contrib = p + (pmt * 12 * t);

    for (int month = 1; month <= 12 * t; month++) {
      total += pmt * pow(1 + r / 12, (12 * t) - month);
    }

    setState(() {
      _compoundTotal = total;
      _totalContributions = contrib;
      _totalInterest = max(0, total - contrib);
    });
  }

  void _calculateDCF() {
    final double fcf = double.tryParse(_fcfController.text) ?? 0;
    final double g = (double.tryParse(_growthRateController.text) ?? 0) / 100;
    final double wacc = (double.tryParse(_waccController.text) ?? 0) / 100;
    final double gTerm = (double.tryParse(_terminalGrowthController.text) ?? 0) / 100;
    final double shares = double.tryParse(_sharesController.text) ?? 1;

    if (wacc <= gTerm || shares <= 0) return;

    double pvFCF = 0;
    double currentFCF = fcf;

    // 5-year projection
    for (int year = 1; year <= 5; year++) {
      currentFCF *= (1 + g);
      pvFCF += currentFCF / pow(1 + wacc, year);
    }

    // Terminal value
    double terminalValue = (currentFCF * (1 + gTerm)) / (wacc - gTerm);
    double pvTerminal = terminalValue / pow(1 + wacc, 5);

    double totalEquityValue = pvFCF + pvTerminal;

    setState(() {
      _intrinsicValuePerShare = totalEquityValue / shares;
    });
  }

  void _calculateFIRE() {
    final double expenses = double.tryParse(_annualExpensesController.text) ?? 0;
    final double netWorth = double.tryParse(_currentNetWorthController.text) ?? 0;
    final double annualSavings = double.tryParse(_annualSavingsController.text) ?? 0;
    final double r = (double.tryParse(_fireReturnController.text) ?? 0) / 100;

    double fireTarget = expenses * 25; // 4% rule
    double remaining = fireTarget - netWorth;

    double years = 0;
    if (remaining > 0 && annualSavings > 0) {
      double current = netWorth;
      while (current < fireTarget && years < 100) {
        current = (current + annualSavings) * (1 + r);
        years++;
      }
    }

    setState(() {
      _fireNumber = fireTarget;
      _yearsToFire = years;
    });
  }

  void _calculateRule72() {
    final double r = double.tryParse(_rule72ReturnController.text) ?? 0;
    if (r <= 0) return;
    setState(() {
      _yearsToDouble = 72 / r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.calculate_rounded, color: Color(0xFF10B981)),
            SizedBox(width: 10),
            Text(
              'Interactive Finance Tools',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF10B981),
          indicatorWeight: 3,
          labelColor: const Color(0xFF10B981),
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(text: 'Compound'),
            Tab(text: 'DCF Value'),
            Tab(text: 'FIRE Math'),
            Tab(text: 'Rule of 72'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCompoundTab(),
          _buildDCFTab(),
          _buildFIRETab(),
          _buildRule72Tab(),
        ],
      ),
    );
  }

  Widget _buildCompoundTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Compound Wealth Simulator', 'Visualize exponential growth over time with monthly investments.', Icons.trending_up_rounded, const Color(0xFF10B981)),
          const SizedBox(height: 20),
          _buildInputField('Initial Capital (\$)', _initialCapitalController, _calculateCompound),
          _buildInputField('Monthly Contribution (\$)', _monthlyContribController, _calculateCompound),
          _buildInputField('Annual Expected Return (%)', _annualReturnController, _calculateCompound),
          _buildInputField('Time Horizon (Years)', _yearsController, _calculateCompound),
          const SizedBox(height: 24),
          _buildResultDisplay(
            title: 'Future Portfolio Value',
            mainValue: '\$${_compoundTotal.toStringAsFixed(0)}',
            subtitle: 'Principal: \$${_totalContributions.toStringAsFixed(0)}  |  Compound Interest: \$${_totalInterest.toStringAsFixed(0)}',
            accentColor: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildDCFTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('DCF Stock Intrinsic Value Calculator', 'Estimate fair value per share based on Free Cash Flow projections.', Icons.analytics_rounded, Colors.blue),
          const SizedBox(height: 20),
          _buildInputField('Current Free Cash Flow (\$ Millions)', _fcfController, _calculateDCF),
          _buildInputField('5-Yr FCF Growth Rate (%)', _growthRateController, _calculateDCF),
          _buildInputField('Discount Rate / WACC (%)', _waccController, _calculateDCF),
          _buildInputField('Terminal Growth Rate (%)', _terminalGrowthController, _calculateDCF),
          _buildInputField('Shares Outstanding (Millions)', _sharesController, _calculateDCF),
          const SizedBox(height: 24),
          _buildResultDisplay(
            title: 'Intrinsic Fair Value Per Share',
            mainValue: '\$${_intrinsicValuePerShare.toStringAsFixed(2)}',
            subtitle: 'Margin of Safety Buy Target (20% Off): \$${(_intrinsicValuePerShare * 0.8).toStringAsFixed(2)}',
            accentColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildFIRETab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('FIRE Freedom Calculator', 'Calculate your Financial Independence number and years to retirement.', Icons.local_fire_department_rounded, Colors.orange),
          const SizedBox(height: 20),
          _buildInputField('Annual Living Expenses (\$)', _annualExpensesController, _calculateFIRE),
          _buildInputField('Current Net Worth (\$)', _currentNetWorthController, _calculateFIRE),
          _buildInputField('Annual Capital Savings (\$)', _annualSavingsController, _calculateFIRE),
          _buildInputField('Real Investment Return (%)', _fireReturnController, _calculateFIRE),
          const SizedBox(height: 24),
          _buildResultDisplay(
            title: 'Target FIRE Nest Egg (4% Rule)',
            mainValue: '\$${_fireNumber.toStringAsFixed(0)}',
            subtitle: 'Estimated Years to Financial Freedom: ${_yearsToFire.toStringAsFixed(1)} Years',
            accentColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildRule72Tab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardHeader('Rule of 72 Doubling Time', 'Fast mental math formula to estimate years required to double your investment.', Icons.bolt_rounded, Colors.purple),
          const SizedBox(height: 20),
          _buildInputField('Annual Interest / Compound Return (%)', _rule72ReturnController, _calculateRule72),
          const SizedBox(height: 24),
          _buildResultDisplay(
            title: 'Years to Double Portfolio',
            mainValue: '${_yearsToDouble.toStringAsFixed(1)} Years',
            subtitle: 'At ${_rule72ReturnController.text}% annual return, \$10,000 becomes \$20,000 in ${_yearsToDouble.toStringAsFixed(1)} years.',
            accentColor: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildCardHeader(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, VoidCallback onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF10B981)),
          ),
        ),
      ),
    );
  }

  Widget _buildResultDisplay({
    required String title,
    required String mainValue,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.2),
            const Color(0xFF1E293B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(mainValue, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: accentColor, letterSpacing: -0.5)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4)),
        ],
      ),
    );
  }
}
