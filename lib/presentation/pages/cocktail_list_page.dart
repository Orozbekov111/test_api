import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cocktail_bloc.dart';
import '../../data/models/cocktail_model.dart';

class CocktailPage extends StatefulWidget {
  @override
  _CocktailPageState createState() => _CocktailPageState();
}

class _CocktailPageState extends State<CocktailPage> {
  final TextEditingController _controller = TextEditingController();
  String lastQuery = "mojito";

  @override
  void initState() {
    super.initState();
    context.read<CocktailBloc>().add(SearchCocktailsEvent(lastQuery));
  }

  void _onSearch(String query) {
    lastQuery = query;
    context.read<CocktailBloc>().add(SearchCocktailsEvent(query));
  }

  Future<void> _onRefresh() async {
    context.read<CocktailBloc>().add(RefreshCocktailsEvent(lastQuery));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
          ),
          
          onSubmitted: _onSearch,
        ),
      ),
      body: BlocBuilder<CocktailBloc, CocktailState>(
        builder: (context, state) {
          if (state is CocktailLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CocktailLoaded) {
            if (state.cocktails.isEmpty) {
              return Center(child: Text('Ничего не найдено'));
            }
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 165 / 250,
                ),
                itemCount: state.cocktails.length,
                itemBuilder: (context, index) {
                  return CocktailCard(cocktail: state.cocktails[index]);
                },
              ),
            );
          } else if (state is CocktailError) {
            return Center(child: Text('Ошибка загрузки'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class CocktailCard extends StatelessWidget {
  final CocktailModel cocktail;

  const CocktailCard({required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 250,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              cocktail.imageUrl,
              width: 140,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 140,
                height: 120,
                color: Colors.grey[200],
                child: Icon(Icons.local_bar),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            cocktail.name,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text('Тип: ${cocktail.type}', maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('Категория: ${cocktail.category}', maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('Цена: 350₽', style: TextStyle(color: Colors.green)), // Заглушка
        ],
      ),
    );
  }
}
