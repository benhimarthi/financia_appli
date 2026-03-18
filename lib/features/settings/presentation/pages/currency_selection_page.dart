import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';

import '../../../auth/presentation/bloc/auth_cubit.dart';

// A temporary currency class, assuming the model is not created yet.
class Currency {
  final String code;
  final String name;
  final String symbol;
  final String countryCode;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.countryCode,
  });
}

class CurrencySelectionPage extends StatefulWidget {
  const CurrencySelectionPage({super.key});

  @override
  State<CurrencySelectionPage> createState() => _CurrencySelectionPageState();
}

class _CurrencySelectionPageState extends State<CurrencySelectionPage> {
  late User currentUser;
  final List<Currency> _currencies = const [
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$', countryCode: 'US'),
    Currency(code: 'EUR', name: 'Euro', symbol: '€', countryCode: 'EU'),
    Currency(code: 'GBP', name: 'British Pound', symbol: '£', countryCode: 'GB'),
    Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', countryCode: 'CA'),
    Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', countryCode: 'AU'),
    Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', countryCode: 'JP'),
  ];

  late List<Currency> _filteredCurrencies;
  String _selectedCurrencyCode = 'USD';

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = _currencies;
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<AuthCubit>().getUserById(authState.user.id);
    }
  }

  void _filterCurrencies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = _currencies;
      } else {
        _filteredCurrencies = _currencies
            .where((c) =>
        c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.code.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Currency', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state){
              if(state is AuthSuccess){
                currentUser = state.user;
                setState(() {
                  if(currentUser.currentCurrency != null){
                    _selectedCurrencyCode = currentUser.currentCurrency!;
                  }
                });
              }
            },
              builder: (context, state){
                return SizedBox();
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: _filterCurrencies,
              decoration: InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _filteredCurrencies.length,
                  separatorBuilder: (context, index) => Divider(height: 1, indent: 70, color: Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final currency = _filteredCurrencies[index];
                    final isSelected = currency.code == _selectedCurrencyCode;
                    return Material(
                      color: isSelected ? Colors.blue.withAlpha(13) : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            currency.countryCode,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        title: Text(
                          currency.code,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          currency.name,
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              currency.symbol,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(width: 20),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Colors.blue[800],
                              )
                            else
                              const SizedBox(width: 24),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCurrencyCode = currency.code;
                            var userModel = UserModel.fromEntity(currentUser);
                            var updatedUser = userModel.copyWith(currentCurrency: _selectedCurrencyCode);
                            context.read<AuthCubit>().updateUser(updatedUser);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}