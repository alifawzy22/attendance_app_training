import 'package:attendance_app_training/home_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == "admin" && password == "1234") {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        ).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تسجيل الدخول بنجاح"),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("فشل في تسجيل الدخول"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Text(
                          "منظومة التدريب علي التطبيقات التشاركية",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 250),
                        // Username field
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "اسم المستخدم",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "من فضلك أدخل اسم المستخدم";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "كلمة المرور",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "من فضلك أدخل كلمة المرور";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 100),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.indigo,
                              ),
                            ),
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "دخول",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
