// ignore_for_file: use_build_context_synchronously

import 'package:e_esap/componentes/meu_botao_entrar.dart';
import 'package:e_esap/componentes/meu_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaginaLogin extends StatefulWidget {
  final VoidCallback mostrarPaginaDeRegisto;
  const PaginaLogin({super.key, required this.mostrarPaginaDeRegisto});

  @override
  State<PaginaLogin> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool ispasswordHidden = true;

  void entrar() async {

    showDialog(
      context: context, 
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
    );

    Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      //Email errado
      if (e.code == 'invalid-email') {
        //mostra o erro ao utilizador
        emailErrado();
      }

      //Palavra-passe errada
      if (e.code == 'invalid-credential') {
        //mostra o erro ao utilizador
        passwordErrada();
      }
    }
  }

  void emailErrado() {
    showDialog(
      context: context, 
      builder: (context) {
        return const AlertDialog(
          title: Text('Email incorreto!'),
        );
      },
    );
  }

  void passwordErrada() {
    showDialog(
      context: context, 
      builder: (context) {
        return const AlertDialog(
          title: Text('Palavra-Passe incorreta!'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                
                const SizedBox(height: 25),
                //logo
                Image.asset("imagens/LogoESAP.png", width: 300),

                const SizedBox(height: 100),
                
                //texto a dizer "Bem-vindo(a)"
                Text(
                  "Bem-vindo(a)",
                  style: TextStyle(color: Colors.grey[700],
                  fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                //utilizador
                MeuTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                //password
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: ispasswordHidden,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Palavra-Passe',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ispasswordHidden = !ispasswordHidden;
                          });
                        },
                        icon: Icon(ispasswordHidden ? Icons.visibility_off : Icons.visibility),
                      )
                    ),
                  ),
                ),
                
                const SizedBox(height: 25),

                //Botão de Entrar
                MeuBotaoEntrar(
                  onTap: entrar,
                ),

                const SizedBox(height: 10),

                //Não tem conta? Crie aqui
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Não tem conta?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.mostrarPaginaDeRegisto,
                        child: const Text(
                          'Clique aqui',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,  
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}