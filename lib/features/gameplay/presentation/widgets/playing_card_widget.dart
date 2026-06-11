import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlayingCardWidget extends StatelessWidget {
  final String cardCode;
  final double width;
  final double height;
  final bool isPlayable;

  const PlayingCardWidget({
    super.key,
    required this.cardCode,
    this.width = 68,
    this.height = 100,
    this.isPlayable = true,
  });

  @override
  Widget build(BuildContext context) {
    // Parse suit and rank
    final suit = cardCode.substring(cardCode.length - 1).toUpperCase();
    final rank = cardCode.substring(0, cardCode.length - 1).toUpperCase();

    // Map suit details
    final String suitSymbol;
    final Color suitColor;
    final List<Color> cardGradient;

    switch (suit) {
      case 'S': // Spades
        suitSymbol = '♠';
        suitColor = const Color(0xFF38B6FF); // Neon Blue
        cardGradient = [
          const Color(0xFF1E3A8A).withValues(alpha: 0.8),
          const Color(0xFF0F172A).withValues(alpha: 0.9),
        ];
        break;
      case 'H': // Hearts
        suitSymbol = '♥';
        suitColor = const Color(0xFFFF4D4D); // Neon Red
        cardGradient = [
          const Color(0xFF7F1D1D).withValues(alpha: 0.8),
          const Color(0xFF0F172A).withValues(alpha: 0.9),
        ];
        break;
      case 'D': // Diamonds
        suitSymbol = '♦';
        suitColor = const Color(0xFFFFB300); // Neon Gold/Amber
        cardGradient = [
          const Color(0xFF78350F).withValues(alpha: 0.8),
          const Color(0xFF0F172A).withValues(alpha: 0.9),
        ];
        break;
      case 'C': // Clubs
        suitSymbol = '♣';
        suitColor = const Color(0xFF10B981); // Neon Green
        cardGradient = [
          const Color(0xFF065F46).withValues(alpha: 0.8),
          const Color(0xFF0F172A).withValues(alpha: 0.9),
        ];
        break;
      default:
        suitSymbol = '?';
        suitColor = Colors.white;
        cardGradient = [
          const Color(0xFF334155).withValues(alpha: 0.8),
          const Color(0xFF0F172A).withValues(alpha: 0.9),
        ];
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradient,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: suitColor.withValues(alpha: isPlayable ? 0.6 : 0.2),
          width: isPlayable ? 1.5 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: suitColor.withValues(alpha: isPlayable ? 0.25 : 0.05),
            blurRadius: isPlayable ? 8.0 : 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner Rank & Suit (Top Left)
          Positioned(
            top: 6,
            left: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rank,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white.withValues(alpha: isPlayable ? 1.0 : 0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.22,
                    height: 1.0,
                  ),
                ),
                Text(
                  suitSymbol,
                  style: TextStyle(
                    color: suitColor.withValues(alpha: isPlayable ? 1.0 : 0.5),
                    fontSize: width * 0.20,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Center Giant Suit symbol
          Center(
            child: Opacity(
              opacity: isPlayable ? 0.85 : 0.35,
              child: Text(
                suitSymbol,
                style: TextStyle(
                  color: suitColor,
                  fontSize: width * 0.45,
                  shadows: [
                    Shadow(
                      color: suitColor.withValues(alpha: 0.5),
                      blurRadius: 12.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Corner Rank & Suit (Bottom Right - Rotated 180 degrees)
          Positioned(
            bottom: 6,
            right: 6,
            child: RotatedBox(
              quarterTurns: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rank,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white.withValues(alpha: isPlayable ? 1.0 : 0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.22,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    suitSymbol,
                    style: TextStyle(
                      color: suitColor.withValues(alpha: isPlayable ? 1.0 : 0.5),
                      fontSize: width * 0.20,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
