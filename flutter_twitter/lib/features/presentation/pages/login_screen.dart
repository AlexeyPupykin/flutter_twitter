import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/features/presentation/pages/my_home_page.dart';
// import 'package:flutter_twitter/common/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final bool isValidForm = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    top: MediaQuery.of(context).size.width * 0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: const Text(
                        'Вход в аккаунт',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 36),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: const Text(
                        'Добро пожаловать!\n Введите свой логин и пароль для входа в аккаунт.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // login input group
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    'Логин',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextFormField(
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

                            // password input group
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    'Пароль',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                TextFormField(
                                  validator: (inputValue) {
                                    if (inputValue!.isEmpty) {
                                      return "Введите пароль";
                                    }
                                    return null;
                                  },
                                  cursorColor: Colors.black,
                                  cursorWidth: 1,
                                  autofocus: false,
                                  autocorrect: false,
                                  obscureText: true,
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
                        )),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                child: const Text('Войти',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColors.darkGreenColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(8, 12, 8, 12)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                                color: AppColors.darkGreenColor)))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                children: [
                  const TextSpan(text: 'Нет аккаунта?  '),
                  TextSpan(
                    text: 'Зарегистрироваться',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class LoginPage extends StatelessWidget {
//   final bool isValidForm = false;
//   final _formKey = GlobalKey<FormState>();
//   const LoginPage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: 8,
//                     right: 8,
//                     bottom: 8,
//                     top: MediaQuery.of(context).size.width * 0.2),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8.0),
//                       width: MediaQuery.of(context).size.width * 0.75,
//                       child: const Text(
//                         'Вход в аккаунт',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, fontSize: 36),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(8.0),
//                       width: MediaQuery.of(context).size.width * 0.75,
//                       child: const Text(
//                         'Добро пожаловать!\n Введите свой логин и пароль для входа в аккаунт.',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w400, fontSize: 20),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Form(
//                       key: ,
//                         child: Column(
//                       children: [
//                         // login input group
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.only(top: 8, bottom: 8),
//                               child: Text(
//                                 'Логин',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                             TextFormField(
//                               validator: (inputValue) {
//                                 if (inputValue!.isEmpty) {
//                                   return "Введите логин";
//                                 }
//                                 return null;
//                               },
//                               enableSuggestions: false,
//                               keyboardType: TextInputType.visiblePassword,
//                               autofocus: false,
//                               autocorrect: false,
//                               cursorColor: Colors.black,
//                               cursorWidth: 1,
//                               style: const TextStyle(
//                                   fontSize: 22.0, color: Colors.black),
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 // label: Text('Логин'),
//                                 // hintText: 'Написать комментарий...',
//                                 contentPadding: const EdgeInsets.only(
//                                     left: 20.0, bottom: 8.0, top: 10.0),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.white),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.white),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(
//                           height: 8,
//                         ),

//                         // password input group
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.only(top: 8, bottom: 8),
//                               child: Text(
//                                 'Пароль',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             ),
//                             TextFormField(
//                               validator: (inputValue) {
//                                 if (inputValue!.isEmpty) {
//                                   return "Введите пароль";
//                                 }
//                                 return null;
//                               },
//                               cursorColor: Colors.black,
//                               cursorWidth: 1,
//                               autofocus: false,
//                               autocorrect: false,
//                               obscureText: true,
//                               style: const TextStyle(
//                                   fontSize: 22.0, color: Colors.black),
//                               decoration: InputDecoration(
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 // label: Text('Логин'),
//                                 // hintText: 'Написать комментарий...',
//                                 contentPadding: const EdgeInsets.only(
//                                     left: 20.0, bottom: 8.0, top: 10.0),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.white),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.white),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: TextButton(
//                 child: const Text('Войти',
//                     style:
//                         TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(
//                         AppColors.darkGreenColor),
//                     padding: MaterialStateProperty.all<EdgeInsets>(
//                         const EdgeInsets.fromLTRB(8, 12, 8, 12)),
//                     foregroundColor:
//                         MaterialStateProperty.all<Color>(Colors.white),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0),
//                             side: const BorderSide(
//                                 color: AppColors.darkGreenColor)))),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const MyHomePage(),
//                     ),
//                   );
//                 }),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8, bottom: 8),
//             child: RichText(
//               text: TextSpan(
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 children: [
//                   const TextSpan(text: 'Нет аккаунта?  '),
//                   TextSpan(
//                     text: 'Зарегистрироваться',
//                     style: const TextStyle(color: Colors.blue),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const MyHomePage(),
//                           ),
//                         );
//                       },
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
