import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildSliderItem({
      required ThemeData theme,
      required Color startColor,
      required Color endColor,
      required Color textColor,
      required String title,
      required String subtitle,
    }) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      );
    }

    final items = [
      buildSliderItem(
        theme: theme,
        startColor: theme.colorScheme.primary,
        endColor: theme.colorScheme.primaryContainer,
        textColor: theme.colorScheme.onPrimary,
        title: 'Hoş Geldiniz',
        subtitle: 'Finansal Takip Uygulaması',
      ),
      buildSliderItem(
        theme: theme,
        startColor: theme.colorScheme.secondary,
        endColor: theme.colorScheme.secondaryContainer,
        textColor: theme.colorScheme.onSecondary,
        title: 'Piyasaları Takip Edin',
        subtitle: 'Anlık Borsa Verileri',
      ),
      buildSliderItem(
        theme: theme,
        startColor: theme.colorScheme.tertiary,
        endColor: theme.colorScheme.tertiaryContainer,
        textColor: theme.colorScheme.onTertiary,
        title: 'Portföyünüzü Yönetin',
        subtitle: 'Yatırımlarınızı Takip Edin',
      ),
    ];

    return CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.95,
          aspectRatio: 16 / 9,
          initialPage: 0,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: items);
  }
}
