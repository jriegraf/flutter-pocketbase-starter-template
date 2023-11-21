import 'package:fetch_client/fetch_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pocketbase_template/pages/home_page.dart';
import 'package:flutter_pocketbase_template/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();

  final store = AsyncAuthStore(
    save: (String data) async => storage.write(key: 'pb_auth', value: data),
    initial: await storage.read(key: 'pb_auth'),
  );

  final pb = PocketBase(
    'http://localhost:9999',
    httpClientFactory: kIsWeb ? () => FetchClient(mode: RequestMode.cors) : null,
    authStore: store,
  );

  runApp(MultiProvider(
      providers: [
        Provider.value(value: pb),
      ],
      child: MaterialApp(
        title: 'Flutter PocketBase Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AppSceleton(),
      )));
}

class AppSceleton extends StatefulWidget {
  const AppSceleton({super.key});

  @override
  State<AppSceleton> createState() => _AppSceletonState();
}

class _AppSceletonState extends State<AppSceleton> {
  bool loading = true;
  late final PocketBase pb;
  late final Stream<AuthStoreEvent> authStream;

  @override
  void initState() {
    super.initState();
    pb = context.read<PocketBase>();

    authStream = pb.authStore.onChange;
    authStream.listen((event) => setState(() {}));
  }

  @override
  void dispose() {
    authStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (pb.authStore.isValid) {
      return const HomePage();
    }

    return const LoginPage();
  }
}
