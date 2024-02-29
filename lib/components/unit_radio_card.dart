import 'package:flutter/material.dart';

import '../models/unit_model.dart';

class UnitRadioCard extends StatefulWidget {
  final Unit unit;
  final String? groupValue;
  final Function(String value) onChange;

  const UnitRadioCard({
    super.key,
    required this.unit,
    required this.groupValue,
    required this.onChange,
  });

  @override
  State<UnitRadioCard> createState() => _UnitRadioCardState();
}

class _UnitRadioCardState extends State<UnitRadioCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: widget.unit.imagePath != null
            ? Image(
          image: AssetImage(widget.unit.label == widget.groupValue &&
              widget.unit.filledImagePath != null
              ? widget.unit.filledImagePath!
              : widget.unit.imagePath!),
          color: widget.unit.label == widget.groupValue
              ? Theme.of(context).colorScheme.primary.withOpacity(1.00)
              : Theme.of(context).colorScheme.inverseSurface,
          width: 32,
          height: 32,
        )
            : null,
        title: Text(widget.unit.label),
        subtitle: Text('${widget.unit.price} SR'),
        selected: widget.unit.label == widget.groupValue,
        selectedTileColor:
        Theme.of(context).colorScheme.primary.withOpacity(0.15),
        onTap: () => widget.onChange(widget.unit.label),
      ),
    );
  }
}
