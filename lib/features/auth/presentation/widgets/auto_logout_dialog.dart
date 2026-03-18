import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_cubit.dart';

class AutoLogoutDialog extends StatefulWidget {
  final String title;
  final String content;
  final String buttonText;
  final int countdownFrom; // e.g., 10 seconds

  const AutoLogoutDialog({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.countdownFrom = 10, // Default to 10 seconds
  });

  @override
  State<AutoLogoutDialog> createState() => _AutoLogoutDialogState();
}

class _AutoLogoutDialogState extends State<AutoLogoutDialog> {
  late int _countdown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _countdown = widget.countdownFrom;
    _startTimer();
  }

  void _startTimer() {
    // Create a periodic timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        // If the countdown is still running, just update the state
        setState(() {
          _countdown--;
        });
      } else {
        // When the countdown reaches 0, perform the logout and stop the timer
        _performLogout();
      }
    });
  }

  void _performLogout() {
    _timer?.cancel(); // Stop the timer to prevent further calls
    if (mounted) {
      // Check if the widget is still in the tree before interacting with context
      context.read<AuthCubit>().signOut();
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.content),
          const SizedBox(height: 20),
          // Display the countdown timer
          Text(
            'Déconnexion automatique dans $_countdown secondes...',
            style: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          // When the user clicks the button, perform the logout immediately
          onPressed: _performLogout,
          child: Text(widget.buttonText),
        ),
      ],
    );
  }
}