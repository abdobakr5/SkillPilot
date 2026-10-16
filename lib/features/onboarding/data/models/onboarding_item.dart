import 'package:flutter/material.dart';

class OnboardingItem {
  final String categoryTag;
  final String title;
  final String description;
  final String codeFilename;
  final String? badgeText;
  final String? badgeSubtext;
  final Widget cardContent;

  const OnboardingItem({
    required this.categoryTag,
    required this.title,
    required this.description,
    required this.codeFilename,
    this.badgeText,
    this.badgeSubtext,
    required this.cardContent,
  });
}
