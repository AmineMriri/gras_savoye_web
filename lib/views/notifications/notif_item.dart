import 'package:flutter/material.dart';
import 'package:healio/helper/providers/theme_provider.dart';
import '../../helper/app_text_styles.dart';

class NotifItem extends StatelessWidget {
  final bool isRead;

  const NotifItem({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.themeProvider;
    AppTextStyles appTextStyles = AppTextStyles(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : themeProvider.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Notification title here",
                  style: appTextStyles.onyxSemiBold14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                "1h",
                style: appTextStyles.graniteGreyRegular14,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Some text here",
            style: appTextStyles.graniteGreyRegular14,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "13/12/2023",
              style: appTextStyles.graniteGreyRegular14,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
