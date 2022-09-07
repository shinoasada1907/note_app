import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/style/app_style.dart';

Widget notecard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc["color_id"]],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  doc["note_title"],
                  style: AppStyle.mainTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(
                Icons.star,
                color: doc["important"] ? Colors.yellow : Colors.white,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            doc["creation"],
            style: AppStyle.dateTitle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            doc["note_content"],
            style: AppStyle.mainContent,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ],
      ),
    ),
  );
}
