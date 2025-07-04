# ♿ AccessibilityHelper Usage Guide - KiokuNaviApp

**Version**: 1.0  
**Date**: 2025-07-04  
**Author**: Phase 3 Optimization Implementation  

---

## 📋 Overview

This guide provides comprehensive examples and best practices for using the AccessibilityHelper system implemented in Phase 3 optimization. The AccessibilityHelper ensures WCAG AA compliance and provides excellent accessibility features for users with disabilities.

---

## 🌟 Key Features

### **WCAG AA Compliance**
- ✅ **Minimum tap target size** (48dp)
- ✅ **Text scaling control** (0.8x - 2.0x)
- ✅ **Semantic labels** in Japanese
- ✅ **Haptic feedback** for interactions
- ✅ **High contrast support**
- ✅ **Reduced motion support**

### **Japanese Accessibility**
- ✅ **Screen reader support** with Japanese labels
- ✅ **Progress announcements** in Japanese
- ✅ **Course navigation** with completion status
- ✅ **Form field semantics** with required field indicators

---

## 🚀 Quick Start

### **Import AccessibilityHelper**

```dart
import 'package:kioku_navi/utils/accessibility_helper.dart';
```

### **Basic Usage**

```dart
// Get minimum tap target size
final tapSize = AccessibilityHelper.getMinimumTapTargetSize(Size(30, 30));
// Result: Size(48.0, 48.0) - ensures WCAG compliance

// Provide haptic feedback
AccessibilityHelper.provideTapFeedback();

// Create semantic label
final label = AccessibilityHelper.getButtonSemanticLabel('ログイン', hint: 'タップしてログインします');
```

---

## 🔧 Detailed Usage Examples

### **1. Button Accessibility Enhancement**

```dart
// Enhanced CustomButton with accessibility
class AccessibleCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? semanticsHint;

  const AccessibleCustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.semanticsHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get accessible tap target size
    final minSize = AccessibilityHelper.getMinimumTapTargetSize(
      Size(double.infinity, 50)
    );

    // Create semantic label
    final semanticLabel = AccessibilityHelper.getButtonSemanticLabel(
      text,
      hint: semanticsHint,
    );

    return AccessibilityHelper.createAccessibleButton(
      semanticsLabel: semanticLabel,
      semanticsHint: semanticsHint,
      minWidth: minSize.width,
      minHeight: minSize.height,
      onPressed: onPressed != null ? () {
        AccessibilityHelper.provideTapFeedback();
        onPressed!();
      } : null,
      child: Container(
        width: double.infinity,
        height: minSize.height,
        decoration: BoxDecoration(
          color: onPressed != null ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Usage example
AccessibleCustomButton(
  text: 'ログイン',
  semanticsHint: 'アカウントにログインします',
  onPressed: () {
    // Login action
  },
)
```

### **2. Form Field Accessibility**

```dart
// Accessible form field implementation
class AccessibleFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool isRequired;
  final String? errorText;
  final TextEditingController controller;
  final bool isPassword;

  const AccessibleFormField({
    Key? key,
    required this.label,
    required this.controller,
    this.hint,
    this.isRequired = false,
    this.errorText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccessibilityHelper.createAccessibleFormField(
      label: label,
      isRequired: isRequired,
      errorText: errorText,
      hint: hint,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 16,
        ),
        decoration: InputDecoration(
          labelText: isRequired ? '$label (必須)' : label,
          hintText: hint,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          contentPadding: EdgeInsets.all(AppSpacing.md),
          suffixIcon: isPassword ? 
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                AccessibilityHelper.provideTapFeedback();
                // Toggle password visibility
              },
              tooltip: 'パスワードを表示',
            ) : null,
        ),
      ),
    );
  }
}

// Usage example
AccessibleFormField(
  label: 'メールアドレス',
  hint: '例: user@example.com',
  isRequired: true,
  controller: emailController,
  errorText: hasEmailError ? 'メールアドレスの形式が正しくありません' : null,
)
```

### **3. Course Progress Accessibility**

```dart
// Accessible course node with progress announcement
class AccessibleCourseNode extends StatelessWidget {
  final String title;
  final double progress;
  final VoidCallback? onTap;
  final Widget? icon;

  const AccessibleCourseNode({
    Key? key,
    required this.title,
    required this.progress,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create semantic label with progress
    final semanticLabel = AccessibilityHelper.getCourseNodeSemanticLabel(title, progress);
    
    // Get minimum tap target size
    final minSize = AccessibilityHelper.getMinimumTapTargetSize(Size(60, 60));

    return AccessibilityHelper.makeAccessible(
      label: semanticLabel,
      hint: progress == 1.0 ? '完了済み' : 'タップして開始',
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap != null ? () {
          AccessibilityHelper.provideSelectionFeedback();
          
          // Announce progress to screen reader
          AccessibilityHelper.announceMessage(
            context,
            AccessibilityHelper.getProgressSemanticLabel(progress),
          );
          
          onTap!();
        } : null,
        child: Container(
          width: minSize.width,
          height: minSize.height,
          decoration: BoxDecoration(
            color: _getNodeColor(progress),
            shape: BoxShape.circle,
            border: Border.all(
              color: progress == 1.0 ? Colors.green : Colors.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: icon ?? Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getNodeColor(double progress) {
    if (progress == 1.0) return Colors.green;
    if (progress > 0.5) return Colors.orange;
    if (progress > 0) return Colors.blue;
    return Colors.grey;
  }
}

// Usage example
AccessibleCourseNode(
  title: '基礎学習 1',
  progress: 0.75,
  onTap: () {
    // Navigate to lesson
  },
)
```

### **4. Tutorial Navigation with Accessibility**

```dart
// Accessible tutorial view with proper semantics
class AccessibleTutorialView extends StatelessWidget {
  final String message;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const AccessibleTutorialView({
    Key? key,
    required this.message,
    required this.currentStep,
    required this.totalSteps,
    this.onNext,
    this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check for reduced motion
    final animationDuration = AccessibilityHelper.getAccessibleAnimationDuration(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Progress indicator with accessibility
              Semantics(
                label: 'チュートリアルの進捗',
                value: '$totalSteps中$currentStep番目',
                child: LinearProgressIndicator(
                  value: currentStep / totalSteps,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Tutorial message with accessible text
              Expanded(
                child: Center(
                  child: AccessibilityHelper.createAccessibleText(
                    text: message,
                    style: TextStyle(
                      fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 18,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    semanticsLabel: 'チュートリアルメッセージ: $message',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              // Navigation buttons
              Row(
                children: [
                  // Previous button
                  if (onPrevious != null)
                    Expanded(
                      child: AccessibleCustomButton(
                        text: '戻る',
                        semanticsHint: '前のステップに戻ります',
                        onPressed: () {
                          AccessibilityHelper.announceMessage(context, '前のステップに移動しました');
                          onPrevious!();
                        },
                      ),
                    ),
                  
                  if (onPrevious != null && onNext != null)
                    SizedBox(width: AppSpacing.md),
                  
                  // Next button
                  if (onNext != null)
                    Expanded(
                      child: AccessibleCustomButton(
                        text: currentStep == totalSteps ? '完了' : '次へ',
                        semanticsHint: currentStep == totalSteps 
                          ? 'チュートリアルを完了します' 
                          : '次のステップに進みます',
                        onPressed: () {
                          final message = currentStep == totalSteps 
                            ? 'チュートリアルが完了しました'
                            : '次のステップに移動しました';
                          AccessibilityHelper.announceMessage(context, message);
                          onNext!();
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### **5. Loading States with Accessibility**

```dart
// Accessible loading indicator
class AccessibleLoadingIndicator extends StatelessWidget {
  final String message;
  final bool isLoading;

  const AccessibleLoadingIndicator({
    Key? key,
    this.message = '読み込み中',
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return SizedBox.shrink();

    return Semantics(
      label: message,
      liveRegion: true, // Announces changes to screen readers
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              semanticsLabel: '進行状況インジケーター',
            ),
            SizedBox(height: AppSpacing.md),
            AccessibilityHelper.createAccessibleText(
              text: message,
              style: TextStyle(
                fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage in a view
class ExampleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExampleController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            children: [
              // Main content
              YourMainContent(),
              
              // Accessible loading overlay
              if (controller.isLoading.value)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: AccessibleLoadingIndicator(
                      message: 'データを読み込んでいます',
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
```

### **6. Error Display with Accessibility**

```dart
// Accessible error message display
class AccessibleErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const AccessibleErrorDisplay({
    Key? key,
    required this.errorMessage,
    this.onRetry,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'エラーメッセージ',
      liveRegion: true,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        margin: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Row(
          children: [
            // Error icon
            Semantics(
              label: 'エラーアイコン',
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade700,
                size: 24,
              ),
            ),
            
            SizedBox(width: AppSpacing.sm),
            
            // Error message
            Expanded(
              child: AccessibilityHelper.createAccessibleText(
                text: errorMessage,
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 14,
                ),
                semanticsLabel: 'エラー内容: $errorMessage',
              ),
            ),
            
            // Action buttons
            if (onRetry != null)
              AccessibilityHelper.createAccessibleButton(
                semanticsLabel: '再試行',
                semanticsHint: 'エラーを解決するために再試行します',
                onPressed: () {
                  AccessibilityHelper.provideSelectionFeedback();
                  onRetry!();
                },
                child: Icon(Icons.refresh, color: Colors.red.shade700),
              ),
            
            if (onDismiss != null)
              AccessibilityHelper.createAccessibleButton(
                semanticsLabel: '閉じる',
                semanticsHint: 'エラーメッセージを閉じます',
                onPressed: () {
                  AccessibilityHelper.provideTapFeedback();
                  onDismiss!();
                },
                child: Icon(Icons.close, color: Colors.red.shade700),
              ),
          ],
        ),
      ),
    );
  }
}
```

### **7. Responsive Accessibility**

```dart
// Device-aware accessibility implementation
class ResponsiveAccessibilityWidget extends StatelessWidget {
  final Widget child;
  final String semanticsLabel;

  const ResponsiveAccessibilityWidget({
    Key? key,
    required this.child,
    required this.semanticsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check accessibility settings
    final isHighContrast = AccessibilityHelper.isHighContrastMode(context);
    final isReducedMotion = AccessibilityHelper.isReducedMotionEnabled(context);
    final textScaleFactor = AccessibilityHelper.getAccessibleTextScaleFactor(context);
    
    return Semantics(
      label: semanticsLabel,
      child: AnimatedContainer(
        duration: isReducedMotion 
          ? Duration.zero 
          : AccessibilityHelper.getAccessibleAnimationDuration(context),
        decoration: BoxDecoration(
          border: isHighContrast 
            ? Border.all(color: Colors.black, width: 2)
            : null,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm * textScaleFactor),
          child: child,
        ),
      ),
    );
  }
}
```

### **8. Accessibility Testing Widget**

```dart
// Testing widget for accessibility features
class AccessibilityTestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アクセシビリティテスト')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text scaling test
            AccessibilityHelper.createAccessibleText(
              text: 'テキストスケーリングテスト',
              style: TextStyle(
                fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Minimum tap target test
            AccessibleCustomButton(
              text: 'タップターゲットテスト',
              semanticsHint: '最小タップサイズが適用されています',
              onPressed: () {
                AccessibilityHelper.announceMessage(context, 'ボタンがタップされました');
              },
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Haptic feedback test
            Row(
              children: [
                Expanded(
                  child: AccessibleCustomButton(
                    text: '軽いフィードバック',
                    onPressed: () => AccessibilityHelper.provideTapFeedback(),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AccessibleCustomButton(
                    text: '中程度フィードバック',
                    onPressed: () => AccessibilityHelper.provideSelectionFeedback(),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AccessibleCustomButton(
                    text: '強いフィードバック',
                    onPressed: () => AccessibilityHelper.provideErrorFeedback(),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Progress announcement test
            AccessibleCourseNode(
              title: 'テストレッスン',
              progress: 0.6,
              onTap: () {
                AccessibilityHelper.announceMessage(
                  context,
                  'テストレッスンが60%完了しています',
                );
              },
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Form field test
            AccessibleFormField(
              label: 'テスト入力',
              hint: 'アクセシビリティ対応の入力フィールド',
              isRequired: true,
              controller: TextEditingController(),
            ),
            
            SizedBox(height: AppSpacing.lg),
            
            // Accessibility info display
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('アクセシビリティ設定', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: AppSpacing.sm),
                    Text('高コントラスト: ${AccessibilityHelper.isHighContrastMode(context) ? "有効" : "無効"}'),
                    Text('モーション軽減: ${AccessibilityHelper.isReducedMotionEnabled(context) ? "有効" : "無効"}'),
                    Text('テキストスケール: ${AccessibilityHelper.getAccessibleTextScaleFactor(context).toStringAsFixed(1)}x'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Best Practices

### **1. Always Use Minimum Tap Targets**
```dart
// ✅ Good - ensures minimum 48dp tap target
final minSize = AccessibilityHelper.getMinimumTapTargetSize(originalSize);

// ❌ Bad - may be too small for accessibility
Container(width: 20, height: 20, child: GestureDetector(...))
```

### **2. Provide Meaningful Semantic Labels**
```dart
// ✅ Good - descriptive Japanese labels
Semantics(
  label: 'ログインボタン',
  hint: 'タップしてアカウントにログインします',
  child: button,
)

// ❌ Bad - generic or missing labels
Semantics(label: 'Button', child: button)
```

### **3. Use Appropriate Haptic Feedback**
```dart
// ✅ Good - contextual feedback
AccessibilityHelper.provideTapFeedback();        // Light tap
AccessibilityHelper.provideSelectionFeedback();  // Selection/navigation
AccessibilityHelper.provideErrorFeedback();      // Error states

// ❌ Bad - overusing strong feedback
AccessibilityHelper.provideErrorFeedback(); // For every tap
```

### **4. Control Text Scaling**
```dart
// ✅ Good - controlled scaling
fontSize: AccessibilityHelper.getAccessibleTextScaleFactor(context) * 16

// ❌ Bad - no scaling control
fontSize: 16 // Fixed size, may be unreadable
```

### **5. Respect User Preferences**
```dart
// ✅ Good - respect reduced motion
final duration = AccessibilityHelper.getAccessibleAnimationDuration(context);

// ❌ Bad - forced animations
duration: Duration(milliseconds: 500) // Always animated
```

---

## 🧪 Testing Accessibility

### **1. Screen Reader Testing**
- Enable VoiceOver (iOS) or TalkBack (Android)
- Navigate through your app using only the screen reader
- Verify all elements have meaningful labels
- Check that progress and state changes are announced

### **2. Visual Testing**
- Enable high contrast mode
- Test with different text sizes
- Verify minimum tap target sizes
- Check color contrast ratios

### **3. Motor Accessibility Testing**
- Test with switch control
- Verify large tap targets
- Test haptic feedback on supported devices
- Check for easy navigation paths

### **4. Automated Testing**
```dart
// Example accessibility test
testWidgets('Button has minimum tap target size', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  final button = find.byType(AccessibleCustomButton);
  expect(button, findsOneWidget);
  
  final buttonSize = tester.getSize(button);
  expect(buttonSize.width, greaterThanOrEqualTo(48.0));
  expect(buttonSize.height, greaterThanOrEqualTo(48.0));
});
```

---

## 📊 Accessibility Checklist

### **✅ Implementation Checklist**
- [ ] All buttons have minimum 48dp tap targets
- [ ] All interactive elements have semantic labels
- [ ] Text scaling is controlled (0.8x - 2.0x)
- [ ] Haptic feedback is provided for interactions
- [ ] High contrast mode is detected
- [ ] Reduced motion preferences are respected
- [ ] Progress announcements work in Japanese
- [ ] Form fields have proper semantics
- [ ] Error messages are accessible
- [ ] Loading states are announced

### **✅ Testing Checklist**
- [ ] Screen reader navigation works
- [ ] All text is readable at maximum scale
- [ ] Buttons are tappable at minimum size
- [ ] Color contrast meets WCAG AA standards
- [ ] Animations respect reduced motion
- [ ] Haptic feedback works on supported devices
- [ ] Japanese announcements are clear
- [ ] Form validation is accessible

---

## 🔧 Advanced Customization

### **Custom Accessibility Configurations**

```dart
// Create custom accessibility configuration
class CustomAccessibilityConfig {
  static const double customMinTapTarget = 56.0; // Larger than default
  static const double maxTextScale = 1.8; // More conservative than default
  
  static Size getCustomTapTarget(Size original) {
    return Size(
      original.width < customMinTapTarget ? customMinTapTarget : original.width,
      original.height < customMinTapTarget ? customMinTapTarget : original.height,
    );
  }
  
  static double getCustomTextScale(BuildContext context) {
    final scale = MediaQuery.of(context).textScaler.scale(1.0);
    return scale.clamp(0.9, maxTextScale);
  }
}
```

---

## 📞 Support

For questions about AccessibilityHelper implementation:
1. Check this usage guide first
2. Review the AccessibilityHelper source code in `lib/utils/accessibility_helper.dart`
3. Test with the provided examples
4. Use the AccessibilityTestView for comprehensive testing
5. Refer to Phase 3 Optimization Report for implementation details

---

**Remember**: Accessibility is not just about compliance—it's about creating an inclusive experience for all users. The AccessibilityHelper makes it easy to implement these features consistently throughout your app.