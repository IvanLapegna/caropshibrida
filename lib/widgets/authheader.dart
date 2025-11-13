import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHeader extends StatelessWidget {
  final String assetPath;
  final String title;
  final double logoWidth;
  final double spaceTop;

  const AuthHeader({
    Key? key,
    required this.assetPath,
    required this.title,
    this.logoWidth = 140,
    this.spaceTop = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: spaceTop),
        // Logo
        SvgPicture.asset(
          assetPath,
          width: logoWidth,
          semanticsLabel: 'Logo de la app',
          placeholderBuilder: (context) => SizedBox(
            width: logoWidth,
            height: logoWidth * 0.5,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        const SizedBox(height: 18),
        // Título centrado
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white, // o Theme.of(context).textTheme.headline6.color
          ),
        ),
        const SizedBox(height: 8),
        // Línea azul debajo del título
        Container(
          width: 120,
          height: 3,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
