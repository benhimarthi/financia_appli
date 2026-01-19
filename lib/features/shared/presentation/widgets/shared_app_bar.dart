import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      height: 200,
      padding: EdgeInsets.fromLTRB(
        16.0,
        MediaQuery.of(context).padding.top,
        16.0,
        16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top row: User info and action icons
          const Spacer(), // This flexible spacer prevents overflow by taking up available space.

          // Bottom row: Date and financial score
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(250.0); // Increased height to prevent overflow
}
