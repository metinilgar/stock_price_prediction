import 'package:flutter/material.dart';

class HorizontalPeriodList extends StatelessWidget {
  const HorizontalPeriodList({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  final String selectedPeriod;
  final void Function(String period) onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          '5d',
          '1mo',
          '3mo',
          '6mo',
          '1y',
          '2y',
          '5y',
          '10y',
          'ytd',
          'max'
        ].map((period) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OutlinedButton(
              onPressed: () => onPeriodSelected(period),
              style: OutlinedButton.styleFrom(
                foregroundColor: selectedPeriod == period
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
                backgroundColor: selectedPeriod == period
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              child: Text(_getPeriodText(period)),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getPeriodText(String period) {
    switch (period) {
      case '5d':
        return '5G';
      case '1mo':
        return '1A';
      case '3mo':
        return '3A';
      case '6mo':
        return '6A';
      case '1y':
        return '1Y';
      case '2y':
        return '2Y';
      case '5y':
        return '5Y';
      case '10y':
        return '10Y';
      case 'ytd':
        return 'YBK';
      case 'max':
        return 'Max';
      default:
        return period;
    }
  }
}
