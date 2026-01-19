import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/transaction/presentation/widgets/transaction_form.dart';
import '../../../transaction/domain/entities/transaction.dart';
import '../bloc/auth_cubit.dart';

class LocationCurrencyPage extends StatefulWidget {
  final String selectedCountry;
  final String selectedCurrency;
  final List<Transaction> transactions;

  const LocationCurrencyPage({
    super.key,
    required this.selectedCountry,
    required this.selectedCurrency,
    required this.transactions,
  });

  @override
  State<LocationCurrencyPage> createState() => _LocationCurrencyPageState();
}

class _LocationCurrencyPageState extends State<LocationCurrencyPage> {
  String _selectedCurrency = 'USD';
  String _selectedCountry = 'United States';
  late List<Transaction> _transactions;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency == ""
        ? 'USD'
        : widget.selectedCurrency;
    _selectedCountry = widget.selectedCountry == ""
        ? 'United States'
        : widget.selectedCountry;
    _transactions = widget.transactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            context.read<AuthCubit>().emitRandomELement({
              //"name": name,
              "selectedCountry": _selectedCountry,
              "selectedCurrency": _selectedCurrency,
              "transactions": _transactions,
              "page": "password",
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(132, 112, 210, 133),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.public, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Location & Currency',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'For accurate formatting',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 40),
            Text('Country', style: Theme.of(context).textTheme.bodyMedium),
            DropdownButtonFormField<String>(
              initialValue: 'United States',
              items: ['United States', 'Canada', 'United Kingdom']
                  .map(
                    (label) =>
                        DropdownMenuItem(value: label, child: Text(label)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountry = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Currency', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                CurrencyChip(
                  label: 'USD',
                  symbol: '\$',
                  isSelected: _selectedCurrency == 'USD',
                  onSelected: (v) => setState(() => _selectedCurrency = 'USD'),
                ),
                CurrencyChip(
                  label: 'EUR',
                  symbol: '€',
                  isSelected: _selectedCurrency == 'EUR',
                  onSelected: (v) => setState(() => _selectedCurrency = 'EUR'),
                ),
                CurrencyChip(
                  label: 'GBP',
                  symbol: '£',
                  isSelected: _selectedCurrency == 'GBP',
                  onSelected: (v) => setState(() => _selectedCurrency = 'GBP'),
                ),
                CurrencyChip(
                  label: 'CAD',
                  symbol: '\$',
                  isSelected: _selectedCurrency == 'CAD',
                  onSelected: (v) => setState(() => _selectedCurrency = 'CAD'),
                ),
                CurrencyChip(
                  label: 'XOF',
                  symbol: 'CFA',
                  isSelected: _selectedCurrency == 'XOF',
                  onSelected: (v) => setState(() => _selectedCurrency = 'XOF'),
                ),
                CurrencyChip(
                  label: 'MAD',
                  symbol: 'DH',
                  isSelected: _selectedCurrency == 'MAD',
                  onSelected: (v) => setState(() => _selectedCurrency = 'MAD'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Monthly Income (optional)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                //color: const Color.fromARGB(132, 112, 210, 133),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is EmitRandomELement) {
                        if (state.elements['transaction'] != null) {
                          if (state.elements['update']) {
                            _transactions.removeWhere(
                              (element) =>
                                  element.id ==
                                  state.elements['transaction']!.id,
                            );
                          }
                          _transactions.add(state.elements['transaction']);
                        }
                        if (state.elements['action'] != null) {
                          if (state.elements['action'] == "delete") {
                            _transactions.removeWhere(
                              (element) =>
                                  element.id == state.elements['target_id'],
                            );
                          }
                        }
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return TransactionForm(transition: null);
                              },
                            );
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 230,
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_transactions.length, (index) {
                        return streamCard(
                          _transactions[index],
                          _selectedCurrency,
                          context,
                          () {
                            context.read<AuthCubit>().emitRandomELement({
                              "action": "delete",
                              "target_id": _transactions[index].id,
                            });
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().emitRandomELement({
                  //"name": name,
                  "selectedCountry": _selectedCountry,
                  "selectedCurrency": _selectedCurrency,
                  "transactions": _transactions,
                  "page": "validate",
                });
              },
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(
                  const Size(double.maxFinite, 60),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Get Started', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

streamCard(Transaction transaction, String currency, context, onDelete) {
  return GestureDetector(
    onTap: () async {
      await showDialog(
        context: context,
        builder: (context) {
          return TransactionForm(transition: transaction);
        },
      );
    },
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          width: 150,
          height: 140,
          decoration: BoxDecoration(
            color: transaction.category.name == "income"
                ? const Color.fromARGB(127, 76, 175, 79)
                : const Color.fromARGB(132, 244, 67, 54),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.category.name),
              SizedBox(height: 20),
              Text(
                transaction.amount.toString(),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(currency),
            ],
          ),
        ),
        Align(
          alignment: Alignment(1, .5),
          child: SizedBox(
            width: 150,
            height: 145,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(108, 255, 255, 255),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 30,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class CurrencyChip extends StatelessWidget {
  final String label;
  final String symbol;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CurrencyChip({
    super.key,
    required this.label,
    required this.symbol,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ChoiceChip(
      label: SizedBox(
        width: 60,
        child: Column(
          children: [
            Text(
              symbol,
              style: textTheme.titleLarge?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary.withOpacity(0.7)
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      padding: const EdgeInsets.all(8.0),
    );
  }
}
