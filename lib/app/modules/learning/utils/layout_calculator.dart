import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kioku_navi/utils/extensions.dart';
import 'package:kioku_navi/utils/sizes.dart';

/// Utility class for calculating layout dimensions for tags
class LayoutCalculator {
  /// Calculate the width of a tag based on its text content
  static double calculateTagWidth(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    
    // Standard padding: horizontal padding (k2_5Double.wp * 2) + border (4) + safety margin (8)
    return textPainter.size.width + (k2_5Double.wp * 2) + 12;
  }
  
  /// Get the available width for tags considering padding and margins
  static double get availableWidth => 
      Get.width - (k2Double.wp * 4) - 20; // Conservative safety margin
  
  /// Calculate total width of a line of tags
  static double calculateLineWidth(
    List<({Widget tag, String text})> line,
    TextStyle textStyle,
  ) {
    return line.fold<double>(0, (sum, item) {
      final spacing = sum > 0 ? k3Double.wp : 0;
      return sum + spacing + calculateTagWidth(item.text, textStyle);
    });
  }
  
  /// Distribute tags across lines based on available width
  static List<List<({Widget tag, String text})>> distributeTagsAcrossLines(
    List<({Widget tag, String text})> tags,
    int maxLines,
  ) {
    final lines = List.generate(maxLines, (_) => <({Widget tag, String text})>[]);
    final availWidth = availableWidth;
    final textStyle = TextStyle(fontSize: k13Double.sp, fontWeight: FontWeight.w500);
    
    for (final tag in tags) {
      final tagWidth = calculateTagWidth(tag.text, textStyle);
      
      // Try to find a line with enough space
      bool placed = false;
      for (int i = 0; i < maxLines && !placed; i++) {
        final currentLineWidth = calculateLineWidth(lines[i], textStyle);
        final spaceNeeded = (currentLineWidth > 0 ? k3Double.wp : 0) + tagWidth;
        
        if (currentLineWidth + spaceNeeded <= availWidth) {
          lines[i].add(tag);
          placed = true;
        }
      }
      
      // Fallback: place in first empty line
      if (!placed) {
        for (int i = 0; i < maxLines; i++) {
          if (lines[i].isEmpty) {
            lines[i].add(tag);
            break;
          }
        }
      }
    }
    
    return lines;
  }
}