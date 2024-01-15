import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Question {
  String text;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}

class QuizCategory {
  String name;
  List<Question> questions;

  QuizCategory({
    required this.name,
    required this.questions,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<QuizCategory> categories = [
    QuizCategory(
      name: 'General Knowledge',
      questions: [
        Question(
          text: 'What is the capital of France?',
          options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
          correctOptionIndex: 2,
        ),
        // Add more questions for this category
      ],
    ),
    QuizCategory(
      name: 'Astro Science',
      questions: [
        Question(
          text: 'Which planet is known as the Red Planet?',
          options: ['Mars', 'Jupiter', 'Venus', 'Earth'],
          correctOptionIndex: 0,
        ),
        // Add more questions for this category
      ],
    ),
    QuizCategory(
      name: 'Social science',
      questions: [
        Question(
          text: 'Who built Taj Mahal?',
          options: ['Shah Jahan', 'Akbar', 'Baber', 'Jahangir'],
          correctOptionIndex: 0,
        ),
        
      ],
    ),
    QuizCategory(
      name: 'Mathematics',
      questions: [
        Question(
          text: 'What is 2/0?',
          options: ['2', '0', 'Infinity', '1'],
          correctOptionIndex: 2,
        ),
        
      ],
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz App',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 255, 234, 4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a Quiz Category',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                categories.length,
                (index) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                category: categories[index],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          categories[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalPoints = 0;

  void answerQuestion(int selectedOptionIndex) {
    if (selectedOptionIndex ==
        widget.category.questions[currentQuestionIndex].correctOptionIndex) {
      totalPoints++;
    }

    setState(() {
      if (currentQuestionIndex < widget.category.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('Total Points: $totalPoints'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz();
              },
              child: Text('Restart Quiz'),
            ),
          ],
        );
      },
    );
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      totalPoints = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.category.questions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              widget.category.questions[currentQuestionIndex].text,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),
            Column(
              children: List.generate(
                widget.category.questions[currentQuestionIndex].options.length,
                (index) {
                  return ElevatedButton(
                    onPressed: () => answerQuestion(index),
                    child: Text(
                      widget.category.questions[currentQuestionIndex].options[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
