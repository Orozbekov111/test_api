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
        title: Container(
          width: 345,
          height: 41,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Color(0xFFE2E2E2), width: 1.4),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey), // Иконка поиска
              SizedBox(width: 8), // Отступ между иконкой и текстовым полем
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Поиск...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onSearch,
                ),
              ),
            ],
          ),
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cocktail.imageUrl,
                width: 149,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 140,
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.local_bar),
                    ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            cocktail.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            'Тип: ${cocktail.type}',

            maxLines: 1,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF797979),
            ),
          ),
          Text(
            'Категория: ${cocktail.category}',
            maxLines: 1,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF797979),
            ),
          ),
          Text(
            'Цена: 350₽',
            style: TextStyle(color: Colors.green),
          ), // сделай так чтобы цена тоже тут показывалось
          Center(
            child: Container(
              height: 32,
              width: 149,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0xFFB4B4B4)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Text(
                      'В корзину',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
