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
    bool isSelected = widget.table.id == widget.groupValue;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color surfaceColor = Theme.of(context).colorScheme.surface;

    bool isSelectable = !widget.table.occupied ^ isSelected;

    //TextStyle? textStyle = Theme.of(context).textTheme.bodySmall;
    //textStyle?.color = surfaceColor;

    /*return Tooltip(
      richMessage: WidgetSpan(
        style: Theme.of(context).tooltipTheme.textStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.table_bar,
                      color: surfaceColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Table Number: ',
                      style: TextStyle(fontSize: 11.0, color: surfaceColor),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.label_important,
                      color: surfaceColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Name: ',
                      style: TextStyle(fontSize: 11.0, color: surfaceColor),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.event_seat,
                      color: surfaceColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'Seats: ',
                      style: TextStyle(fontSize: 11.0, color: surfaceColor),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.table.id,
                  style: TextStyle(fontSize: 11.0, color: surfaceColor),
                ),
                Text(
                  widget.table.tableName ?? '-',
                  style: TextStyle(fontSize: 11.0, color: surfaceColor),
                ),
                Text(
                  widget.table.numberOfSeats ?? '-',
                  style: TextStyle(fontSize: 11.0, color: surfaceColor),
                ),
              ],
            ),
          ],
        ),
      ),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        color: isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () => widget.onChange(widget.table.id),
          splashColor: primaryColor.withOpacity(0.15),
          highlightColor: primaryColor.withOpacity(0.10),
          child: Column(
            children: <Widget>[
              widget.table.tableName != null
                  ? AutoSizeText(
                      widget.table.tableName!,
                      maxLines: 1,
                      style: isSelected ? TextStyle(color: primaryColor) : null,
                    )
                  : const Text(''),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? primaryColor : const Color(0xFF000000),
                        width: 5.0,
                      ),
                    ),
                    child: Text(
                      widget.table.id,
                      maxLines: 1,
                      style: isSelected ? TextStyle(color: primaryColor) : null,
                    ),
                  ),
                ),
              ),
              widget.table.numberOfSeats != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.event_seat,
                          color: isSelected ? primaryColor : null,
                        ),
                        //const Text(': '),
                        const SizedBox(width: 8.0),
                        AutoSizeText(
                          widget.table.numberOfSeats!,
                          maxLines: 1,
                          style: isSelected
                              ? TextStyle(color: primaryColor)
                              : null,
                        ),
                      ],
                    )
                  : const Text(''),
            ],
          ),
        ),
      ),
    );*/

    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      color: widget.table.occupied ? Colors.black.withOpacity(0.15) :
      (isSelected ? primaryColor.withOpacity(0.15) : Colors.transparent),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.table.occupied ? null :
        (() => widget.onChange(widget.table.id)),
        splashColor: primaryColor.withOpacity(0.15),
        highlightColor: primaryColor.withOpacity(0.10),
        child: Column(
          children: <Widget>[
            widget.table.tableName != null
                ? AutoSizeText(
              widget.table.tableName!,
              maxLines: 1,
              style: isSelected ? TextStyle(color: primaryColor) : null,
            )
                : const Text(''),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                      isSelected ? primaryColor : const Color(0xFF000000),
                      width: 5.0,
                    ),
                  ),
                  child: Text(
                    widget.table.id,
                    maxLines: 1,
                    style: isSelected ? TextStyle(color: primaryColor) : null,
                  ),
                ),
              ),
            ),
            widget.table.numberOfSeats != null
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.event_seat,
                  color: isSelected ? primaryColor : null,
                ),
                //const Text(': '),
                const SizedBox(width: 8.0),
                AutoSizeText(
                  widget.table.numberOfSeats!,
                  maxLines: 1,
                  style: isSelected
                      ? TextStyle(color: primaryColor)
                      : null,
                ),
              ],
            )
                : const Text(''),
          ],
        ),
      ),
    );
  }
}
