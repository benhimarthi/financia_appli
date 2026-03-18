import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/methods/calculate_period_total_transaction.dart';
import '../../../../core/service/gemini.service.dart';
import '../../../ai_assistant/presentation/cubit/ai_assistant_cubit.dart';
import '../../../ai_assistant/presentation/cubit/ai_assistant_state.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../../../transaction/domain/entities/transaction_category.dart';

void showChatAssistant(BuildContext context, List<Transaction> transactions) {
  //final gemini = GeminiService();

  // Get current currency from AuthCubit
  String currency = "MAD";
  final authState = context.read<AuthCubit>().state;
  if (authState is AuthSuccess) currency = authState.user.currentCurrency!;

  // Initialize with current transactions
  //gemini.startChat(context, transactions, currency);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      TextEditingController _controller = TextEditingController();
      List<Map<String, String>> messages = [
        {"role": "ai", "text": "Hello! I've analyzed your planned transactions. How can I help?"}
      ];

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16, right: 16, top: 20
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Budget Assistant", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isAi = messages[index]["role"] == "ai";
                      return Align(
                        alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isAi ? Colors.grey[200] : Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(messages[index]["text"]!),
                        ),
                      );
                    },
                  ),
                ),
                BlocConsumer<AIAssistantCubit, AIAssistantState>(
                  listener: (context, state) {
                    if (state is AIAssistantError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
                    }
                    if (state is AIAssistantLoaded) {
                      setModalState(() {
                        messages.add({"role": "ai", "text": state.messages.first.text ?? "No response"});
                      });
                    }
                  },
                  builder: (context, state) {
                    return TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Can I afford a new phone?",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            String userText = _controller.text;
                            if (userText.isEmpty) return;
                            setModalState(() {
                              messages.add({"role": "user", "text": userText});
                              _controller.clear();
                            });
                            final contextPrompt = "Here is my current financial data for this month: "
                                "Planned Income: ${CalculatePeriodTransaction.calculateMonthTotalTransaction(transactions, TransactionCategory.income, DateTime.now().month, DateTime.now().year)} $currency. "
                                "Planned Expenses: ${transactions.where((t) => t.category == TransactionCategory.expense).map((e) => e.amount).fold(0.0, (a, b) => a + b)} $currency. "
                                "Transaction Details: ${transactions.map((t) => '${t.category.name} - ${t.tag}: ${t.amount}').join(', ')}.";
                            context.read<AIAssistantCubit>().sendMessage(userText, contextPrompt);
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      );
    },
  );
}