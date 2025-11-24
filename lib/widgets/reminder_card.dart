import 'package:caropshibrida/models/reminder_model.dart';
import 'package:caropshibrida/src/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final bool showCarName;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.showCarName,
  });

  @override
  Widget build(BuildContext context) {
    final double topMargin = showCarName ? 12.0 : 0.0;

    final date = reminder.notifyAt.toDate();
    return Padding(
      padding: EdgeInsets.only(top: topMargin),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: appColorsLight.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  reminder.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6.0),

                                if (reminder.notificationSent == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:Colors.orange,
  
                                               

                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Pendiente',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),




                              ]
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 27,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd/MM/yyyy').format(date),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 27,
                                      color: Colors.white54,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('HH:mm').format(date),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),


                              ]
                            ),
                            
                            
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: Colors.white.withOpacity(0.15)),


              ],
            ),
          ),

          if (showCarName)
            Positioned(
              top: -12,
              left: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  reminder.carName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

 


}
  