import 'package:flutter/material.dart';

class RetroCameraTheme {
  static const Color backgroundColor = Color(0xFF292929);
  static const Color primaryText = Color(0xFFE0E0E0);
  static const Color primaryIcon = Color(0xFF6C6C6C);
  static const Color secondaryText = Color(0xFFB0B0B0);
  static const Color accentColor = Color(0xFFFF4D4D);
  static const Color metallic = Color(0xFF404040);
  static const Color metallicLight = Color(0xFF606060);




  
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: primaryText),
        bodyMedium: TextStyle(color: secondaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: metallic,
          foregroundColor: primaryText,
          elevation: 4,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  static BoxDecoration get metallicDecoration {
    return BoxDecoration(
      color: metallic,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: metallicLight, width: 1),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          metallicLight.withOpacity(0.5),
          metallic,
        ],
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black38,
          offset: Offset(2, 2),
          blurRadius: 4,
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Colors.black26,
          offset: Offset(-1, -1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration get displayDecoration {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: metallicLight, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(1, 1),
          blurRadius: 2,
        ),
      ],
    );
  }

  static ButtonStyle get modeButtonStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: metallic,
      foregroundColor: primaryText,
      elevation: 4,
      shadowColor: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: metallicLight, width: 1),
      ),
    ).copyWith(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return metallicLight.withOpacity(0.3);
          }
          return null;
        },
      ),
    );
  }

  static BoxDecoration get viewfinderDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white24, width: 0),
      color: Colors.black,
      // boxShadow: const [
      //   BoxShadow(
      //     color: Colors.black45,
      //     offset: Offset(0, 2),
      //     blurRadius: 4,
      //   ),
      // ],
    );
  }
}