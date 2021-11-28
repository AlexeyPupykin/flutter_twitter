import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/domain/entities/person_entity.dart';
import 'package:flutter_twitter/features/presentation/pages/person_detail_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/person_cache_image_widget.dart';

class PersonCard extends StatelessWidget {
  final PersonEntity person;

  const PersonCard({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(person: person),
          ),
        );
      },
      // child: Container(
      //   decoration: const BoxDecoration(
      //     color: Colors.black,
      //     // borderRadius: BorderRadius.circular(8),
      //   ),
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 80,
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Container(
      //               height: 60,
      //               width: 60,
      //               child: Image.asset('assets/images/user_img.png'),
      //               margin: const EdgeInsets.only(
      //                   left: 10.0, top: 10.0, bottom: 10.0),
      //             ),
      //             Container(
      //               alignment: Alignment.center,
      //               width: MediaQuery.of(context).size.width - 140.0,
      //               child: Text(
      //                 person.name,
      //                 style: const TextStyle(
      //                   fontSize: 22,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.w400,
      //                 ),
      //               ),
      //             ),
      //             Container(
      //               height: 60,
      //               width: 60,
      //               child: const Icon(
      //                 Icons.more_vert_outlined,
      //                 size: 35,
      //               ),
      //               margin: const EdgeInsets.only(
      //                   right: 10.0, top: 10.0, bottom: 10.0),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.width,
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             fit: BoxFit.fill,
      //             image: NetworkImage(person.image),
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 80,
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             SizedBox(
      //               height: 60,
      //               width: MediaQuery.of(context).size.width / 3,
      //               child: Row(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: const [
      //                   Icon(
      //                     Icons.favorite_outline_outlined,
      //                     size: 35,
      //                   ),
      //                   SizedBox(width: 10),
      //                   Text(
      //                     '42',
      //                     style: TextStyle(
      //                       fontSize: 20,
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w400,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 60,
      //               width: MediaQuery.of(context).size.width / 3,
      //               child: Row(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: const [
      //                   Icon(
      //                     Icons.comment_outlined,
      //                     size: 35,
      //                   ),
      //                   SizedBox(width: 10),
      //                   Text(
      //                     '13',
      //                     style: TextStyle(
      //                       fontSize: 20,
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.w400,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             SizedBox(
      //               height: 60,
      //               width: MediaQuery.of(context).size.width / 3,
      //               child: Row(
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: const [
      //                   Icon(
      //                     Icons.share_outlined,
      //                     size: 35,
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       Flex(
      //         direction: Axis.horizontal,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: const [
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Text(
      //             'nickname',
      //             style: TextStyle(
      //               fontSize: 20,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Expanded(
      //               child: Text(
      //                   'Подпись к посту подпись к посту подпись к посту подпись подпись к посту подпись к посту п')),
      //           SizedBox(
      //             width: 10,
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Flex(
      //         direction: Axis.horizontal,
      //         children: const [
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Text(
      //             'nickname_1',
      //             style: TextStyle(
      //               fontSize: 18,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Expanded(child: Text('Комментарий 1')),
      //           SizedBox(
      //             width: 10,
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 5,
      //       ),
      //       Flex(
      //         direction: Axis.horizontal,
      //         children: const [
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Text(
      //             'nickname_2',
      //             style: TextStyle(
      //               fontSize: 18,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w400,
      //             ),
      //           ),
      //           SizedBox(
      //             width: 10,
      //           ),
      //           Expanded(child: Text('Комментарий 1')),
      //           SizedBox(
      //             width: 10,
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      child: Row(
        children: [
          Container(
            child: PersonCacheImage(
              width: 166,
              height: 166,
              imageUrl: person.image,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Text(
                  person.name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: person.status == 'Alive'
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        '${person.status} - ${person.species}',
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Last known location:',
                  style: TextStyle(color: AppColors.greyColor),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  person.location.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Origin:',
                  style: TextStyle(
                    color: AppColors.greyColor,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  person.origin.name,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
    );
  }
}
