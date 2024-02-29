import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';

/// Used for displaying Category Cards in the Order Menu
class CategoryCard extends StatelessWidget {
  final Category category;
  final Function(List<Item> items) onTab;

  final EdgeInsets padding;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTab,
    this.padding = const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: padding,
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => onTab(category.items),
              child: GridTile(
                footer: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(.7),
                  ),
                  child: Text(
                    category.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                child: Ink.image(
                  image: AssetImage(category.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
