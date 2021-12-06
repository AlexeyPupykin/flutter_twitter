import 'package:flutter/material.dart';
import 'package:flutter_twitter/features/presentation/widgets/feed_items_list_widget.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedItemsList(),
    );
  }
}
