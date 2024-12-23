import 'package:dio/dio.dart';
import 'package:finance_app/src/features/search_stocks/models/search_model.dart';
import 'package:finance_app/src/features/stock_chart/presentation/stock_chart_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchModel> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchStocks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'http://10.0.2.2:8000/stock/search/$query',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        setState(() {
          _searchResults = SearchModel.fromMapList(data);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama sırasında bir hata oluştu')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisse Senedi Ara'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Hisse senedi ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchStocks('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchStocks,
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        "${_searchResults[index].name} - ${_searchResults[index].symbol} "),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockChartScreen(
                            symbol: _searchResults[index].symbol,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
