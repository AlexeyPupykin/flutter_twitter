import 'package:flutter/material.dart';

class Comment {
  String author;
  String text;

  Comment(this.author, this.text);
}

class CommentsList extends StatelessWidget {
  final List<Comment> comments;

  const CommentsList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: comments[index].author + '  ',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w600)),
            TextSpan(
              text: comments[index].text,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
            ),
          ]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: comments.length,
    );
  }
}
