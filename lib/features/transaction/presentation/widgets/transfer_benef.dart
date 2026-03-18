import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransferBenef extends StatelessWidget {
  final dynamic beneficiary;
  final bool isDebt;
  const TransferBenef({super.key, required this.beneficiary, required this.isDebt});

  @override
  Widget build(BuildContext context) {
    return isDebt ?
    ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(beneficiary.tag),
          Spacer(),
          Text(beneficiary.date.toString().substring(0, 10)),
        ]
      ),
    ):
    ListTile(

    );
  }
}
