// widgets.tsx
import React, { useRef } from 'react';
import {
  View,
  Text,
  Pressable,
  Animated,
  ActivityIndicator,
  StyleSheet,
  ViewStyle,
  StyleProp,
} from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { AppColors } from '../theme/theme';

// ── Helpers ───────────────────────────────────────────────────
/**
 * Appends a hex alpha value to a standard 6-character hex color.
 * e.g., addAlpha('#00E5CC', 0.25) -> '#00E5CC40'
 */
const addAlpha = (hex: string, opacity: number): string => {
  const alpha = Math.round(opacity * 255).toString(16).padStart(2, '0').toUpperCase();
  return `${hex}${alpha}`;
};

// ─────────────────────────────────────────────────────────────
// GlowCard

export interface GlowCardProps {
  children: React.ReactNode;
  glowColor?: string;
  padding?: number;
  onTap?: () => void;
  isSelected?: boolean;
  style?: StyleProp<ViewStyle>;
}

export const GlowCard: React.FC<GlowCardProps> = ({
  children,
  glowColor = AppColors.teal,
  padding = 20,
  onTap,
  isSelected = false,
  style,
}) => {
  const containerStyle: ViewStyle = {
    padding,
    borderColor: isSelected ? glowColor : AppColors.border,
    borderWidth: isSelected ? 1.5 : 1,
    backgroundColor: AppColors.surfaceElevated,
    shadowColor: isSelected ? glowColor : '#000000',
    shadowOffset: isSelected ? { width: 0, height: 0 } : { width: 0, height: 4 },
    shadowOpacity: isSelected ? 0.25 : 0.3,
    shadowRadius: isSelected ? 24 : 8,
    elevation: isSelected ? 10 : 4, // Android shadow
  };

  return (
    <Pressable
      onPress={onTap}
      disabled={!onTap}
      style={({ pressed }) => [
        styles.glowCardBase,
        containerStyle,
        pressed && onTap && { opacity: 0.9 }, // Slight feedback for touch
        style,
      ]}
    >
      {children}
    </Pressable>
  );
};

// ─────────────────────────────────────────────────────────────
// NeonButton

export interface NeonButtonProps {
  label: string;
  onPressed?: () => void;
  color?: string;
  icon?: keyof typeof Ionicons.glyphMap;
  isLoading?: boolean;
  fullWidth?: boolean;
}

export const NeonButton: React.FC<NeonButtonProps> = ({
  label,
  onPressed,
  color = AppColors.teal,
  icon,
  isLoading = false,
  fullWidth = false,
}) => {
  const scale = useRef(new Animated.Value(1)).current;

  const handlePressIn = () => {
    if (!onPressed || isLoading) return;
    Animated.timing(scale, {
      toValue: 0.95,
      duration: 100,
      useNativeDriver: true,
    }).start();
  };

  const handlePressOut = () => {
    if (!onPressed || isLoading) return;
    Animated.timing(scale, {
      toValue: 1,
      duration: 100,
      useNativeDriver: true,
    }).start();
  };

  return (
    <Pressable
      onPress={onPressed}
      onPressIn={handlePressIn}
      onPressOut={handlePressOut}
      disabled={!onPressed || isLoading}
      style={[fullWidth ? { width: '100%' } : { alignSelf: 'flex-start' }]}
    >
      <Animated.View style={{ transform: [{ scale }] }}>
        <LinearGradient
          colors={[color, addAlpha(color, 0.75)]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 1 }}
          style={[
            styles.neonButtonGradient,
            !!onPressed && {
              shadowColor: color,
              shadowOffset: { width: 0, height: 0 },
              shadowOpacity: 0.4,
              shadowRadius: 20,
              elevation: 8,
            },
          ]}
        >
          {isLoading ? (
            <ActivityIndicator size="small" color={AppColors.obsidian} />
          ) : (
            <View style={styles.neonButtonContent}>
              {icon && (
                <Ionicons
                  name={icon}
                  size={18}
                  color={AppColors.obsidian}
                  style={styles.neonButtonIcon}
                />
              )}
              <Text style={styles.neonButtonText}>{label.toUpperCase()}</Text>
            </View>
          )}
        </LinearGradient>
      </Animated.View>
    </Pressable>
  );
};

// ─────────────────────────────────────────────────────────────
// ChipTag

export interface ChipTagProps {
  label: string;
  color?: string;
  onRemove?: () => void;
}

export const ChipTag: React.FC<ChipTagProps> = ({
  label,
  color = AppColors.teal,
  onRemove,
}) => {
  return (
    <View
      style={[
        styles.chipTagContainer,
        {
          backgroundColor: addAlpha(color, 0.12),
          borderColor: addAlpha(color, 0.35),
        },
      ]}
    >
      <Text style={[styles.chipTagText, { color }]}>{label}</Text>
      {onRemove && (
        <Pressable onPress={onRemove} hitSlop={10} style={styles.chipTagClose}>
          <Ionicons name="close" size={14} color={color} />
        </Pressable>
      )}
    </View>
  );
};

// ─────────────────────────────────────────────────────────────
// DifficultyBadge

export interface DifficultyBadgeProps {
  difficulty: string;
}

export const DifficultyBadge: React.FC<DifficultyBadgeProps> = ({ difficulty }) => {
  const getBadgeConfig = () => {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.amber;
    }
  };

  const color = getBadgeConfig();
  const label = difficulty.charAt(0).toUpperCase() + difficulty.slice(1);

  return (
    <View
      style={[
        styles.difficultyBadgeContainer,
        {
          backgroundColor: addAlpha(color, 0.15),
          borderColor: addAlpha(color, 0.4),
        },
      ]}
    >
      <Text style={[styles.difficultyBadgeText, { color }]}>{label}</Text>
    </View>
  );
};

// ─────────────────────────────────────────────────────────────
// SectionLabel

export interface SectionLabelProps {
  text: string;
}

export const SectionLabel: React.FC<SectionLabelProps> = ({ text }) => {
  return (
    <View style={styles.sectionLabelContainer}>
      <View style={styles.sectionLabelLine} />
      <Text style={styles.sectionLabelText}>{text.toUpperCase()}</Text>
    </View>
  );
};

// ── Styles ────────────────────────────────────────────────────

const styles = StyleSheet.create({
  // GlowCard
  glowCardBase: {
    borderRadius: 16,
    overflow: 'visible', // Required for iOS shadow
  },
  
  // NeonButton
  neonButtonGradient: {
    height: 54,
    paddingHorizontal: 28,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  neonButtonContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  neonButtonIcon: {
    marginRight: 8,
  },
  neonButtonText: {
    fontFamily: 'SpaceGrotesk-Bold', // Ensure this matches your linked fonts
    fontSize: 13,
    fontWeight: '700',
    letterSpacing: 1.4,
    color: AppColors.obsidian,
  },

  // ChipTag
  chipTagContainer: {
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
    borderWidth: 1,
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
  },
  chipTagText: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 12,
    fontWeight: '600',
  },
  chipTagClose: {
    marginLeft: 6,
  },

  // DifficultyBadge
  difficultyBadgeContainer: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 6,
    borderWidth: 1,
    alignSelf: 'flex-start',
  },
  difficultyBadgeText: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 0.8,
  },

  // SectionLabel
  sectionLabelContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  sectionLabelLine: {
    width: 3,
    height: 14,
    backgroundColor: AppColors.teal,
    borderRadius: 2,
    marginRight: 8,
  },
  sectionLabelText: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 2,
    color: AppColors.textSecondary,
  },
});
