
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('finances_title'.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              //padding: const EdgeInsets.all(16.0),
              children: [
                _buildAccountsSection(context),
                const SizedBox(height: 24.0),
                _buildTransactionsSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'accounts_title'.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('...'), // Replace with actual account data
            trailing: ElevatedButton(
              onPressed: () {},
              child: Text('add_account_button'.tr()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'transactions_title'.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('...'), // Replace with actual transaction data
            trailing: TextButton(
              onPressed: () {},
              child: Text('view_all_button'.tr()),
            ),
          ),
        ),
      ],
    );
  }
}
