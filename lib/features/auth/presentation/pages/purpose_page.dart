import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/domain/entities/account_type.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';
import 'sign_in_page.dart';

class PurposePage extends StatefulWidget {
  const PurposePage({super.key});

  @override
  State<PurposePage> createState() => _PurposePageState();
}

class _PurposePageState extends State<PurposePage> {
  late AccountType accountType;
  late String selectedPurpose;

  @override
  void initState() {
    super.initState();
    accountType = AccountType.business;
    selectedPurpose = 'Personal Finance';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome to FYN',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'How will you use FYN?',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              //color: Colors.amber,
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account?",
                    children: [
                      TextSpan(
                        text: " Sign in",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            PurposeCard(
              icon: Icons.person_outline,
              title: 'Personal Finance',
              subtitle: 'Track your personal money',
              isSelected: selectedPurpose == 'Personal Finance',
              onTap: () {
                context.read<AuthCubit>().emitRandomELement({
                  "purpose": "Personal Finance",
                  "page": "name",
                });
                setState(() {
                  accountType = AccountType.personal;
                  selectedPurpose = 'Personal Finance';
                });
              },
            ),
            const SizedBox(height: 20),
            PurposeCard(
              icon: Icons.business_center_outlined,
              title: 'Business Finance',
              subtitle: 'Manage your business',
              isSelected: selectedPurpose == 'Business Finance',
              onTap: () {
                context.read<AuthCubit>().emitRandomELement({
                  "purpose": "Business Finance",
                  "page": "name",
                });
                setState(() {
                  accountType = AccountType.business;
                  selectedPurpose = 'Business Finance';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PurposeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PurposeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(112),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                icon,
                size: 30,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
