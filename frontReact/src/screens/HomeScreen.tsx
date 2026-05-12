// HomeScreen.tsx
import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Dimensions,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Svg, { Line, Circle, Defs, RadialGradient, Stop } from 'react-native-svg';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

import { AppColors, AppTypography } from '../theme/theme';
import { GlowCard, NeonButton, ChipTag, SectionLabel } from '../widgets/widgets';
import FadeIn from '../components/FadeIn';

type RootStackParamList = {
  Home: undefined;
  Advisor: { mode: 'ai' | 'logic' };
};

type NavigationProp = NativeStackNavigationProp<RootStackParamList, 'Home'>;

export const HomeScreen: React.FC = () => {
  const [selectedMode, setSelectedMode] = useState<'ai' | 'logic' | null>(null);
  const navigation = useNavigation<NavigationProp>();

  return (
    <View style={styles.container}>
      <BackgroundGrid />
      <SafeAreaView style={styles.safeArea} edges={['top', 'bottom']}>
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
        >
          {/* Badge */}
          <FadeIn delay={100} fromY={-16}>
            <View style={styles.badge}>
              <View style={styles.badgeDot} />
              <Text style={styles.badgeText}>Version 1.0</Text>
            </View>
          </FadeIn>

          {/* Title */}
          <FadeIn delay={200} fromY={-16}>
            <Text style={styles.titleText}>
              Smart{'\n'}
              <Text style={styles.titleHighlight}>Study Advisor</Text>
            </Text>
          </FadeIn>

          {/* Subtitle */}
          <FadeIn delay={350}>
            <Text style={styles.subtitle}>
              Intelligent course recommendations powered by{'\n'}
              AI and logic programming paradigms.
            </Text>
          </FadeIn>

          <View style={styles.spacerLarge} />

          <SectionLabel text="Choose your advisor mode" />
          <View style={styles.spacerSmall} />

          {/* AI Mode card */}
          <FadeIn delay={450} fromX={24}>
            <ModeCard
              isSelected={selectedMode === 'ai'}
              mode="ai"
              icon="sparkles"
              title="AI Advisor"
              subtitle="Powered by Gemini via Django"
              description="Uses large language models to reason about your academic profile and generate personalized recommendations."
              accentColor={AppColors.amber}
              tags={['Gemini API', 'Natural Language', 'Contextual']}
              onTap={() => setSelectedMode('ai')}
            />
          </FadeIn>

          <View style={styles.spacerMedium} />

          {/* Logic Mode card */}
          <FadeIn delay={550} fromX={24}>
            <ModeCard
              isSelected={selectedMode === 'logic'}
              mode="logic"
              icon="git-network"
              title="Logic Advisor"
              subtitle="Prolog inference via Django"
              description="Uses formal logical rules and Prolog inference to deduce the best courses based on prerequisites and preferences."
              accentColor={AppColors.teal}
              tags={['Prolog Engine', 'Rule-Based', 'Deterministic']}
              onTap={() => setSelectedMode('logic')}
            />
          </FadeIn>

          <View style={styles.spacerLarge} />

          {/* Architecture diagram */}
          <FadeIn delay={650} fromY={16}>
            <ArchitectureDiagram mode={selectedMode} />
          </FadeIn>

          <View style={styles.spacerLarge} />

          {/* CTA button */}
          <FadeIn delay={700}>
            <NeonButton
              label="Get Recommendations"
              icon="arrow-forward"
              fullWidth
              color={selectedMode === 'ai' ? AppColors.amber : AppColors.teal}
              onPressed={
                selectedMode
                  ? () => navigation.navigate('Advisor', { mode: selectedMode })
                  : undefined
              }
            />
          </FadeIn>

          <View style={styles.spacerLarge} />
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};

// ── Components ────────────────────────────────────────────────

interface ModeCardProps {
  isSelected: boolean;
  mode: 'ai' | 'logic';
  icon: keyof typeof Ionicons.glyphMap;
  title: string;
  subtitle: string;
  description: string;
  accentColor: string;
  tags: string[];
  onTap: () => void;
}

const ModeCard: React.FC<ModeCardProps> = ({
  isSelected,
  icon,
  title,
  subtitle,
  description,
  accentColor,
  tags,
  onTap,
}) => {
  return (
    <GlowCard glowColor={accentColor} isSelected={isSelected} onTap={onTap}>
      <View style={styles.cardRow}>
        <View
          style={[
            styles.cardIconBox,
            {
              backgroundColor: `${accentColor}1F`,
              borderColor: `${accentColor}4D`,
            },
          ]}
        >
          <Ionicons name={icon} color={accentColor} size={22} />
        </View>

        <View style={styles.cardContent}>
          <View style={styles.cardHeaderRow}>
            <Text style={styles.cardTitle}>{title}</Text>
            {isSelected && (
              <Ionicons name="checkmark-circle" color={accentColor} size={18} />
            )}
          </View>

          <Text style={[styles.cardSubtitle, { color: accentColor }]}>
            {subtitle}
          </Text>

          <Text style={styles.cardDescription}>{description}</Text>

          <View style={styles.tagsContainer}>
            {tags.map((t) => (
              <ChipTag key={t} label={t} color={accentColor} />
            ))}
          </View>
        </View>
      </View>
    </GlowCard>
  );
};

const ArchitectureDiagram: React.FC<{ mode: 'ai' | 'logic' | null }> = ({ mode }) => {
  const color = mode === 'ai' ? AppColors.amber : AppColors.teal;
  const steps =
    mode === 'ai'
      ? ['React Native', 'Django REST', 'Gemini API', 'Response']
      : ['React Native', 'Django REST', 'Prolog Engine', 'Response'];

  return (
    <View>
      <SectionLabel text="System Pipeline" />
      <View style={styles.spacerSmall} />
      <View style={styles.diagramContainer}>
        {steps.map((step, idx) => {
          const isFirst = idx === 0;
          const isLast = idx === steps.length - 1;
          return (
            <React.Fragment key={step}>
              <PipelineStep label={step} color={color} isFirst={isFirst} isLast={isLast} />
              {!isLast && (
                <Ionicons name="chevron-forward" color={`${color}80`} size={20} />
              )}
            </React.Fragment>
          );
        })}
      </View>
    </View>
  );
};

const PipelineStep: React.FC<{
  label: string;
  color: string;
  isFirst: boolean;
  isLast: boolean;
}> = ({ label, color, isFirst, isLast }) => {
  const isHighlight = isFirst || isLast;
  return (
    <View style={styles.stepContainer}>
      <View
        style={[
          styles.stepIconBox,
          {
            backgroundColor: isHighlight ? `${color}33` : AppColors.surfaceElevated,
            borderColor: isHighlight ? color : AppColors.border,
            borderWidth: isFirst ? 2 : 1,
          },
        ]}
      >
        <Ionicons
          name={isFirst ? 'phone-portrait-outline' : isLast ? 'checkmark-outline' : 'git-merge-outline'}
          color={isHighlight ? color : AppColors.textSecondary}
          size={16}
        />
      </View>
      <Text style={[styles.stepLabel, { color: isHighlight ? color : AppColors.textSecondary }]}>
        {label}
      </Text>
    </View>
  );
};

const BackgroundGrid: React.FC = () => {
  const { width, height } = Dimensions.get('window');
  const spacing = 40;
  const verticalLines = Array.from({ length: Math.ceil(width / spacing) });
  const horizontalLines = Array.from({ length: Math.ceil(height / spacing) });

  return (
    <View style={StyleSheet.absoluteFill} pointerEvents="none">
      <Svg width={width} height={height}>
        <Defs>
          <RadialGradient id="glow" cx="100%" cy="0%" r="60%">
            <Stop offset="0%" stopColor={AppColors.teal} stopOpacity="0.08" />
            <Stop offset="100%" stopColor={AppColors.teal} stopOpacity="0" />
          </RadialGradient>
        </Defs>
        {verticalLines.map((_, i) => (
          <Line key={`v-${i}`} x1={i * spacing} y1={0} x2={i * spacing} y2={height} stroke={`${AppColors.border}66`} strokeWidth={0.5} />
        ))}
        {horizontalLines.map((_, i) => (
          <Line key={`h-${i}`} x1={0} y1={i * spacing} x2={width} y2={i * spacing} stroke={`${AppColors.border}66`} strokeWidth={0.5} />
        ))}
        <Circle cx={width} cy={0} r={width * 0.6} fill="url(#glow)" />
      </Svg>
    </View>
  );
};

// ── Styles ────────────────────────────────────────────────────

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: AppColors.obsidian },
  safeArea: { flex: 1 },
  scrollContent: { paddingHorizontal: 24, paddingTop: 48, paddingBottom: 48 },
  badge: {
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
    backgroundColor: AppColors.tealSoft,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: `${AppColors.teal}66`,
    marginBottom: 24,
  },
  badgeDot: { width: 6, height: 6, borderRadius: 3, backgroundColor: AppColors.teal, marginRight: 8 },
  badgeText: { fontFamily: 'SpaceGrotesk-SemiBold', fontSize: 11, fontWeight: '600', letterSpacing: 1.2, color: AppColors.teal },
  titleText: { ...AppTypography.displayLarge, fontSize: 52, lineHeight: 52 * 1.05, letterSpacing: -2 },
  titleHighlight: { color: AppColors.teal },
  subtitle: { ...AppTypography.bodyLarge, fontSize: 15, lineHeight: 15 * 1.6, color: AppColors.textSecondary, marginTop: 16 },
  cardRow: { flexDirection: 'row' },
  cardIconBox: { width: 48, height: 48, borderRadius: 12, borderWidth: 1, justifyContent: 'center', alignItems: 'center', marginRight: 16 },
  cardContent: { flex: 1 },
  cardHeaderRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 2 },
  cardTitle: { fontFamily: 'Syne-Bold', fontSize: 17, fontWeight: '700', color: AppColors.textPrimary },
  cardSubtitle: { fontSize: 12, fontWeight: '600', letterSpacing: 0.5, marginBottom: 10 },
  cardDescription: { fontSize: 13, color: AppColors.textSecondary, lineHeight: 13 * 1.5, marginBottom: 12 },
  tagsContainer: { flexDirection: 'row', flexWrap: 'wrap', gap: 6 },
  diagramContainer: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', backgroundColor: AppColors.surface, padding: 20, borderRadius: 16, borderWidth: 1, borderColor: AppColors.border },
  stepContainer: { alignItems: 'center', width: 60 },
  stepIconBox: { width: 36, height: 36, borderRadius: 18, justifyContent: 'center', alignItems: 'center', marginBottom: 6 },
  stepLabel: { fontSize: 10, fontWeight: '600', textAlign: 'center', lineHeight: 13 },
  spacerSmall: { height: 16 },
  spacerMedium: { height: 24 },
  spacerLarge: { height: 40 },
});