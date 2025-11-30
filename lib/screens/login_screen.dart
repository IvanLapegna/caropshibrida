import 'package:caropshibrida/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/validator_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/authheader.dart';
import 'package:caropshibrida/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  final AuthService _authService = AuthService();
  final ValidatorService _validatorService = ValidatorService();
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _resetErrors() {
    if (mounted) setState(() => _errorMessage = null);
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
      await _authService.signIn(email, password);

      // Refrescar usuario y comprobar verificación de email
      final user = _authService.currentUser;
      await user?.reload();
      final refreshed = _authService.currentUser;

      if (refreshed != null && refreshed.emailVerified) {
        // Login OK y correo verificado -> ir a Home
        if (!mounted) return;
        // Asegurarnos de sacar el loader antes de navegar (opcional)
        setState(() => _loading = false);
        Navigator.of(context).pushReplacementNamed('/home');
        return;
      } else {
        // Usuario existe pero NO está verificado
        setState(() {
          _errorMessage = context.l10n.porFavorVerificaCorreo;
        });
        await _authService.signOut();
        return;
      }
    } on FirebaseAuthException catch (e) {
      // (Opcional) log para debugging
      // print('FirebaseAuthException: ${e.code} - ${e.message}');
      String msg;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'invalid-credential':
        case 'invalid-verification-code':
        case 'invalid-verification-id':
        case 'invalid-argument':
          msg = context.l10n.credencialesInvalidas;
          break;
        case 'user-disabled':
          msg = context.l10n.usuarioDeshabilitado;
          break;
        case 'too-many-requests':
          msg = context.l10n.demasiadosIntentos;
          break;
        case 'network-request-failed':
          msg = context.l10n.errorRed;
          break;
        default:
          // Si querés ver el mensaje original en debug, imprimilo arriba.
          msg = context.l10n.errorInesperado;
      }
      if (mounted) setState(() => _errorMessage = msg);
    } catch (e) {
      // cualquier otro error no-Firebase
      if (mounted) {
        setState(() => _errorMessage = context.l10n.errorInesperado);
      }
    } finally {
      // Siempre quitamos el loader
      if (mounted) setState(() => _loading = false);
    }
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AuthHeader(
                              assetPath: 'assets/mainlogo.svg',
                              title: AppLocalizations.of(
                                context,
                              )!.iniciarSesion,
                              logoWidth: 160,
                              spaceTop: 40,
                            ),

                            if (_errorMessage != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),

                            TextFormField(
                              controller: _emailCtrl,
                              decoration: InputDecoration(
                                labelText: context.l10n.emailLabel,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) {
                                  return context.l10n.debeIngresarCorreo;
                                }
                                if (!_validatorService.isValidEmail(value)) {
                                  return context.l10n.correoInvalido;
                                }
                                return null;
                              },
                              onChanged: (_) => _resetErrors(),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passCtrl,
                              decoration: InputDecoration(
                                labelText: context.l10n.contrasenaLabel,
                              ),
                              obscureText: true,
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty) {
                                  return context.l10n.debeIngresarContrasena;
                                }
                                return null;
                              },
                              onChanged: (_) => _resetErrors(),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
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
                                    : Text(context.l10n.entrar),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                    child: TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushReplacementNamed('/register'),
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
