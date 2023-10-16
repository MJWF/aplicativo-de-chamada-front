import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';
import 'teacher_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de presença',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 162, 236, 201)),
        useMaterial3: true,
      ),
      home: const TeacherPageStateCall(), //teste com pagina dos professores
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  bool isStudentCheck = false;
  bool isProfessorCheck = false;

  String nameCadastro = "";
  String emailCadastro = "";
  String emailRewriteCadastro = "";
  String passwordCadastro = "";
  String passwordRewriteCadastro = "";

  String errorTextValEmail = "";
  String errorTextValPassword = "";

  TextEditingController usernameTextField = TextEditingController();
  TextEditingController emailTextField = TextEditingController();
  TextEditingController emailRewriteTextField = TextEditingController();
  TextEditingController passwordTextField = TextEditingController();
  TextEditingController passwordRewriteTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.1,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    void clearFields() {
      setState(() {
        usernameTextField.clear();
        emailTextField.clear();
        emailRewriteTextField.clear();
        passwordTextField.clear();
        passwordRewriteTextField.clear();
        isStudentCheck = false;
        isProfessorCheck = false;
      });
    }

    SizedBox nameReturn() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            nameCadastro = text;
          },
          controller: usernameTextField,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: 'Nome do novo usuário'),
        ),
      );
    }

    SizedBox emailReturn() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            emailCadastro = text;
            setState(() {
              if (text.contains("@")) {
                errorTextValEmail = "";
              } else {
                errorTextValEmail = "O email não é válido.";
              }
            });
          },
          controller: emailTextField,
          decoration: InputDecoration(
            errorText: errorTextValEmail.isEmpty ? null : errorTextValEmail,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Email do novo usuário',
          ),
        ),
      );
    }

    SizedBox emailRewriteReturn() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            emailRewriteCadastro = text;
            setState(() {
              if (text != emailCadastro) {
                errorTextValEmail = "Os emails não coincidem.";
              } else {
                errorTextValEmail = "";
              }
            });
          },
          controller: emailRewriteTextField,
          decoration: InputDecoration(
            errorText: errorTextValEmail.isEmpty ? null : errorTextValEmail,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Confirme o email do novo usuário',
          ),
        ),
      );
    }

    SizedBox passwordReturn() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            passwordCadastro = text;
          },
          obscureText: true,
          controller: passwordTextField,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Senha do novo usuário',
          ),
        ),
      );
    }

    SizedBox passwordRewriteReturn() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            passwordRewriteCadastro = text;
            setState(() {
              if (text != passwordCadastro) {
                errorTextValPassword = "As senhas não coincidem.";
              } else {
                errorTextValPassword = "";
              }
            });
          },
          controller: passwordRewriteTextField,
          obscureText: true,
          decoration: InputDecoration(
            errorText:
                errorTextValPassword.isEmpty ? null : errorTextValPassword,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Confirme a senha do novo usuário',
          ),
        ),
      );
    }

    ButtonTheme buttonCreateNewUser() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {
            final url = Uri.parse('http://10.0.2.2:5000/cadastro');

            if (isStudentCheck) {
              await http.post(url, body: {
                'email': emailCadastro,
                'password': passwordCadastro,
                'nome': nameCadastro,
                'tipo_usuario': 'aluno'
              });
            } else {
              await http.post(url, body: {
                'email': emailCadastro,
                'password': passwordCadastro,
                'nome': nameCadastro,
                'tipo_usuario': 'professor'
              });
            }

            clearFields();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Criar Usuário',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    CheckboxListTile checkboxStudent = CheckboxListTile(
      value: isStudentCheck,
      onChanged: (bool? value) {
        setState(() {
          isStudentCheck = value!;
          isProfessorCheck = false;
        });
      },
      title: const Text('Aluno'),
      subtitle:
          const Text('Caso o novo usuário seja um aluno, selecione essa opção'),
    );

    CheckboxListTile checkboxProfessor = CheckboxListTile(
      value: isProfessorCheck,
      onChanged: (bool? value) {
        setState(() {
          isProfessorCheck = value!;
          isStudentCheck = false;
        });
      },
      title: const Text('Professor'),
      subtitle: const Text(
          'Caso o novo usuário seja um professor, selecione essa opção'),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text("Cadastro",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.03),
              nameReturn(),
              SizedBox(height: screenHeight * 0.03),
              emailReturn(),
              SizedBox(height: screenHeight * 0.03),
              emailRewriteReturn(),
              SizedBox(height: screenHeight * 0.03),
              passwordReturn(),
              SizedBox(height: screenHeight * 0.03),
              passwordRewriteReturn(),
              SizedBox(height: screenHeight * 0.03),
              checkboxProfessor,
              SizedBox(height: screenHeight * 0.03),
              checkboxStudent,
              SizedBox(height: screenHeight * 0.03),
              buttonCreateNewUser()
            ],
          ),
        ),
      ),
    );
  }
}
