import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/pages/login_screen.dart';
import 'package:flutter_twitter/features/presentation/pages/registration_screen.dart';
import 'package:flutter_twitter/features/presentation/widgets/custom_search_delegate.dart';
import 'package:flutter_twitter/features/presentation/widgets/feed_item_cache_image_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          backgroundColor: AppColors.darkGreenColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16, top: 16),
              child: Text(
                'Сохранить',
                style: TextStyle(fontSize: 18, color: Color(0xFF208BFF)),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              'Никнейм',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            initialValue: 'nickname_user',
                            validator: (inputValue) {
                              if (inputValue!.isEmpty) {
                                return "Введите логин";
                              }
                              return null;
                            },
                            enableSuggestions: false,
                            keyboardType: TextInputType.visiblePassword,
                            autofocus: false,
                            autocorrect: false,
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            style: const TextStyle(
                                fontSize: 22.0, color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // label: Text('Логин'),
                              // hintText: 'Написать комментарий...',
                              contentPadding: const EdgeInsets.only(
                                  left: 20.0, bottom: 8.0, top: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              'О себе',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            validator: (inputValue) {
                              if (inputValue!.isEmpty) {
                                return "Введите логин";
                              }
                              return null;
                            },
                            enableSuggestions: false,
                            autofocus: false,
                            autocorrect: false,
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            style: const TextStyle(
                                fontSize: 22.0, color: Colors.black),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              // label: Text('Логин'),
                              // hintText: 'Написать комментарий...',
                              contentPadding: const EdgeInsets.only(
                                  left: 20.0, bottom: 8.0, top: 10.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    child: const Text('Выйти',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.darkGreenColor),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(8, 12, 8, 12)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: AppColors.darkGreenColor)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                    child: const Text('Удалить аккаунт',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.darkRedColor),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(8, 12, 8, 12)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(
                                        color: AppColors.darkGreenColor)))),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(10),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: AppColors.darkGreenColor),
                                    padding:
                                        EdgeInsets.fromLTRB(12, 24, 12, 12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                            "Вы уверены, что хотите удалить свой аккаунт?",
                                            style: TextStyle(fontSize: 24),
                                            textAlign: TextAlign.center),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: (((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          52) /
                                                      2) -
                                                  16),
                                              child: TextButton(
                                                child: const Text('Отмена',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(AppColors
                                                        .liteGreenColor),
                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                        const EdgeInsets.fromLTRB(
                                                            8, 12, 8, 12)),
                                                    foregroundColor: MaterialStateProperty.all<Color>(
                                                        Colors.white),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(5.0),
                                                            side: const BorderSide(color: AppColors.darkGreenColor)))),
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                              ),
                                            ),
                                            SizedBox(
                                              width: (((MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          52) /
                                                      2) -
                                                  16),
                                              child: TextButton(
                                                  child: const Text('Удалить',
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color>(
                                                              AppColors
                                                                  .darkRedColor),
                                                      padding: MaterialStateProperty.all<EdgeInsets>(
                                                          const EdgeInsets.fromLTRB(
                                                              8, 12, 8, 12)),
                                                      foregroundColor:
                                                          MaterialStateProperty.all<
                                                              Color>(Colors.white),
                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: AppColors.darkGreenColor)))),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegistrationPage(),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                  // Positioned(
                                  //     top: -100,
                                  //     child: Image.network(
                                  //         "https://i.imgur.com/2yaf2wb.png",
                                  //         width: 150,
                                  //         height: 150))
                                ],
                              ));
                        })
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return Dialog(
                    //         insetPadding: EdgeInsets.all(1),
                    //         backgroundColor: AppColors.darkGreenColor,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(
                    //                 4.0)), //this right here
                    //         child: SizedBox(
                    //           width: MediaQuery.of(context).size.width - 40,
                    //           height: 200,
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(bottom: 24),
                    //                   child: Text(
                    //                     'Вы уверены, что хотите удалить свой аккаунт?',
                    //                     style: TextStyle(fontSize: 24),
                    //                   ),
                    //                 ),
                    //                 Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   children: [
                    //                     SizedBox(
                    //                       width: (((MediaQuery.of(context)
                    //                                       .size
                    //                                       .width -
                    //                                   52) /
                    //                               2) -
                    //                           16),
                    //                       child: TextButton(
                    //                         child: const Text('Отмена',
                    //                             style: TextStyle(
                    //                                 fontSize: 22,
                    //                                 fontWeight:
                    //                                     FontWeight.w400)),
                    //                         style: ButtonStyle(
                    //                             backgroundColor: MaterialStateProperty.all<Color>(
                    //                                 AppColors.liteGreenColor),
                    //                             padding:
                    //                                 MaterialStateProperty.all<EdgeInsets>(
                    //                                     const EdgeInsets.fromLTRB(
                    //                                         8, 12, 8, 12)),
                    //                             foregroundColor:
                    //                                 MaterialStateProperty.all<Color>(
                    //                                     Colors.white),
                    //                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //                                 RoundedRectangleBorder(
                    //                                     borderRadius: BorderRadius.circular(5.0),
                    //                                     side: const BorderSide(color: AppColors.darkGreenColor)))),
                    //                         onPressed: () =>
                    //                             Navigator.pop(context, false),
                    //                       ),
                    //                     ),
                    //                     SizedBox(
                    //                       width: (((MediaQuery.of(context)
                    //                                       .size
                    //                                       .width -
                    //                                   52) /
                    //                               2) -
                    //                           16),
                    //                       child: TextButton(
                    //                           child: const Text('Удалить',
                    //                               style: TextStyle(
                    //                                   fontSize: 22,
                    //                                   fontWeight:
                    //                                       FontWeight.w400)),
                    //                           style: ButtonStyle(
                    //                               backgroundColor: MaterialStateProperty.all<Color>(
                    //                                   Color(0xFF540000)),
                    //                               padding: MaterialStateProperty.all<EdgeInsets>(
                    //                                   const EdgeInsets.fromLTRB(
                    //                                       8, 12, 8, 12)),
                    //                               foregroundColor:
                    //                                   MaterialStateProperty.all<
                    //                                       Color>(Colors.white),
                    //                               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    //                                   RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: AppColors.darkGreenColor)))),
                    //                           onPressed: () {
                    //                             Navigator.push(
                    //                               context,
                    //                               MaterialPageRoute(
                    //                                 builder: (context) =>
                    //                                     const RegistrationPage(),
                    //                               ),
                    //                             );
                    //                           }),
                    //                     ),
                    //                   ],
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     })
                    ),
              ),
            ],
          ),
        ));
  }
}
