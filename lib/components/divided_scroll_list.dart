import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// Create a scrollable list view that divides each of its children by a divider
class DividedScrollList extends StatelessWidget {
  final List<Widget> children;

  const DividedScrollList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: List<Widget>.generate(children.length * 2 - 1, (index) {
            if (index % 2 == 0) {
              return children[(index / 2).round()];
            } else {
              return const Divider(
                height: 0,
                indent: 20,
                endIndent: 20,
              );
            }
          }),
        ),
      );
    } else {
      return Center(
        child: AutoSizeText(
          'Empty',
          maxLines: 1,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      );
    }
  }
}
