import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_order_menu/models/order%20types/local%20models/restaurant_table.dart';

import '../../models/order_type.dart';

class TableRadioCard extends StatefulWidget {
  final RestaurantTable table;
  final String? groupValue;
  final Function(String value) onChange;

  const TableRadioCard({
    super.key,
    required this.table,
    required this.groupValue,
    required this.onChange,
  });

  @override
  State<TableRadioCard> createState() => _TableRadioCardState();
}

class _TableRadioCardState extends State<TableRadioCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        onTap: () => widget.onChange(widget.table.id),
        dense: true,
        visualDensity: VisualDensity.compact,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        selected: widget.table.id == widget.groupValue,
        selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        title: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Tooltip(
                  message: 'Table Number',
                  child: Icon(Icons.table_restaurant),
                ),
                const SizedBox(width: 8.0),
                AutoSizeText(
                  widget.table.id,
                  maxLines: 1,
                ),
              ],
            ),
            if (widget.table.numberOfSeats != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Tooltip(
                    message: 'Number of Seats',
                    child: Icon(Icons.chair_alt),
                  ),
                  const SizedBox(width: 8.0),
                  AutoSizeText(
                    widget.table.numberOfSeats!,
                    maxLines: 1,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/*ChoiceChip(
                              //color: Colors.blue,
                              backgroundColor: Colors.transparent,
                              labelPadding: EdgeInsets.zero,
                              selected: (index + 1) == tableIndex,
                              onSelected: (selected) {
                                if (selected) {
                                  setLocalState(() {
                                    tableIndex = (index + 1);
                                  });
                                  setState(() {
                                    tableIndex;
                                  });
                                }
                              },
                              label: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Tooltip(
                                        message: 'Table Number',
                                        child: Icon(Icons.table_restaurant),
                                      ),
                                      const SizedBox(width: 8.0),
                                      AutoSizeText(
                                        '${index + 1}',
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Tooltip(
                                        message: 'Number of Seats',
                                        child: Icon(Icons.chair_alt),
                                      ),
                                      const SizedBox(width: 8.0),
                                      AutoSizeText(
                                        '4',
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );*/