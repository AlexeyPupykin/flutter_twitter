import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/widgets/person_cache_image_widget.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> photoUrls = [
      'https://via.placeholder.com/600/9c184f',
      'https://via.placeholder.com/600/8985dc',
      'https://via.placeholder.com/600/8f209a',
      'https://via.placeholder.com/600/5e3a73'
    ];
    return Scaffold(
      body: Column(
        children: [
          // photo, nickname, bio
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/user_img.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 110,
                        width: 110,
                        margin: const EdgeInsets.all(10.0),
                      ),
                      const Text(
                        'nickname_user',
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Информация о себе Инфо рмация о себе Инфор мация о себе Инфор мация о себе Информ ация о себе Информ ация о себе Инф ция о себе ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),

          // edit button
          Container(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 24),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                child: const Text('Редактировать',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.darkGreenColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(8, 12, 8, 12)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: const BorderSide(
                                color: AppColors.darkGreenColor)))),
                onPressed: () {}),
          ),

          // numbers of posts, subs
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: const [
                      Text(
                        '2',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Посты',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: const [
                      Text('62',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      Text('Подписчики',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: const [
                      Text('35',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400)),
                      Text('Подписки',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400))
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
            height: 4,
          ),

          // posts
          Expanded(
            child: GridView.builder(
              itemCount: photoUrls.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 2
                      : 3),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: GridTile(
                  child: PersonCacheImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    imageUrl: photoUrls[index],
                  ),
                ));
              },
            ),
            //     child: GridView.count(
            //   // physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   primary: false,
            //   crossAxisSpacing: 2,
            //   mainAxisSpacing: 2,
            //   crossAxisCount: 2,
            //   children: <Widget>[
            //     Container(
            //       child: PersonCacheImage(
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.width,
            //         imageUrl:
            //             '//images.ctfassets.net/yadj1kx9rmg0/wtrHxeu3zEoEce2MokCSi/cf6f68efdcf625fdc060607df0f3baef/quwowooybuqbl6ntboz3.jpg',
            //       ),
            //     ),
            //     Container(
            //       child: PersonCacheImage(
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.width,
            //         imageUrl: 'https://via.placeholder.com/600/9c184f',
            //       ),
            //     ),
            //     Container(
            //       child: const Text('Sound of screams but the'),
            //       color: Colors.teal[300],
            //     ),
            //     Container(
            //       child: const Text('Who scream'),
            //       color: Colors.teal[400],
            //     ),
            //     Container(
            //       padding: const EdgeInsets.all(8),
            //       child: const Text('Revolution is coming...'),
            //       color: Colors.teal[500],
            //     ),
            //     Container(
            //       padding: const EdgeInsets.all(8),
            //       child: const Text('Revolution, they...'),
            //       color: Colors.teal[600],
            //     ),
            //   ],
            // )
          )
        ],
      ),
    );
  }
}
