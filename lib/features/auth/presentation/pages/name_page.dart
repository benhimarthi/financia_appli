import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/auth_cubit.dart';

class NamePage extends StatefulWidget {
  final String name;
  const NamePage({super.key, required this.name});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late String name = '';

  @override
  void initState() {
    super.initState();
    name = widget.name;
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
              "name": name,
              "page": "purpose",
            });
          },
        ),
        /*actions: [
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().emitRandomELement({
                "name": name,
                "page": "currency",
              });
            },
            child: const Text('Skip'),
          ),
        ],*/
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'What\'s your name?',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll personalize your experience',
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Full Name',
                hintText: 'Enter your name',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(0, 158, 158, 158),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: name.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                fixedSize: Size(double.maxFinite, 60),
              ),

              onPressed: () {
                if (name.isEmpty) return;
                context.read<AuthCubit>().emitRandomELement({
                  "name": name,
                  "page": "email",
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: name.isNotEmpty
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: name.isNotEmpty
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
