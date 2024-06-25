import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.title, required this.id});

  final String title;
  final int id;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _counter = 0;
  List<Map<String, dynamic>>? topics;

  @override
  void initState() {
    super.initState();
    getQuestion();
  }

  getTopics() async {
    final url = Uri.parse('https://dad-quiz-api.deno.dev/topics');
    final response = await http.get(url);
    final List<dynamic> result = jsonDecode(response.body);
    setState(() {
      topics = result.map((e) => e as Map<String, dynamic>).toList();
    });
  }

  getQuestion() async {
    final url = Uri.parse('https://dad-quiz-api.deno.dev/topics/$id/questions');
    final response = await http.get(url);
    final List<dynamic> result = jsonDecode(response.body);
    print(result);
    setState(() {
      //topics = result.map((e) => e as Map<String, dynamic>).toList();
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            topics == null
                ? const Text("No topics available")
                : Row(
                    children: topics!.map((topic) {
                    return ElevatedButton(
                      onPressed: () => context.go(topic["question_path"]),
                      child: Text(topic["name"]),
                    );
                  }).toList()),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
