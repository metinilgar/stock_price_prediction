import 'package:flutter/material.dart';
import 'package:finance_app/src/features/navigation_menu/data/market_service.dart';
import 'package:finance_app/src/features/navigation_menu/models/market_data.dart';
import 'package:finance_app/src/utils/constants/network_constants.dart';
import 'package:shimmer/shimmer.dart';

class FollowedStocks extends StatefulWidget {
  const FollowedStocks({super.key});

  @override
  State<FollowedStocks> createState() => _FollowedStocksState();
}

class _FollowedStocksState extends State<FollowedStocks> {
  final _marketService = MarketService(baseUrl: NetworkConstants.baseUrl);
  List<FollowedStock>? _stocks;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFollowedStocks();
  }

  Future<void> _loadFollowedStocks() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Örnek olarak sabit hisse kodları kullanıyoruz
      // Gerçek uygulamada bu liste kullanıcının takip ettiği hisselerden gelmeli
      final stocks = await _marketService
          .getFollowedStocks(['THYAO.IS', 'ASELS.IS', 'SASA.IS']);
      setState(() {
        _stocks = stocks;
        _error = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Takip Edilen Hisseler',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadFollowedStocks,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Veriler yüklenirken bir hata oluştu. Lütfen tekrar deneyin.',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
          )
        else if (_isLoading)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(
                  3,
                  (index) => Column(
                        children: [
                          _buildShimmerItem(context),
                          if (index != 2) const Divider(),
                        ],
                      )),
            ),
          )
        else if (_stocks!.isEmpty)
          Center(
            child: Text(
              'Takip edilen hisse bulunmamaktadır.',
              style: theme.textTheme.bodyLarge,
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _stocks!.map((stock) {
                return Column(
                  children: [
                    _buildMarketItem(
                      context,
                      title: stock.symbol,
                      value:
                          '${stock.price.toStringAsFixed(2)} ${stock.currency}',
                      change:
                          '${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                      isPositive: stock.changePercent >= 0,
                    ),
                    if (stock != _stocks!.last) const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 80,
              height: 20,
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 60,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketItem(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                change,
                style: TextStyle(
                  color: isPositive
                      ? theme.colorScheme.tertiary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
