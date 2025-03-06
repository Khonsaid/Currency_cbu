import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valyuta_kurslari/bloc/main/main_bloc.dart';
import 'package:valyuta_kurslari/screen/main_screen.dart';

import 'data/source/locel/hive_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(create: (context) => MainBloc()..add(LoadDataEvent()), child: const MainScreen()),
    );
  }
}
