import 'package:caropshibrida/src/theme/colors.dart';
import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String? image;
  final String car;
  final String licensePlate;

  const VehicleCard({
    super.key,
    this.image,
    required this.car,
    required this.licensePlate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appColorsLight.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,

      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: (image != null && image!.isNotEmpty)
                  ? Image.network(
                      image!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[800],
                        );
                      },
                    )
                  : Image.asset(
                      "assets/images/generic_car_icon.png",
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(width: 16.0),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    car,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4.0),

                  Text(
                    licensePlate,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
