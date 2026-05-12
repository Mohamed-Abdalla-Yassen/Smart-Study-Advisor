// theme.ts
import { TextStyle } from 'react-native';

export const AppColors = {
  // Core palette
  obsidian: '#080C14',
  deepNavy: '#0D1321',
  surface: '#111827',
  surfaceElevated: '#1A2236',
  border: '#1E2D45',

  // Accent
  teal: '#00E5CC',
  tealDim: '#00B09A',
  // React Native supports 8-digit hex for alpha (0x33 is 20% opacity)
  tealGlow: '#00E5CC33', 
  tealSoft: '#0D3D37',

  // AI mode accent
  amber: '#FFB830',
  amberGlow: '#FFB83033',
  amberSoft: '#2D2008',

  // Text
  textPrimary: '#E8EDF5',
  textSecondary: '#8A9BB5',
  textMuted: '#4A5568',

  // Status
  success: '#10D68A',
  error: '#FF4D6A',
  warning: '#FFB830',
};

export const AppTypography = {
  displayLarge: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 48,
    fontWeight: '800',
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
  } as TextStyle,

  displayMedium: {
    fontFamily: 'Syne-Bold',
    fontSize: 36,
    fontWeight: '700',
    color: AppColors.textPrimary,
    letterSpacing: -1,
  } as TextStyle,

  displaySmall: {
    fontFamily: 'Syne-Bold',
    fontSize: 28,
    fontWeight: '700',
    color: AppColors.textPrimary,
  } as TextStyle,

  headlineMedium: {
    fontFamily: 'Syne-SemiBold',
    fontSize: 22,
    fontWeight: '600',
    color: AppColors.textPrimary,
  } as TextStyle,

  bodyLarge: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 16,
    color: AppColors.textPrimary,
    lineHeight: 25.6, // 16 * 1.6
  } as TextStyle,

  bodyMedium: {
    fontFamily: 'SpaceGrotesk-Regular',
    fontSize: 14,
    color: AppColors.textSecondary,
    lineHeight: 21, // 14 * 1.5
  } as TextStyle,

  labelLarge: {
    fontFamily: 'SpaceGrotesk-SemiBold',
    fontSize: 13,
    fontWeight: '600',
    letterSpacing: 1.2,
    color: AppColors.teal,
  } as TextStyle,
};

export const AppTheme = {
  dark: {
    dark: true,
    colors: {
      ...AppColors,
      background: AppColors.obsidian,
      primary: AppColors.teal,
      secondary: AppColors.amber,
      // mapping 'surface' directly from AppColors
    },
    typography: AppTypography,
  },
};