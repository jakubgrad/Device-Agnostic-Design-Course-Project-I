import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import 'package:device_agnostic_design_cp_1/QuestionPage.dart';

final router = GoRouter(
  routes: [
    GoRoute(
        path: '/', builder: (context, state) => MyHomePage(title: 'QuizzApp')),
    GoRoute(
        path: '/topics/:id/questions',
        builder: (context, state) =>
            //QuestionPage(int.parse(state.pathParameters['id']!))),
            QuestionPage(
              title: 'Question Page',
              id: int.parse(state.pathParameters['id']!),
            )),
  ],
);

void main() async {
  final url = Uri.parse('https://dad-quiz-api.deno.dev/topics');
  final response = await http.get(url);
  final result = jsonDecode(response.body);
  print(result);
  print(result[0]);

  runApp(MaterialApp.router(
    routerConfig: router,
    title: 'QuizzApp',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Map<String, dynamic>>? topics;

  @override
  void initState() {
    super.initState();
    getTopics();
  }

  getTopics() async {
    final url = Uri.parse('https://dad-quiz-api.deno.dev/topics');
    final response = await http.get(url);
    final List<dynamic> result = jsonDecode(response.body);
    setState(() {
      topics = result.map((e) => e as Map<String, dynamic>).toList();
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
