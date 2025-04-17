import 'package:api/presentation/pages/cocktail_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'data/repositories/cocktail_repository.dart';
import 'domain/usecases/search_cocktails_usecase.dart';
import 'presentation/bloc/cocktail_bloc.dart';

void main() {
  final dio = Dio();
  final repository = CocktailRepository(dio);
  final useCase = SearchCocktailsUseCase(repository);

  runApp(MyApp(useCase: useCase));
}

class MyApp extends StatelessWidget {
  final SearchCocktailsUseCase useCase;
  const MyApp({required this.useCase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Search',
      home: BlocProvider(
        create: (_) => CocktailBloc(useCase),
        child: CocktailPage(),
      ),
    );
  }
}
