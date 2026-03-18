import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:myapp/core/methods/calculate_period_total_transaction.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:myapp/features/transaction/domain/entities/transaction_category.dart';
import '../../features/transaction/domain/entities/transaction.dart';

class GeminiService {
  late final GenerativeModel _model;
  ChatSession? _chat;

  GeminiService() {
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-1.5-flash',
      // System instructions set the "personality" and rules
      systemInstruction: Content.system(
          "You are a helpful financial assistant. You have access to the user's planned transactions. "
              "Give concise, practical advice. If asked if they can afford something, "
              "calculate the balance from the provided data."
      ),
    );
  }
/*var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      if(authState.user.currentCurrency != null) currency = authState.user.currentCurrency!;
    }*/
  // Start a chat and provide the transaction context as the first message
  void startChat(context, List<Transaction> transactions, String currency) {
    final contextPrompt = "Here is my current financial data for this month: "
        "Planned Income: ${CalculatePeriodTransaction.calculateMonthTotalTransaction(transactions, TransactionCategory.income, DateTime.now().month, DateTime.now().year)} $currency. "
        "Planned Expenses: ${transactions.where((t) => t.category == TransactionCategory.expense).map((e) => e.amount).fold(0.0, (a, b) => a + b)} $currency. "
        "Transaction Details: ${transactions.map((t) => '${t.category.name} - ${t.tag}: ${t.amount}').join(', ')}.";

    _chat = _model.startChat(
        history: [
          Content.text(contextPrompt),
          Content.model([TextPart("Understood. I have your budget data. How can I help you today?")])
        ]
    );
  }

  Future<String?> askQuestion(String message) async {
    if (_chat == null) return "Error: Chat not initialized";
    try {
      final response = await _chat!.sendMessage(Content.text(message));
      return response.text;
    } catch (e) {
      return "Sorry, I'm having trouble connecting. $e";
    }
  }
}