import 'package:caropshibrida/models/car_model.dart';
import 'package:caropshibrida/src/theme/colors.dart';
import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final Car car;

  const VehicleCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appColorsLight.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      elevation: 4,

      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/vehicle', arguments: car.id);
        },

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: (car.imageUrl != null && car.imageUrl!.isNotEmpty)
                    ? Image.network(
                        car.imageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[800],
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/generic_car_icon.png",
                        width: 100,
                        height: 100,
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
                      "${car.brand} ${car.model}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8.0),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        car.licensePlate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
