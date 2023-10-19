import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListStudentsForEachDisciplineState extends StatefulWidget {
  final String emailUser;

  const ListStudentsForEachDisciplineState(
      {super.key, required this.emailUser});

  @override
  State<ListStudentsForEachDisciplineState> createState() => ListStudentsForEachDiscipline();
}

class ListStudentsForEachDiscipline
    extends State<ListStudentsForEachDisciplineState> {
  late double screenHeight;

  List<dynamic> disciplinesForTeacherListDynamic = [];
  List<String> disciplinesForTeacherList = [];
  List<dynamic> studentsSubscribedOnDisciplineListDynamic = [];
  List<String> studentsSubscribedOnDiscipline = [];

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-develop.onrender.com/retorna_materias_professor'),
        body: {'Email': widget.emailUser});

    setState(() {
      disciplinesForTeacherListDynamic = json.decode(response.body);

      for (int i = 0; i < disciplinesForTeacherListDynamic.length; i++) {
        disciplinesForTeacherList.add(disciplinesForTeacherListDynamic[i]['nome_materia']);
      }
    });
  }

  Future<void> fetchStudentsFromDiscipline(String disciplineForCheckStudents) async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-develop.onrender.com/return_alunos_materias'),
        body: {'materia_escolhida': disciplineForCheckStudents});

    setState(() {
      studentsSubscribedOnDiscipline = [];
      studentsSubscribedOnDisciplineListDynamic = json.decode(response.body);

      for (int i = 0; i < studentsSubscribedOnDisciplineListDynamic.length; i++) {
        studentsSubscribedOnDiscipline.add(studentsSubscribedOnDisciplineListDynamic[i]['nome_aluno']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle dropdownStyle =
        const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle style = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    Center dropDownDisciplineButton() {
      return Center(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          style: dropdownStyle,
          items: disciplinesForTeacherList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? selectedValueOnDropdownList) {
            setState(() {
              selectedDisciplineOnDropdownList = selectedValueOnDropdownList!;
              selectedIndexOnDropdownList = disciplinesForTeacherList.indexOf(selectedValueOnDropdownList);
              fetchStudentsFromDiscipline(selectedDisciplineOnDropdownList);
              ListStudentsForEachDisciplineState(emailUser: widget.emailUser);
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }

    Column returnListTileWithStudents(index) {
      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  studentsSubscribedOnDiscipline[index], style: style,
                ),
              )
            ]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Divider(
            color: Color.fromARGB(255, 162, 236, 201),
            height: 10.0,
          ),
        ),
      ]);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text("Alunos da matéria",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.08),
              dropDownDisciplineButton(),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: 1200,
                height: screenHeight * 0.6,
                child: ListView.builder(
                  itemCount: studentsSubscribedOnDiscipline.length,
                  itemBuilder: (context, index) {
                    return returnListTileWithStudents(index);
                  },
                )
              )
            ],
          ),
        )),
      ),
    );
  }
}
