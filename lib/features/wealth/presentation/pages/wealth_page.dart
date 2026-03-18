import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/transaction/domain/entities/transaction.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:myapp/features/wealth/presentation/widgets/accounts_list.dart';
import 'package:myapp/features/wealth/presentation/widgets/liquid_wealth_card.dart';
import 'package:myapp/features/wealth/presentation/widgets/wealth_evolution_chart.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/presentation/bloc/transaction_cubit.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liquid Wealth',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your available cash & accounts',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                BlocConsumer<TransactionCubit, TransactionState>(
                    listener: (context, state){
                      if(state is TransactionLoaded){
                      }
                    },
                    builder: (context, state){
                      return Column(
                        children: [
                          LiquidWealthCard(),
                          SizedBox(height: 24),
                          WealthEvolutionChart(),
                          SizedBox(height: 24),
                          AccountsList(),
                        ]
                      );
                    },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
