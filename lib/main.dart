import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quizBrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quiz = QuizBrain();

void main() => runApp(const KidsQuiz());

class KidsQuiz extends StatelessWidget {
  const KidsQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.teal[300],
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  void userInput(bool userData) {
    bool correctAnswer = quiz.getAnswer();
    setState(() {
      if (quiz.isFinished() == true) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Finished!!!",
          desc: "You have reached to the end of the quiz.",
          buttons: [
            DialogButton(
              child: Text(
                "Try Again",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "Close App",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () =>
                  Future.delayed(const Duration(milliseconds: 200), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();
        scoreKeeper = [];
        quiz.reset();
      } else {
        if (correctAnswer == userData) {
          scoreKeeper.add(
            Icon(
              Icons.check_circle_rounded,
              color: Colors.green[700],
            ),
          );
        } else {
          scoreKeeper.add(
            Icon(
              Icons.dangerous,
              color: Colors.red[500],
            ),
          );
        }
        quiz.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Image.asset('images/quiz.png'),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quiz.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.green[700],
              child: Text(
                'TRUE',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 25.0,
                  letterSpacing: 3,
                ),
              ),
              onPressed: () {
                userInput(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'FALSE',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white70,
                  letterSpacing: 3,
                ),
              ),
              onPressed: () {
                userInput(false);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
