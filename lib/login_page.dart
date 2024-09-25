import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';
import 'Register_page.dart';
import 'homescreen.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _State();
}

class _State extends State<login> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  late Color myColor;
  late Size mediaSize;

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool rememberUser = false;

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/backgroundimg.jpeg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  myColor.withOpacity(0.5), BlendMode.dstATop)
          )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 40, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom()),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 130, top: 1, right: 130),
              child: Image(
                image: AssetImage("assets/mainlogowithoutbackground.png"),
              )),
          Text(
            "Fake News\n Detector",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        _buildGrayText("Please login with your information"),
        SizedBox(
          height: 50,
        ),
        inputField(),
        _forgetPassword(),
        SizedBox(
          height: 15,
        ),
        _buildRememberForget(),
        SizedBox(
          height: 15,
        ),
        _buildLoginButton(),
        _buildSignUpButton(),
      ],
    );
  }

  Widget _buildGrayText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

//email field
  Widget inputField() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGrayText("Email address"),
        TextFormField(
            autofocus: false,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Please Enter Your Email");
              }
              // reg expression for email validation
              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value)) {
                return ("Please Enter a valid email");
              }
              return null;
            },
            onSaved: (value) {
              emailController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.mail),
            )),
            SizedBox(
              height: 20,
            ),
            _buildGrayText("Password"),
        TextFormField(
            autofocus: false,
            controller: passwordController,
            obscureText: true,
            validator: (value) {
              RegExp regex = new RegExp(r'^.{6,}$');
              if (value!.isEmpty) {
                return ("Password is required for login");
              }
              if (!regex.hasMatch(value)) {
                return ("Enter Valid Password(Min. 6 Character)");
              }
            },
            onSaved: (value) {
              passwordController.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.vpn_key),
            ))
      ]),
    );
  }

//remember me 
  Widget _buildRememberForget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGrayText("Remember me"),
          ],
        ),
        //TextButton(onPressed: (){}, child: _buildGrayText("I forget my password")),
      ],
    );
  }
  
  //forget password button
  Widget _forgetPassword(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Forget your password?",style: TextStyle(color: myColor),)
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.validate();
          signIn(emailController.text, passwordController.text);
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 20,
          shadowColor: myColor,
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text("Login"));
  }

  Widget _buildSignUpButton() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGrayText("Don't have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => register(),
                        ));
                  },
                  child: Text(
                    "Register Now",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Powered by ",
                style: TextStyle(fontWeight: FontWeight.bold,color: myColor),
              ),
              Text(
                "News Detector",
                style: TextStyle(color: gcolor),
              )
            ],
          )
        ],
      ),
    );
  }

  //signIn
  void signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful",
                backgroundColor: Colors.green),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => home())),
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        case "network-request-failed":
          errorMessage = "Network connection not available.";
          break;
        case "invalid-credential":
          errorMessage = "User doesn't exist.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }


}
