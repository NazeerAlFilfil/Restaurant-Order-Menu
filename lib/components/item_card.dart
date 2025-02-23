import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';

/// Used to displayed Item Cards in the Order Menu
class ItemCard extends StatelessWidget {
  final Item item;
  final Function(Item item) onTab;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTab,
  });

  // TODO: Solve Ink Well not being applied well
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () => onTab(item),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Image
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage(item.imagePath),

                  // Loading >:)
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Padding
              const SizedBox(height: 8),

              // Label & Price
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Label
                    AutoSizeText(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium,
                      strutStyle: const StrutStyle(
                        forceStrutHeight: true,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Price
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        // Display the price of the first unit (Should be the most Expensive/Largest)
                        '${item.units.first.price} SR',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
