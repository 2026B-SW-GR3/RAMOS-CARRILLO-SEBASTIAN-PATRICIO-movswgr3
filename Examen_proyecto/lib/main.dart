import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/item.dart';
import 'providers/db_provider.dart';
import 'screens/api_screen.dart';
import 'screens/crud_screen.dart';
import 'screens/secrets_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter()); // generado por build_runner
  runApp(
    ChangeNotifierProvider(
      create: (_) => DbProvider()..init(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Taller EPN',
    theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
    home: const MainNav(),
  );
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;
  final _screens = const [ApiScreen(), CrudScreen(), SecretsScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _screens[_index],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) => setState(() => _index = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'HTTP'),
        BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'BD Dual'),
        BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Secretos'),
      ],
    ),
  );
}