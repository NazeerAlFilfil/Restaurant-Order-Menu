import 'package:flutter/material.dart';

class FlexWrapper extends StatelessWidget {
  final int perRow;
  final List<Widget> children;

  const FlexWrapper({
    super.key,
    required this.perRow,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _wrapWidgets(perRow, children),
    );
  }

  List<Widget> _wrapWidgets(int perRow, List<Widget> children) {
    List<Widget> wrappedWidgets = [];

    List<Widget> row = [];

    for (int i = 0; i < children.length; i++) {
      // Add Widget to Row
      row.add(
        Flexible(child: children[i]),
      );

      // if we are at last index & we have a remainder, add padding (Empty Widget) to row
      if (i == children.length - 1 && (i + 1) % perRow != 0) {
        for (int j = 0; j < perRow - (children.length % perRow); j++) {
          row.add(
            const Flexible(child: Text('')),
          );
        }
      }

      // if we don't have a remainder (excluding when i = 0)
      // OR i = 0 (first element) & perRow = 1 (displaying 1 per row)
      // OR we are at last index
      // Then => add row to our widgets, and make a new row
      if (((i + 1) % perRow == 0 && i != 0) ||
          (i == 0 && perRow == 1) ||
          (i == children.length - 1)) {
        wrappedWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: row,
          ),
        );
        row = [];
      }
    }

    return wrappedWidgets;
  }
}
