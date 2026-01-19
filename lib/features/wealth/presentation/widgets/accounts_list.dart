import 'package:flutter/material.dart';
import 'package:myapp/features/wealth/presentation/widgets/account_list_item.dart';

class AccountsList extends StatelessWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Accounts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          AccountListItem(
            icon: Icons.account_balance,
            iconColor: Colors.green,
            title: 'Savings Account',
            subtitle: '+3.2% this month',
            amount: '\$12,500',
          ),
          Divider(),
          AccountListItem(
            icon: Icons.account_balance_wallet,
            iconColor: Colors.blue,
            title: 'Checking Account',
            subtitle: '0% this month',
            amount: '\$4,200',
          ),
          Divider(),
          AccountListItem(
            icon: Icons.phone_android,
            iconColor: Colors.orange,
            title: 'Digital Wallet',
            subtitle: '+15.2% this month',
            amount: '\$850',
          ),
          Divider(),
          AccountListItem(
            icon: Icons.credit_card,
            iconColor: Colors.grey,
            title: 'Cash',
            subtitle: '0% this month',
            amount: '\$320',
          ),
        ],
      ),
    );
  }
}
