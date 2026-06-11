import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/models/game_data_models.dart';
import '../providers/gameplay_providers.dart';

class OfflineSetupScreen extends ConsumerStatefulWidget {
  const OfflineSetupScreen({super.key});

  @override
  ConsumerState<OfflineSetupScreen> createState() => _OfflineSetupScreenState();
}

class _OfflineSetupScreenState extends ConsumerState<OfflineSetupScreen> {
  int _botCount = 3; // 3 bots + 1 human = 4 players
  final List<BotPlayerModel> _bots = [];

  @override
  void initState() {
    super.initState();
    _generateBots();
  }

  void _generateBots() {
    _bots.clear();
    final random = Random();
    
    for (var i = 1; i <= _botCount; i++) {
      final personality = BotPersonality.values[random.nextInt(BotPersonality.values.length)];
      final difficulty = _difficultyForPersonality(personality);
      
      _bots.add(BotPlayerModel(
        userId: i * 100, // Dummy ID
        name: 'Bot $i (${personality.name})',
        difficulty: difficulty,
        personality: personality,
      ));
    }
  }

  BotDifficulty _difficultyForPersonality(BotPersonality personality) {
    switch (personality) {
      case BotPersonality.beginner:
        return BotDifficulty.easy;
      case BotPersonality.conservative:
      case BotPersonality.aggressive:
      case BotPersonality.smart:
      case BotPersonality.trickHunter:
      case BotPersonality.escapeArtist:
        return BotDifficulty.medium;
      case BotPersonality.adaptive:
      case BotPersonality.master:
        return BotDifficulty.hard;
    }
  }

  void _updateBotCount(int delta) {
    setState(() {
      _botCount = (_botCount + delta).clamp(1, 7);
      _generateBots();
    });
  }

  void _startMatch() {
    ref.read(offlineBotsProvider.notifier).state = _bots;
    context.push('/game/-1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Offline Mode Setup', style: AppTextStyles.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bot Count Selector inside GlassCard
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Select Number of Bots',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCountButton(Icons.remove, () => _updateBotCount(-1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text(
                            '$_botCount',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildCountButton(Icons.add, () => _updateBotCount(1)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Total Players: ${_botCount + 1}',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: -0.1),

              const SizedBox(height: 32),
              
              Text(
                'Bot Personalities',
                style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
              ).animate().fade(duration: 500.ms).slideX(begin: -0.1),
              
              const SizedBox(height: 16),
              
              // Bot List
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _bots.length,
                  itemBuilder: (context, index) {
                    final bot = _bots[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        borderColor: _getColorForDifficulty(bot.difficulty).withValues(alpha: 0.3),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getColorForDifficulty(bot.difficulty).withValues(alpha: 0.2),
                                border: Border.all(
                                  color: _getColorForDifficulty(bot.difficulty).withValues(alpha: 0.5),
                                ),
                              ),
                              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bot.name,
                                    style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Difficulty: ${bot.difficulty.name.toUpperCase()}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: _getColorForDifficulty(bot.difficulty),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.shuffle_rounded, color: AppColors.primary),
                              tooltip: 'Randomize Personality',
                              onPressed: () {
                                setState(() {
                                  final random = Random();
                                  final newPersonality = BotPersonality.values[random.nextInt(BotPersonality.values.length)];
                                  _bots[index] = BotPlayerModel(
                                    userId: bot.userId,
                                    name: 'Bot ${index + 1} (${newPersonality.name})',
                                    difficulty: _difficultyForPersonality(newPersonality),
                                    personality: newPersonality,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.1),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Start Match Button
              GestureDetector(
                onTap: _startMatch,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'START MATCH',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ).animate().fade(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  Color _getColorForDifficulty(BotDifficulty diff) {
    switch (diff) {
      case BotDifficulty.easy: return Colors.greenAccent;
      case BotDifficulty.medium: return AppColors.gold;
      case BotDifficulty.hard: return AppColors.error;
    }
  }
}
