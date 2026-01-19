import 'package:flutter/material.dart';
import 'package:myapp/features/transaction/domain/entities/expense_tags.dart';
import 'package:myapp/features/transaction/domain/entities/income_tags.dart';

class TagIcon {
  static Map<String, IconData> incomeTagIcons = {
    IncomeTags.salary.name: Icons.monetization_on,
    IncomeTags.freelance.name: Icons.work,
    IncomeTags.investment.name: Icons.trending_up,
    IncomeTags.other.name: Icons.category,
  };

  static Map<String, IconData> expenseTagIcons = {
    ExpenseTags.rent.name: Icons.home,
    ExpenseTags.groceries.name: Icons.shopping_cart,
    ExpenseTags.transport.name: Icons.directions_car,
    ExpenseTags.entertainment.name: Icons.movie,
    ExpenseTags.health.name: Icons.favorite,
    ExpenseTags.utilities.name: Icons.lightbulb,
    ExpenseTags.other.name: Icons.category,
  };

  static IconData getIcon(String tag, bool isIncome) {
    if (isIncome) {
      return incomeTagIcons[tag] ?? Icons.category;
    } else {
      return expenseTagIcons[tag] ?? Icons.category;
    }
  }
}
