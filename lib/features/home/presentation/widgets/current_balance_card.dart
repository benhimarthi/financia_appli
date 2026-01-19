
/*import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/utils/string_formatter.dart';
import 'package:myapp/features/account/domain/entities/account.dart';
import 'package:myapp/features/account/presentation/cubit/total_balance_cubit.dart';
import 'package:provider/provider.dart';

class CurrentBalanceCard extends StatelessWidget {
  const CurrentBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<TotalBalanceCubit>().fetchTotalBalance();
    return Center(
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width * .8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              'assets/icons/Bullseye.png',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'total_balance'.tr(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 230, 230, 230), fontSize: 16),
            ),
            const SizedBox(height: 10),
            Consumer<TotalBalanceCubit>(
              builder: (context, totalBalanceCubit, child) {
                final totalBalance = totalBalanceCubit.state;
                return Text(
                  formatAmount(totalBalance, includeSymbol: true),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '**** **** **** 1234',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Image.asset(
                  'assets/icons/Bullseye.png',
                  height: 30,
                  width: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/