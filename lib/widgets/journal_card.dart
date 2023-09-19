import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notetakingapp/style/app_stype.dart';

Widget journalCard(
    Function()? onTap, QueryDocumentSnapshot doc, Function()? longPress) {
  return InkWell(
    onTap: onTap,
    onLongPress: longPress,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.cardColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            doc["journal_title"],
            style: AppStyle.mainTitle,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            doc["creation_date"],
            style: AppStyle.dateTitle,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            doc["journal_content"],
            style: AppStyle.mainTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
