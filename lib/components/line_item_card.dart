import 'package:flutter/material.dart';

import '../models/line_item_model.dart';
import '../utility.dart';
import 'line_item_option.dart';

class LineItemCard extends StatelessWidget {
  final LineItem lineItem;
  final Function(LineItem lineItem) onTab;
  final Function(LineItem lineItem) onRemovePressed;

  const LineItemCard({
    super.key,
    required this.lineItem,
    required this.onTab,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          child: InkWell(
            onTap: () => onTab(lineItem),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // First Row (Quantity, Name, Total)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Quantity
                      Text('${lineItem.quantity}x'),

                      // Padding
                      const SizedBox(width: 8),

                      // Label
                      Expanded(
                        child: Text(
                          lineItem.item.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Padding
                      const SizedBox(width: 8),

                      // Total Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '${formatNumber(lineItem.totalPrice)} SR',
                          ),

                          // Padding to fit remove button
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),

                  const Divider(),

                  // Second Row (Unit, Unit price, Before VAT, VAT)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Unit
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Unit',
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            lineItem.pickedUnit.label,
                          ),
                        ],
                      ),

                      // Unit Price
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Unit Price',
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            formatNumber(lineItem.unitPrice),
                          ),
                        ],
                      ),

                      // Before VAT Price
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Before VAT',
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            formatNumber(lineItem.beforeVATPrice),
                          ),
                        ],
                      ),

                      // VAT Price
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'VAT',
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                            ),
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            formatNumber(lineItem.VATPrice),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Display divider if there are no picked options
                  if (lineItem.pickedOptions.isNotEmpty) const Divider(),

                  // Third Row [Wrap] (Options)
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 10.0,
                    children: lineItem.pickedOptions.entries.map((entry) {
                      return LineItemOption(
                        option: entry.key,
                        level: entry.value,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Cancel Icon Button
        Positioned(
          top: -2,
          right: -2,
          child: IconButton(
            onPressed: () => onRemovePressed(lineItem),
            icon: const Icon(Icons.cancel),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            alignment: Alignment.topRight,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}
