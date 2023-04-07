import 'package:flutter/material.dart';


class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int currentQuestionIndex = 0;
  List<String> questions = [
    'What is Flutter ?',
    'Which programming language is used to develop Flutter apps?',
    'What is the widget tree in Flutter?'
  ];
  List<List<String>> answers = [
    ['A programming language', 'A mobile app development framework', 'A video game engine', ' A machine learning library'],
    ['Java', 'Swift', 'Dart', 'Python'],
    ['A data structure that represents the layout and structure of a Flutter app',
      ' A tool for debugging Flutter apps',
      'A way to organize assets and resources in a Flutter app',
      ' A programming pattern for building Flutter apps']
  ];
  List<int> correctAnswers = [0, 0, 0];
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                questions[currentQuestionIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ...answers[currentQuestionIndex].map((answer) {
                int index = answers[currentQuestionIndex].indexOf(answer);
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(index),
                    child: Text(answer),
                  ),
                );
              }).toList(),
              Spacer(),
              Text(
                'Score: $score / ${questions.length}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => resetQuiz(),
                child: Text('Restart Quiz'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void checkAnswer(int answerIndex) {
    if (answerIndex == correctAnswers[currentQuestionIndex]) {
      setState(() {
        score++;
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          showResult();
        }
      });
    } else {
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          showResult();
        }
      });
    }
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Results'),
          content: Text('Your score: $score / ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetQuiz();
              },
              child: Text('Restart Quiz'),
            ),
          ],
        );
      },
    );
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
    });
  }
}
