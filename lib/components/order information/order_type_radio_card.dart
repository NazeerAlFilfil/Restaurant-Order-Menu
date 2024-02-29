import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../models/order_type.dart';

class OrderTypeRadioCard extends StatefulWidget {
  final OrderType orderType;
  final String? groupValue;
  final Function(String value) onChange;

  const OrderTypeRadioCard({
    super.key,
    required this.orderType,
    required this.groupValue,
    required this.onChange,
  });

  @override
  State<OrderTypeRadioCard> createState() => _OrderTypeRadioCardState();
}

class _OrderTypeRadioCardState extends State<OrderTypeRadioCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: SizedBox(
          width: double.infinity,
          child: Text(
            widget.orderType.type,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        horizontalTitleGap: 0,
        selected: widget.orderType.type == widget.groupValue,
        selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        onTap: () => widget.onChange(widget.orderType.type),
      ),
    );
  }
}