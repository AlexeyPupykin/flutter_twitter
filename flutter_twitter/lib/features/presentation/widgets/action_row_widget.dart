import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  final int numLikes;
  final int numComments;

  const ActionRow({Key? key, required this.numLikes, required this.numComments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // likes
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width / 3 - 8,
              child: Row(
                children: [
                  const Icon(
                    Icons.favorite_outline_outlined,
                    size: 35,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    numLikes.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // comments
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.comment_outlined,
                  size: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  numComments.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // share
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width / 3 - 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.share_outlined,
                    size: 35,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
