import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uts_mobile/blocs/order_cubit.dart';
import 'package:uts_mobile/pages/category_stack_page.dart'; // Import CategoryStackPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(),
      child: MaterialApp(
        title: 'UTS Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CategoryStackPage(), // Set CategoryStackPage as the home page
      ),
    );
  }
}
