import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/option_model.dart';
import '../utility.dart';

class LineItemOption extends StatelessWidget {
  final Option option;
  final int level;
  final double? size;

  const LineItemOption({
    super.key,
    required this.option,
    required this.level,
    this.size = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Option level boxes
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(defaultLevelColors.length-1, (index) {
            return Container(
              width: size,
              height: size,
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                color: optionColor(index, level),
              ),
            );
          }).reversed.toList(),
        ),

        // Padding
        const SizedBox(width: 4),

        // Image (if set)
        if (option.imagePath != null)
          Image(
            image: AssetImage(option.imagePath!),
            height: size! * 4,
            fit: BoxFit.fitHeight,
          ),

        // Display Label (if image is not set)
        if (option.imagePath == null)
          Text(option.label),
      ],
    );
  }


}
