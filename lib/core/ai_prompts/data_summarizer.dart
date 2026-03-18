import 'package:myapp/features/transaction/domain/entities/income_tags.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';

import '../../features/transaction/domain/entities/expense_tags.dart';

class DataSummarizer {
  static String globalSummaryData(
      double monthlyIncome,
      double monthlyExpenses,
      Map<String, dynamic> expensesByCategory,
      Map<String, dynamic> savings,
      Map<String, dynamic> debts,){
    Map<String, dynamic> data = {
      'monthly_income' : monthlyIncome,
      'monthly_expenses': monthlyExpenses,
      "expenses_by_category": expensesByCategory,
      "savings": savings,
      "debts": debts,
    };
    return data.toString();
  }
  static String globalSummaryOutputModel(){
    Map<String, dynamic> data = {
      "insights": [
        {
          "title": "Reduce food spending",
          "description": "Food represents 42% of your expenses. Try reducing it by 20% to save 80 monthly.",
          "impact": "high"
        },
        {
          "title": "Control entertainment",
          "description": "Entertainment is 21% of expenses. Reducing by 50% frees 100 monthly.",
          "impact": "medium"
        },
        {
          "title": "Increase savings rate",
          "description": "Your savings rate is 20%. Aim for 30% by reducing discretionary spending.",
          "impact": "high"
        }
      ]
    };
    return data.toString();
  }
  static String forecastPromptData(
      double currentBalance,
      double avgDailySpending,
      double expectedIncome,
      double daysRemaining,
      ){
    Map<String, dynamic> data = {
      "current_balance": currentBalance,
      "avg_daily_spending": avgDailySpending,
      "expected_income": expectedIncome,
      "days_remaining": 10
    };
    return data.toString();
  }
  static String forecastOutputModel(){
    Map<String, dynamic> data = {
      "final_balance": 400,
      "risk_level": "low",
      "warnings": [
        "No risk of negative balance"
      ]
    };
    return data.toString();
  }
  static String adviceOnBuyPromptData(
      double currentBalance,
      double avgDailySpending,
      double price,
      double daysRemaining){
      Map<String, dynamic> data = {
        "current_balance": currentBalance,
        "avg_daily_spending": avgDailySpending,
        "price": price,
        "days_remaining": daysRemaining
      };
      return data.toString();
  }
  static String adviceOnBuyOutputModel(){
    Map<String, dynamic> data = {
      "can_afford": false,
      "reason": "This purchase would reduce your balance too much given your spending habits.",
      "safe_spending_limit": 150
    };
    return data.toString();
  }
  static String categorizationPromptData(){
    Map<String, dynamic> data = {
      "transaction_category": TransactionCategory.values,
      "income_tags": IncomeTags.values,
      "expense_tags": ExpenseTags.values,
    };
    return data.toString();
  }
  static String categorizationOutputModel(){
    Map<String, dynamic> data = {
      "amount": 35,
      "tag": "expense",
      "transaction_category": "transport"
    };
    return data.toString();
  }
  static String insightDetectionData(
      List<double> weeklySpending,
      Map<String, List<double>> categories,
      ){
    Map<String, dynamic> data = {
      "weekly_spending": [120, 150, 180, 220],
      "categories": categories,
    };
    return data.toString();
  }
  static String insightDetectionOutputModel(){
    Map<String, dynamic> data = {
      "patterns": [
        "Spending increases every week",
        "Food expenses are rapidly growing"
      ],
      "anomalies": [
        "Week 4 shows a sharp increase"
      ]
    };
    return data.toString();
  }
  static String weeklyReportPromptData(
      double monthlyIncome,
      double monthlyExpenses,
      Map<String, dynamic> expensesByCategory,
      Map<String, dynamic> transferTransactions
      ){
    Map<String, dynamic> data = {
      "income": monthlyIncome,
      "expenses": monthlyIncome,
      "top_category": expensesByCategory,
      "savings": transferTransactions
    };
    return data.toString();
  }
  static String weeklyReportOutputModel(){
    Map<String, dynamic> data = {
      "summary": "You managed your finances well this week.",
      "highlights": [
        "You saved 50",
        "Food was your biggest expense"
      ],
      "advice": "Try reducing food spending slightly to increase savings."
    };
    return data.toString();
  }
}