
/*import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/utils/string_formatter.dart';
import 'package:myapp/features/account/domain/entities/account.dart';
import 'package:myapp/features/account/presentation/cubit/account_cubit.dart';
import 'package:provider/provider.dart';

class MyAccountsCard extends StatelessWidget {
  const MyAccountsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Account> accounts = context.watch<AccountCubit>().state;

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return AccountItem(account: account);
        },
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final Account account;

  const AccountItem({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(account.accountName, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            formatAmount(account.balance, includeSymbol: true),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text('personal_account'.tr(), style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
*/