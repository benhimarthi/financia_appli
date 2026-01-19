import 'package:flutter/material.dart';
import 'package:myapp/features/plan/presentation/widgets/plan_info_card.dart';
import 'package:myapp/features/plan/presentation/widgets/transaction_list_item.dart';
import 'package:table_calendar/table_calendar.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: PlanInfoCard(
                    title: 'Upcoming Income',
                    amount: '\$3,200',
                    icon: Icons.arrow_upward,
                    backgroundColor: Color(0xFFE9F7EF),
                    iconColor: Color(0xFF27AE60),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: PlanInfoCard(
                    title: 'Upcoming Expenses',
                    amount: '\$1,285',
                    icon: Icons.arrow_downward,
                    backgroundColor: Color(0xFFFDEEEE),
                    iconColor: Color(0xFFE74C3C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upcoming Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const TransactionListItem(
              title: 'Salary',
              date: '12/27/2024',
              amount: '+\$2,700',
              isIncome: true,
              tag: "Salary",
              isPrevision: false,
            ),
            const TransactionListItem(
              title: 'Rent',
              date: '12/28/2024',
              amount: '-\$1,200',
              isIncome: false,
              tag: "Rent",
              isPrevision: false,
            ),
            const TransactionListItem(
              title: 'Internet',
              date: '12/30/2024',
              amount: '-\$85',
              isIncome: false,
              tag: "Internet",
              isPrevision: false,
            ),
            const TransactionListItem(
              title: 'Freelance',
              date: '1/5/2025',
              amount: '+\$500',
              isIncome: true,
              tag: "Freelance",
              isPrevision: false,
            ),
          ],
        ),
      ),
    );
  }
}
