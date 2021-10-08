import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/bloc/mural_bloc/mural_bloc.dart';
import 'package:frontend/bloc/theme_bloc.dart';
import 'package:frontend/screens/navigator_screen.dart';
import 'package:frontend/screens/signup_screen_sawo.dart';
import 'package:frontend/services/logger.dart';
import 'package:frontend/widget/app_button.dart';
import 'package:sawo/sawo.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../repository/mural_repository.dart';

String kAccessKeyId = dotenv.env['ACCESS_KEY'] ?? "";
String kSecretAccessKey = dotenv.env['SECRET_ACCESS_KEY'] ?? "";

// sawo object
Sawo sawo = Sawo(
  apiKey: kAccessKeyId,
  secretKey: kSecretAccessKey,
);

class SawoLogin extends StatefulWidget {
  const SawoLogin({Key? key}) : super(key: key);

  @override
  _SawoLoginState createState() => _SawoLoginState();
}

class _SawoLoginState extends State<SawoLogin> {
  // user payload

  String user = "";
  // String msg = "";
  var res;
  MuralRepository repo = MuralRepository();
  Future<void> payloadCallback(context, payload) async {
    var themeBloc = BlocProvider.of<ThemeBloc>(context);
    if (payload == null || (payload is String && payload.length == 0)) {
      payload = "Login Failed :(";
    }
    setState(() {
      user = payload;

      logger.i(user +
          " *********************   ******  ************************** ");
    });

    res = await repo.sawoAttempLogin(jsonPayload: user) as Map<String, dynamic>;

    if (res['newUser'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => SignUpScreenSawo(
            emailAddress: res["email"],
          ),
        ),
      );
    } else {
      localInsertSignUp(res);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => MuralBloc(repo),
              child: BlocProvider<ThemeBloc>.value(
                value: themeBloc,
                child: NavigatorPage(),
              ),
            ),
            // builder: (context) =>
            //     NavigatorPage ()
          ));

      //TODO direct login
    }

    logger.i(res);
    //

    // user = res['message'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("UserData :- $user"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Cave',
                        style: TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 74,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Social',
                        style: TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 74,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Let\'s Get Primitive',
                        style: TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: Colors.white)),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                // Spacer(),

                AppButton(
                  buttonText: 'GET STARTED',
                  onTap: () async {
                    await sawo.signIn(
                      context: context,
                      identifierType: 'email',
                      callback: payloadCallback,
                    );
                    logger.i(res);
                  },
                  // child: Text('Email Login'),
                ),
                SizedBox(
                  height: 25,
                ),
                // Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Spawn into CaveSocial World',
                        style: TextStyle(
                            fontFamily: 'CircularStd',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ],
                ),
                Text('Powered by Sawo',
                    style: TextStyle(
                        fontFamily: 'CircularStd',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
