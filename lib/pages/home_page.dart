import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pb = context.read<PocketBase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hello ${(pb.authStore.model as RecordModel).data['name']}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 50),
            OutlinedButton(
                onPressed: () {
                  print('logout');
                  pb.authStore.clear();
                },
                child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
