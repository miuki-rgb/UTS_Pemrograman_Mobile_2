import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<String> {
  CategoryCubit() : super('Makanan'); // Default category

  void selectCategory(String category) {
    emit(category);
  }
}
