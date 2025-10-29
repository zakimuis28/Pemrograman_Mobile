import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Nama'), validator: (v)=> v!.isEmpty? 'Wajib' : null),
              TextFormField(controller: email, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> v!.isEmpty? 'Wajib' : null),
              TextFormField(controller: pass, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v)=> v!.isEmpty? 'Wajib' : null),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading? null : () async {
                  if(!_form.currentState!.validate()) return;
                  setState(()=>loading=true);
                  await context.read<AuthProvider>().register(name.text, email.text, pass.text);
                  if(mounted){ Navigator.pushReplacementNamed(context, '/'); }
                },
                child: Text(loading? '...' : 'Daftar'),
              ),
              TextButton(onPressed: ()=> Navigator.pushReplacementNamed(context, '/login'), child: const Text('Sudah punya akun? Masuk'))
            ],
          ),
        ),
      ),
    );
  }
}
