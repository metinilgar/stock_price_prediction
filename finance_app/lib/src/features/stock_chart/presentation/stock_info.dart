import 'package:flutter/material.dart';

class StockInfo extends StatelessWidget {
  const StockInfo({super.key, required this.stockInfo});

  final Map<String, dynamic> stockInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stockInfo['company_name'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                context,
                'Güncel Fiyat',
                stockInfo['current_price'],
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                context,
                'Piyasa Değeri',
                stockInfo['market_cap'],
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                'Sektör',
                stockInfo['sector'],
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                'Endüstri',
                stockInfo['industry'],
              ),
            ),
          ],
        ),
        Divider(
          height: 24,
          color: Theme.of(context).dividerColor,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildMetricRow(
                    '52 Hafta Yüksek',
                    stockInfo['52_week_high'],
                    Icons.arrow_upward,
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 8),
                  _buildMetricRow(
                    '52 Hafta Düşük',
                    stockInfo['52_week_low'],
                    Icons.arrow_downward,
                    Theme.of(context).colorScheme.error,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildMetricRow(
                    'F/K Oranı',
                    stockInfo['pe_ratio'],
                    Icons.analytics,
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  _buildMetricRow(
                    'Temettü Verimi',
                    stockInfo['dividend_yield'],
                    Icons.payments,
                    Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildMetricRow(
          'Beta',
          stockInfo['beta'],
          Icons.show_chart,
          Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }

  Widget _buildMetricRow(
      String label, dynamic value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(
                value?.toString() ?? 'N/A',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value?.toString() ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String label, dynamic value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value?.toString() ?? 'N/A',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
