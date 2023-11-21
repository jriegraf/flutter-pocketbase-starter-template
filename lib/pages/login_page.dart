import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final pb = context.read<PocketBase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: loading ? null : () => _loginWithGoogle(pb),
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 40,
            width: 200,
            child: Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 5),
                        Text('Login with Google'),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginWithGoogle(PocketBase pb) async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 2), () => null);

    await pb
        .collection('users')
        .authWithOAuth2('google', (url) => launchUrl(url))
        .then((authData) {
      pb
          .collection('users')
          .update(authData.record!.id, body: {'name': authData.meta['name']});
    });
  }
}
