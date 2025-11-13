import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/authheader.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  final AuthService _authService = AuthService();
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }


  bool _isValidEmail(String v) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(v);
  }

  bool _isValidPassword(String v) {
    // Mismo patrón que en tu app nativa:
    final re = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@\$!%*?&.]{8,}$');
    return re.hasMatch(v);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState((){
      _loading = true;
    _errorMessage = null;
    } );

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    try {
      await _authService.register(email, password);

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Registro exitoso'),
          content: const Text('Te enviamos un correo de verificación. Por favor, revísalo para poder iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/Login');
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'Ya existe una cuenta con ese correo.';
          break;
        case 'invalid-email':
          msg = 'Email inválido.';
          break;
        case 'weak-password':
          msg = 'La contraseña es demasiado débil.';
          break;
        default:
          msg = e.message ?? 'Error inesperado';
      }
      setState(() => _errorMessage = msg);
      } on Exception catch (e) {
        if (e.toString().contains('correo_verificacion_no_enviado')) {
        setState(() => _errorMessage = 'No se pudo enviar el correo de verificación. Inténtalo de nuevo más tarde.');
      } else {
        setState(() => _errorMessage = e.toString());
      }

    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }



  String? _emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Correo obligatorio';
    if (!_isValidEmail(value)) return 'Correo inválido';
    return null;
  }

  String? _passwordValidator(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Contraseña obligatoria';
    if (!_isValidPassword(value)) return 'La contraseña debe tener 8 caracteres, una mayúscula, una minúscula y un número';
    return null;
  }

  String? _confirmValidator(String? v) {
    final value = (v ?? '');
    if (value.isEmpty) return 'Confirmación obligatoria';
    if (value != _passCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const AuthHeader(
                    assetPath: 'assets/mainlogo.svg',
                    title: 'Registrarse',
                    logoWidth: 160,
                    spaceTop: 40,
                  ),


                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: const InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: _emailValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passCtrl,
                          decoration: const InputDecoration(labelText: 'Contraseña'),
                          obscureText: true,
                          validator: _passwordValidator,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirmCtrl,
                          decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
                          obscureText: true,
                          validator: _confirmValidator,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  )
                                : const Text('Crear cuenta'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                          child: const Text('¿Ya tenes una cuenta? Inicia sesión'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
