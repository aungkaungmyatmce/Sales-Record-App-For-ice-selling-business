import 'package:flutter/material.dart';

Future<bool> confirmDeleteTran(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('ဖျက်မှာသေချာပီလား ?'),
      actions: <Widget>[
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(true);

            // if (widget.isIncome) {
            //   await Provider.of<Incomes>(context, listen: false)
            //       .deleteIncomes(widget.transaction.id);
            // } else {
            //   await Provider.of<Outcomes>(context, listen: false)
            //       .deleteOutcomes(widget.transaction.id);
            // }
            //
            // Provider.of<DirectionsAndData>(context, listen: false)
            //     .setDirection(true);
            // Navigator.of(context).pop();
            // setState(() {});
          },
        ),
      ],
    ),
  );
  return false;
}
