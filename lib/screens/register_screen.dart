import 'package:caropshibrida/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/authheader.dart';
import '../services/validator_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
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
  final ValidatorService _validatorService = ValidatorService();
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    try {
      await _authService.register(email, password);

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.registroExitosoTitle),
          content: Text(context.l10n.registroExitosoContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text(context.l10n.aceptar),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = context.l10n.yaExisteCuenta;
          break;
        case 'invalid-email':
          msg = context.l10n.emailInvalido;
          break;
        case 'weak-password':
          msg = context.l10n.contrasenaDebil;
          break;
        default:
          msg = e.message ?? context.l10n.errorInesperado;
      }
      setState(() => _errorMessage = msg);
    } on Exception catch (e) {
      if (e.toString().contains('correo_verificacion_no_enviado')) {
        setState(
          () => _errorMessage = context.l10n.noSePudoEnviarCorreoVerificacion,
        );
      } else {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _confirmValidator(String? v) {
    final value = (v ?? '');
    if (value.isEmpty) return context.l10n.confirmacionObligatoria;
    if (value != _passCtrl.text) return context.l10n.contrasenasNoCoinciden;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                // Column principal: el contenido ocupa el espacio disponible y el botón queda pegado abajo
                children: [
                  // El contenido que puede scrollear
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthHeader(
                            assetPath: 'assets/mainlogo.svg',
                            title: context.l10n.registrarse,
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
                                  decoration: InputDecoration(
                                    labelText: context.l10n.emailLabel,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validatorService.emailValidator,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passCtrl,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.contrasenaLabel,
                                  ),
                                  obscureText: true,
                                  validator:
                                      _validatorService.passwordValidator,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _confirmCtrl,
                                  decoration: InputDecoration(
                                    labelText:
                                        context.l10n.confirmarContrasenaLabel,
                                  ),
                                  obscureText: true,
                                  validator: _confirmValidator,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    style: Theme.of(context)
                                        .elevatedButtonTheme
                                        .style
                                        ?.copyWith(
                                          padding: WidgetStateProperty.all(
                                            const EdgeInsets.symmetric(
                                              vertical: 1,
                                              horizontal: 20,
                                            ),
                                          ),
                                          minimumSize: WidgetStateProperty.all(
                                            const Size.fromHeight(56),
                                          ),
                                        ),
                                    onPressed: _loading ? null : _submit,
                                    child: _loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(context.l10n.crearCuenta),
                                  ),
                                ),

                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón fijo abajo de todo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                      child: Text(context.l10n.yaTenesCuentaIniciaSesion),
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
