# DESIGN SYSTEM
## Project: [Project Name]
## Version: 1.0

---

# CRITICAL: READ BEFORE GENERATING ANY UI

Every screen, widget, and component MUST use ONLY the values defined in this document.
DO NOT invent colors, spacing, fonts, or styles.
If something is not defined here, ASK before generating.

---

# 1. COLORS

## Brand Colors

```dart
// Primary
static const Color primary = Color(0xFF2563EB);        // Main brand color
static const Color primaryLight = Color(0xFF3B82F6);   // Hover/Light variant
static const Color primaryDark = Color(0xFF1D4ED8);    // Pressed/Dark variant

// Secondary
static const Color secondary = Color(0xFF7C3AED);      // Accent color
static const Color secondaryLight = Color(0xFF8B5CF6);
static const Color secondaryDark = Color(0xFF6D28D9);
```

## Neutral Colors

```dart
// Backgrounds
static const Color backgroundPrimary = Color(0xFFFFFFFF);   // Main background
static const Color backgroundSecondary = Color(0xFFF8FAFC); // Card background
static const Color backgroundTertiary = Color(0xFFF1F5F9);  // Disabled/Muted

// Text
static const Color textPrimary = Color(0xFF0F172A);     // Main text
static const Color textSecondary = Color(0xFF475569);   // Subtitle/Caption
static const Color textTertiary = Color(0xFF94A3B8);    // Placeholder/Disabled
static const Color textInverse = Color(0xFFFFFFFF);     // Text on dark background

// Borders
static const Color borderLight = Color(0xFFE2E8F0);     // Default border
static const Color borderMedium = Color(0xFFCBD5E1);    // Input border
static const Color borderDark = Color(0xFF94A3B8);      // Active border
```

## Semantic Colors

```dart
// Status
static const Color success = Color(0xFF22C55E);         // Success states
static const Color successLight = Color(0xFFDCFCE7);    // Success background
static const Color error = Color(0xFFEF4444);           // Error states
static const Color errorLight = Color(0xFFFEE2E2);      // Error background
static const Color warning = Color(0xFFF59E0B);         // Warning states
static const Color warningLight = Color(0xFFFEF3C7);    // Warning background
static const Color info = Color(0xFF3B82F6);            // Info states
static const Color infoLight = Color(0xFFDBEAFE);       // Info background
```

## USAGE RULES

| Context | Color to Use |
|---------|--------------|
| Primary buttons | `primary` |
| Secondary buttons | `backgroundSecondary` with `primary` text |
| Text buttons | `primary` (text only) |
| Screen background | `backgroundPrimary` |
| Card background | `backgroundSecondary` |
| Main text | `textPrimary` |
| Subtitles | `textSecondary` |
| Placeholders | `textTertiary` |
| Input borders (default) | `borderLight` |
| Input borders (focused) | `primary` |
| Error messages | `error` |
| Success messages | `success` |

---

# 2. TYPOGRAPHY

## Font Family

```dart
static const String fontFamily = 'Inter';
// Fallback: 'SF Pro Display', 'Roboto', sans-serif
```

## Font Sizes

```dart
// Display
static const double displayLarge = 32.0;    // Hero text, splash screens
static const double displayMedium = 28.0;   // Page titles

// Headings
static const double headingLarge = 24.0;    // Section headers
static const double headingMedium = 20.0;   // Card titles
static const double headingSmall = 18.0;    // Subsection headers

// Body
static const double bodyLarge = 16.0;       // Main content
static const double bodyMedium = 14.0;      // Secondary content
static const double bodySmall = 12.0;       // Captions, labels

// Micro
static const double micro = 10.0;           // Badges, tags
```

## Font Weights

```dart
static const FontWeight regular = FontWeight.w400;
static const FontWeight medium = FontWeight.w500;
static const FontWeight semiBold = FontWeight.w600;
static const FontWeight bold = FontWeight.w700;
```

## Text Styles (Pre-defined)

```dart
// ALWAYS use these. DO NOT create custom TextStyles.

static TextStyle get displayLarge => TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  color: textPrimary,
  height: 1.2,
);

static TextStyle get headingLarge => TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: textPrimary,
  height: 1.3,
);

static TextStyle get headingMedium => TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: textPrimary,
  height: 1.3,
);

static TextStyle get bodyLarge => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: textPrimary,
  height: 1.5,
);

static TextStyle get bodyMedium => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: textSecondary,
  height: 1.5,
);

static TextStyle get bodySmall => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: textTertiary,
  height: 1.4,
);

static TextStyle get buttonText => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: textInverse,
  height: 1.0,
);

static TextStyle get inputText => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: textPrimary,
  height: 1.5,
);

static TextStyle get inputLabel => TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: textSecondary,
  height: 1.4,
);

static TextStyle get inputHint => TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: textTertiary,
  height: 1.5,
);
```

## USAGE RULES

| Context | Style to Use |
|---------|--------------|
| Screen title | `headingLarge` |
| Card title | `headingMedium` |
| Body text | `bodyLarge` |
| Secondary info | `bodyMedium` |
| Captions | `bodySmall` |
| Button text | `buttonText` |
| Input text | `inputText` |
| Input labels | `inputLabel` |
| Placeholder | `inputHint` |

---

# 3. SPACING

## Base Unit

```dart
static const double spacingUnit = 4.0;  // All spacing is multiple of 4
```

## Spacing Scale

```dart
static const double spacing2 = 2.0;     // Micro spacing
static const double spacing4 = 4.0;     // XS
static const double spacing8 = 8.0;     // S
static const double spacing12 = 12.0;   // SM
static const double spacing16 = 16.0;   // M (DEFAULT)
static const double spacing20 = 20.0;   // ML
static const double spacing24 = 24.0;   // L
static const double spacing32 = 32.0;   // XL
static const double spacing40 = 40.0;   // XXL
static const double spacing48 = 48.0;   // XXXL
static const double spacing64 = 64.0;   // Section spacing
```

## USAGE RULES

| Context | Spacing |
|---------|---------|
| Screen horizontal padding | `spacing16` (16px) |
| Screen vertical padding | `spacing24` (24px) |
| Between form fields | `spacing16` (16px) |
| Between sections | `spacing32` (32px) |
| Card internal padding | `spacing16` (16px) |
| Between list items | `spacing12` (12px) |
| Between icon and text | `spacing8` (8px) |
| Between label and input | `spacing8` (8px) |
| Button internal padding | `spacing16` horizontal, `spacing12` vertical |

---

# 4. BORDER RADIUS

```dart
static const double radiusSmall = 4.0;      // Tags, badges
static const double radiusMedium = 8.0;     // Buttons, inputs
static const double radiusLarge = 12.0;     // Cards
static const double radiusXLarge = 16.0;    // Modal, bottom sheets
static const double radiusRound = 999.0;    // Circular (avatars, pills)
```

## USAGE RULES

| Component | Radius |
|-----------|--------|
| Buttons | `radiusMedium` (8px) |
| Input fields | `radiusMedium` (8px) |
| Cards | `radiusLarge` (12px) |
| Bottom sheets | `radiusXLarge` (16px) top only |
| Avatars | `radiusRound` |
| Tags/Badges | `radiusSmall` (4px) |
| Dialogs | `radiusLarge` (12px) |

---

# 5. SHADOWS

```dart
// Elevation levels
static List<BoxShadow> get shadowSmall => [
  BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
];

static List<BoxShadow> get shadowMedium => [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  ),
];

static List<BoxShadow> get shadowLarge => [
  BoxShadow(
    color: Color(0x14000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  ),
];
```

## USAGE RULES

| Component | Shadow |
|-----------|--------|
| Cards | `shadowSmall` |
| Dropdowns | `shadowMedium` |
| Modals | `shadowLarge` |
| Floating buttons | `shadowMedium` |
| Bottom navigation | `shadowSmall` |

---

# 6. ICONS

## Icon Library

```dart
// Use: lucide_icons package
// Import: import 'package:lucide_icons/lucide_icons.dart';
```

## Icon Sizes

```dart
static const double iconSmall = 16.0;    // In buttons, inputs
static const double iconMedium = 20.0;   // Default
static const double iconLarge = 24.0;    // Standalone icons
static const double iconXLarge = 32.0;   // Empty states, features
```

## Common Icons (USE THESE EXACTLY)

```dart
// Navigation
static const IconData home = LucideIcons.home;
static const IconData back = LucideIcons.arrowLeft;
static const IconData close = LucideIcons.x;
static const IconData menu = LucideIcons.menu;
static const IconData settings = LucideIcons.settings;

// Actions
static const IconData add = LucideIcons.plus;
static const IconData edit = LucideIcons.pencil;
static const IconData delete = LucideIcons.trash2;
static const IconData search = LucideIcons.search;
static const IconData filter = LucideIcons.filter;
static const IconData share = LucideIcons.share2;

// Status
static const IconData success = LucideIcons.checkCircle;
static const IconData error = LucideIcons.alertCircle;
static const IconData warning = LucideIcons.alertTriangle;
static const IconData info = LucideIcons.info;

// User
static const IconData user = LucideIcons.user;
static const IconData login = LucideIcons.logIn;
static const IconData logout = LucideIcons.logOut;

// Form
static const IconData email = LucideIcons.mail;
static const IconData password = LucideIcons.lock;
static const IconData eyeOpen = LucideIcons.eye;
static const IconData eyeClosed = LucideIcons.eyeOff;
```

---

# 7. COMPONENT PATTERNS

## Primary Button

```dart
// ALWAYS use this exact implementation
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;

  const PrimaryButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          disabledBackgroundColor: AppColors.primaryLight.withOpacity(0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing12,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.textInverse),
                ),
              )
            : Text(text, style: AppTextStyles.buttonText),
      ),
    );
  }
}
```

## Secondary Button

```dart
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing12,
          ),
        ),
        child: Text(text, style: AppTextStyles.buttonText.copyWith(
          color: AppColors.primary,
        )),
      ),
    );
  }
}
```

## Text Input

```dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        SizedBox(height: AppSpacing.spacing8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.inputHint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.backgroundPrimary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing16,
              vertical: AppSpacing.spacing12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
```

## Card

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(AppSpacing.spacing16),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppRadius.large),
          boxShadow: AppShadows.shadowSmall,
        ),
        child: child,
      ),
    );
  }
}
```

---

# 8. SCREEN LAYOUTS

## Standard Screen Template

```dart
class SampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        title: Text('Screen Title', style: AppTextStyles.headingMedium),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(AppIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen content here
            ],
          ),
        ),
      ),
    );
  }
}
```

## Form Screen Template

```dart
class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(...),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
            vertical: AppSpacing.spacing24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('Form Title', style: AppTextStyles.headingLarge),
              SizedBox(height: AppSpacing.spacing8),
              Text('Form description', style: AppTextStyles.bodyMedium),
              SizedBox(height: AppSpacing.spacing32),
              
              // Form fields
              AppTextField(label: 'Field 1', hint: 'Enter value'),
              SizedBox(height: AppSpacing.spacing16),
              AppTextField(label: 'Field 2', hint: 'Enter value'),
              SizedBox(height: AppSpacing.spacing32),
              
              // Submit button
              PrimaryButton(text: 'Submit', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
```

## List Screen Template

```dart
class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(...),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing24,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.spacing12),
        itemBuilder: (context, index) {
          return AppCard(
            child: Row(
              children: [
                // Item content
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(AppIcons.add, color: AppColors.textInverse),
        onPressed: () {},
      ),
    );
  }
}
```

---

# 9. DO's AND DON'Ts

## DO ✅

- Use ONLY colors from this document
- Use ONLY text styles defined here
- Use ONLY spacing values (multiples of 4)
- Use pre-built components (PrimaryButton, AppTextField, etc.)
- Follow screen templates
- Use AppIcons for all icons

## DON'T ❌

- Don't create custom colors (`Color(0xFF...)`)
- Don't create custom TextStyles
- Don't use arbitrary spacing (`padding: 17` or `margin: 23`)
- Don't create new button styles
- Don't use different icon packages
- Don't hardcode any design values

---

# 10. COMPONENT REGISTRY

| Component | File | Use For |
|-----------|------|---------|
| PrimaryButton | `lib/core/widgets/primary_button.dart` | Main actions |
| SecondaryButton | `lib/core/widgets/secondary_button.dart` | Secondary actions |
| TextButton | `lib/core/widgets/text_button.dart` | Tertiary actions |
| AppTextField | `lib/core/widgets/app_text_field.dart` | All text inputs |
| AppCard | `lib/core/widgets/app_card.dart` | Content containers |
| AppDialog | `lib/core/widgets/app_dialog.dart` | Dialogs/Alerts |
| LoadingIndicator | `lib/core/widgets/loading_indicator.dart` | Loading states |
| EmptyState | `lib/core/widgets/empty_state.dart` | Empty lists |
| ErrorState | `lib/core/widgets/error_state.dart` | Error displays |

ALWAYS check if a component exists in this registry before creating new UI.
ALWAYS use existing components instead of creating new ones.
