import 'package:finance_app/src/features/navigation_menu/data/market_service.dart';
import 'package:finance_app/src/features/navigation_menu/models/market_data.dart';
import 'package:finance_app/src/utils/constants/network_constants.dart';
import 'package:flutter/material.dart';

class MarketOverview extends StatefulWidget {
  const MarketOverview({super.key});

  @override
  State<MarketOverview> createState() => _MarketOverviewState();
}

class _MarketOverviewState extends State<MarketOverview> {
  late final MarketService _marketService;
  MarketOverviewData? _marketData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _marketService = MarketService(baseUrl: KNetworkConstants.kBaseUrl);
    _loadMarketData();
  }

  Future<void> _loadMarketData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _marketService.getMarketOverview();

      setState(() {
        _marketData = data;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Piyasa Özeti',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!_isLoading)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadMarketData,
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error != null)
          Center(
            child: Column(
              children: [
                Text('Hata: $_error'),
                ElevatedButton(
                  onPressed: _loadMarketData,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (_marketData?.bist100 != null)
                  _buildMarketCard(
                    context,
                    title: 'BIST 100',
                    value:
                        _marketData!.bist100!.currentPrice.toStringAsFixed(2),
                    change:
                        '${_marketData!.bist100!.change.toStringAsFixed(2)}%',
                    isPositive: _marketData!.bist100!.change > 0,
                  ),
                if (_marketData?.usdTry != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: _buildMarketCard(
                      context,
                      title: 'Dolar/TL',
                      value:
                          _marketData!.usdTry!.currentPrice.toStringAsFixed(2),
                      change:
                          '${_marketData!.usdTry!.change.toStringAsFixed(2)}%',
                      isPositive: _marketData!.usdTry!.change > 0,
                    ),
                  ),
                if (_marketData?.eurTry != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: _buildMarketCard(
                      context,
                      title: 'Euro/TL',
                      value:
                          _marketData!.eurTry!.currentPrice.toStringAsFixed(2),
                      change:
                          '${_marketData!.eurTry!.change.toStringAsFixed(2)}%',
                      isPositive: _marketData!.eurTry!.change > 0,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMarketCard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surface.withOpacity(0.9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₺$value',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? theme.colorScheme.tertiary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isPositive
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
