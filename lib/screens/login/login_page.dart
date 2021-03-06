// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:thrift_project/local_storage/shared_preferences.dart';
import 'package:thrift_project/resources/dialogues.dart';
import 'package:thrift_project/services/auth_service.dart';
import 'package:thrift_project/screens/home_page.dart';
import 'widgets/email_text_field.dart';
import 'widgets/password_text_fields.dart';
import 'widgets/login_buttons.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isLoading = false;

  @override
  void initState() {
    _email = TextEditingController(text: LoginSharedPreferences.getUserEmail());
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: WillPopScope(
        onWillPop: () async {
          return await exitDialog(context);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image.png'),
                          fit: BoxFit.fill),
                    ),
                    height: height * .55,
                    width: width,
                    child: const Center(
                      child: Image(image: AssetImage('assets/logo.png')),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child:
                        EmailInputField(hintText: 'Email', controller: _email),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: PasswordTextField(controller: _password),
                  ),
                  const SizedBox(height: 12),
                  LoginButton(press: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      bool ifLogin = await Auth()
                          .signIn(_email.text.trim(), _password.text.trim());

                      if (ifLogin) {
                        await LoginSharedPreferences.setUserEmail(_email.text);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false);
                      } else {
                        await showErrorDialog(
                            context, 'Check Email and Password');
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot your password? Tap to Reset',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Image(image: AssetImage('assets/logo.png')),
                  const Text(
                    'Thrift safely with us',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 4,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
