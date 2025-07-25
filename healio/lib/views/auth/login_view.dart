import 'package:flutter/material.dart';
import 'package:healio/controllers/auth_controller.dart';
import 'package:healio/views/auth/forgetPassword.dart';
import 'package:healio/views/auth/signup_view.dart';

class Login extends StatefulWidget {

  const Login({super.key});


  @override
  State<Login> createState() => _LoginState();
}
final AuthController authController = AuthController();
class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      //backgroundColor: const Color(0xff471496),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            height: screenHeight * 0.25,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFFE57373)]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2.0,
                          color: Colors.white,
                        )
                      ],
                    )),
                MaterialButton(
                  onPressed: () {},
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(25),
            height: screenHeight * 0.75,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Continue to sign in!',
                  style: TextStyle(color: Colors.red, fontSize: 23),
                ),
                SizedBox(height: screenHeight * 0.09),
                const Text(
                  'EMAIL',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Container(
                  padding: EdgeInsets.only(top: 6),
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(3, 3)),
                      ]),
                  child: TextField(
                    controller: authController.emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'test@healio.com',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Container(
                  padding: EdgeInsets.only(top: 6),
                  height: screenHeight * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(3, 3)),
                      ]),
                  child: TextField(
                    controller: authController.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '*******',
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword(),));
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFB71C1C), Color(0xFFE57373)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                      height: 50,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      onPressed: () async {
                        authController.loginUser(context);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Center(child: Text('Don\'t have an account?')),
                Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ))),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}