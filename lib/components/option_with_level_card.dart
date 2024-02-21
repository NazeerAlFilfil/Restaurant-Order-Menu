import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/option_model.dart';

class OptionWithLevelCard extends StatefulWidget {
  final Option option;
  final int? level;
  final Function(Option option, int level) updatePickedOptions;

  const OptionWithLevelCard({
    super.key,
    required this.option,
    this.level,
    required this.updatePickedOptions,
  });

  @override
  State<OptionWithLevelCard> createState() => _OptionWithLevelCardState();
}

class _OptionWithLevelCardState extends State<OptionWithLevelCard> {
  late int level = widget.level ?? widget.option.defaultLevel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      surfaceTintColor: defaultLevelColors[level],
      child: InkWell(
        onTap: () {
          setState(() {
            level = (level + 1) % defaultLevelColors.length;
          });
          widget.updatePickedOptions(widget.option, level);
        },
        onLongPress: () {
          setState(() {
            level = 0;
          });
          widget.updatePickedOptions(widget.option, level);
        },
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 4.0,
              color: defaultLevelColors[level],
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: ListTile(
            leading: widget.option.imagePath != null
                ? Image(
                    image: AssetImage(widget.option.imagePath!),
                    width: 32.0,
                    height: 32.0,
                  )
                : null,
            title: Text(widget.option.label),
            subtitle: widget.option.price != null
                ? Text('+ ${widget.option.price} SR')
                : const Text('-'),
            trailing: Text(defaultLevelLabels[level]),
          ),
        ),
      ),
    );
  }
}
