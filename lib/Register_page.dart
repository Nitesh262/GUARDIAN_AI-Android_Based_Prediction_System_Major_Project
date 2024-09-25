import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detection/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'colors.dart';
import 'model/usermodel.dart';

class register extends StatefulWidget {
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  //firebase
  final _auth = FirebaseAuth.instance;

  //form key
  final _formKey = GlobalKey<FormState>();

  // string for displaying the error Message
  String? errorMessage;

  late Color myColor;
  late Size mediaSize;
  TextEditingController firstNameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController confirmPasswordEditingController =
      new TextEditingController();
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
                  myColor.withOpacity(0.5), BlendMode.dstATop))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 40, child: _buildTop()),
            Positioned(top: 120, bottom: 0, child: _buildBottom()),
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
          padding: EdgeInsets.only(left: 32, right: 32, top: 25, bottom: 25),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Register Yourself !",
            style: TextStyle(
                color: myColor, fontSize: 30, fontWeight: FontWeight.w500),
          ),
          // _buildGrayText("Register Yourself !"),
          SizedBox(
            height: 30,
          ),
          inputField(),
          SizedBox(
            height: 15,
          ),
          _buildRememberForget(),
          SizedBox(
            height: 20,
          ),
          _buildRegisterButton(),
          SizedBox(
            height: 10,
          ),
          _buildOtherRegister(),
        ],
      ),
    );
  }

  Widget _buildGrayText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

//full name
  Widget inputField() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          _buildGrayText("Full Name"),
          TextFormField(
          autofocus: false,
          controller: firstNameEditingController,
          keyboardType: TextInputType.name,
          validator: (value) {
            RegExp regex = new RegExp(r'^.{5,}$');
            if (value!.isEmpty) {
              return ("Name cannot be Empty");
            }
            if (!regex.hasMatch(value)) {
              return ("Enter Valid name(Min. 5 Character)");
            }
            return null;
          },
          onSaved: (value) {
            firstNameEditingController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.account_circle),
          ),
        ),

          SizedBox(
            height: 10,
          ),
          _buildGrayText("Email address"),
        //email field
        TextFormField(
            autofocus: false,
            controller: emailEditingController,
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
              emailEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.mail),
            )),


          //password section
      SizedBox(height: 10,),
          _buildGrayText("Password"),
        TextFormField(
            autofocus: false,
            controller: passwordEditingController,
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
              firstNameEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.vpn_key),
            )),



          //confirm password section
          SizedBox(
            height: 10,
          ),
          _buildGrayText("Confirm Password"),
        TextFormField(
            autofocus: false,
            controller: confirmPasswordEditingController,
            obscureText: true,
            validator: (value) {
              if (confirmPasswordEditingController.text !=
                  passwordEditingController.text) {
                return "Password don't match";
              }
              return null;
            },
            onSaved: (value) {
              confirmPasswordEditingController.text = value!;
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.remove_red_eye),
            ))
      ]),
    );
  }

  //remember me section
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

  Widget _buildRegisterButton() {
    return ElevatedButton(
        onPressed: () {
          _formKey.currentState!.validate();
          _register(emailEditingController.text, passwordEditingController.text);
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          elevation: 4,
          shadowColor: myColor,
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text("Register"));
  }

  Widget _buildOtherRegister() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _buildGrayText("Or login with"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(icon: Image.asset("assets/fblogo.png")),
              Tab(icon: Image.asset("assets/googlelogo.png")),
              Tab(icon: Image.asset("assets/twitterlogo.png"))
            ],
          )
        ],
      ),
    );
  }



//signup or register
  void _register(String email, String password) async{
      try{
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
              Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch(error){
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
          case "email-already-in-use":
            errorMessage = "The account already exists for that email.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    ClientUserModel userModel = ClientUserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.cid = user.uid;
    userModel.name = firstNameEditingController.text;

    await firebaseFirestore
        .collection("client")
        .doc(user.uid)
        .set(userModel.toMap());

    await firebaseFirestore.collection("client").doc(user.uid).set(
        {"phoneNumber": "", "age": "", "gender": ""}, SetOptions(merge: true));
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => home()),
            (route) => false);
  }
}
