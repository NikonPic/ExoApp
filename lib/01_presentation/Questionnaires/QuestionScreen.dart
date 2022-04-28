import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
      ),
      body: QuestionsContainer(),
    );
  }
}

// This class contains the quetions
class QuestionsContainer extends StatefulWidget {
  const QuestionsContainer({Key? key}) : super(key: key);

  @override
  State<QuestionsContainer> createState() => _QuestionsContainerState();
}

class _QuestionsContainerState extends State<QuestionsContainer> {
  // The Question attributes
  QuestionType type = QuestionType.unknown;
  String title = '';
  String description = '';
  List<String> options = [];
  bool typeUnequalUnknown = false;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.9,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                hint: Text('Gib den Fragetyp an'),
                items: QuestionType.values
                    .map((e) => e.toString())
                    .toList()
                    .map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (e) {
                  setState(() {
                    type = QuestionType.values
                        .firstWhere((element) => element.toString() == e);
                    if (type != QuestionType.unknown) {
                      typeUnequalUnknown = true;
                    }
                  });
                },
                validator: (value) =>
                    QuestionType.values.map((e) => e.toString()).toList()[0] ==
                            value
                        ? 'Bitte wähle eine Kategorie'
                        : null,
                value: type.toString(),
              ),
              TextFormField(
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Titel',
                ),
                onFieldSubmitted: (_) {},
                controller: titleController,
                validator: (title) => title != null && title.isEmpty
                    ? 'Bitte einen Titel angeben'
                    : null,
              ),
              TextFormField(
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Beschreibung',
                ),
                onFieldSubmitted: (_) {},
                controller: descController,
                validator: (description) =>
                    description != null && description.isEmpty
                        ? 'Bitte gib eine Beschreibung der Frage an'
                        : null,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    final isValid = _formKey.currentState!.validate();
                    if (isValid) {
                      setState(() {
                        title = 'valid';
                        description = descController.text;
                      });
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Save')),
              (type == QuestionType.multipleChoice)
                  ? _buildOptions()
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: [
        Text('Optionen'),
      ],
    );
  }
}

enum QuestionType {
  unknown,
  boolean,
  date,
  number,
  singleChoice,
  multipleChoice,
  text,
  email,
  password,
  phone
}

class Question {
  final String title;
  final String description;
  final QuestionType type;
  final List<String> options;

  Question(this.title, this.description, this.type, this.options);
}

class Score {
  final String title;
  final String description;
  final List<Question> questions;

  Score(this.title, this.description, this.questions);
}

class ScoreList {
  final String title;
  final String description;
  final List<Score> scores;

  ScoreList(this.title, this.description, this.scores);
}
