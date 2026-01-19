import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_cubit.dart';
import 'package:myapp/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:myapp/features/transaction/presentation/widgets/transaction_form.dart';

class TransactionPage extends StatefulWidget {
  final String userId;
  const TransactionPage({super.key, required this.userId});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    // It's important to set the userId before fetching transactions.
    context.read<TransactionCubit>().setUserId(widget.userId);
    context.read<TransactionCubit>().getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text(transaction.amount.toString()),
                  trailing: Text(transaction.tag),
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Welcome! Add your first transaction.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return BlocProvider.value(
                value: BlocProvider.of<TransactionCubit>(context),
                child: const TransactionForm(transition: null),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
