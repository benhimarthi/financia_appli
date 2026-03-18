/*import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/finances/presentation/widgets/financial_goals_card.dart';
import 'package:myapp/features/finances/presentation/widgets/income_expenses_chart.dart';
import 'package:myapp/features/finances/presentation/widgets/spending_breakdown_card.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 1100,
      child: Column(
        children: [
          Expanded(
            child: Column(
              //padding: const EdgeInsets.all(16.0),
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Personal Finances".tr(),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start
                ),
                Text("Track your income, expenses & goals"),
                const SizedBox(height: 24.0),
                IncomeExpensesChart(),
                const SizedBox(height: 24.0),
                SpendingBreakdownCard(),
                const SizedBox(height: 24.0),
                FinancialGoalsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/finances/presentation/widgets/financial_goals_card.dart';
import 'package:myapp/features/finances/presentation/widgets/income_expenses_chart.dart';
import 'package:myapp/features/finances/presentation/widgets/spending_breakdown_card.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animations for each major section
  late Animation<double> _fadeTitle;
  late Animation<double> _scaleTitle;

  late Animation<double> _fadeChart;
  late Animation<double> _scaleChart;

  late Animation<double> _fadeBreakdown;
  late Animation<double> _scaleBreakdown;

  late Animation<double> _fadeGoals;
  late Animation<double> _scaleGoals;

  // Simple fake loading state (replace with real Bloc/ cubit logic later)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Staggered animations
    _fadeTitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOutCubicEmphasized),
      ),
    );
    _scaleTitle = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    _fadeChart = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _scaleChart = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _fadeBreakdown = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.85, curve: Curves.easeInOutCubicEmphasized),
      ),
    );
    _scaleBreakdown = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 0.85, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    _fadeGoals = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _scaleGoals = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Simulate data loading (remove or replace with real logic)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection({
    required Animation<double> fade,
    required Animation<double> scale,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: scale,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      // Removed fixed height=1100 → let it be flexible
      // If you really need fixed height, keep it, but consider SingleChildScrollView
      child: _isLoading
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Loading your finances..."),
          ],
        ),
      )
          : SingleChildScrollView(
        // ← added so content isn't cut off on smaller screens
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedSection(
              fade: _fadeTitle,
              scale: _scaleTitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Personal Finances".tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text("Track your income, expenses & goals".tr()),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),

            _buildAnimatedSection(
              fade: _fadeChart,
              scale: _scaleChart,
              child: const IncomeExpensesChart(),
            ),

            const SizedBox(height: 24.0),

            _buildAnimatedSection(
              fade: _fadeBreakdown,
              scale: _scaleBreakdown,
              child: const SpendingBreakdownCard(),
            ),

            const SizedBox(height: 24.0),

            _buildAnimatedSection(
              fade: _fadeGoals,
              scale: _scaleGoals,
              child: const FinancialGoalsCard(),
            ),

            const SizedBox(height: 32.0), // breathing room at bottom
          ],
        ),
      ),
    );
  }
}