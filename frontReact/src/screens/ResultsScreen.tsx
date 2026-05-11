// ResultsScreen.tsx
import React, { useState, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Pressable,
  Platform,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Animated, { FadeIn, FadeInDown, FadeInRight } from 'react-native-reanimated';
import { Ionicons } from '@expo/vector-icons';
import Svg, { Defs, RadialGradient, Stop, Circle } from 'react-native-svg';
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';

import { AppColors, AppTypography } from '../theme/theme';
import { GlowCard, SectionLabel } from '../widgets/widgets';
import { CourseResult, StudentForm } from '../models/models';

// Add to your navigation types file if not already present
type RootStackParamList = {
  Home: undefined;
  Advisor: { mode: 'ai' | 'logic' };
  Results: { results: CourseResult[]; form: StudentForm; mode: string; isMock?: boolean };
};

type ResultsScreenNavigationProp = NativeStackNavigationProp<RootStackParamList, 'Results'>;
type ResultsScreenRouteProp = RouteProp<RootStackParamList, 'Results'>;

// Helper to add alpha to hex colors
const addAlpha = (hex: string, opacity: number): string => {
  const alpha = Math.round(opacity * 255).toString(16).padStart(2, '0').toUpperCase();
  return `${hex}${alpha}`;
};

export const ResultsScreen: React.FC = () => {
  const navigation = useNavigation<ResultsScreenNavigationProp>();
  const route = useRoute<ResultsScreenRouteProp>();
  const { results, form, mode, isMock = false } = route.params;

  const [filterTier, setFilterTier] = useState<string>('All');

  const isAI = mode === 'ai';
  const accent = isAI ? AppColors.amber : AppColors.teal;

  // ── Derived Data ────────────────────────────────────────────
  const filtered = useMemo(() => {
    if (filterTier === 'All') return results;
    return results.filter((c) => {
      if (filterTier === 'Low') return c.matchPercentage < 50;
      if (filterTier === 'Tier 1') return c.matchPercentage === 100;
      if (filterTier === 'Tier 2') return c.matchPercentage === 75;
      if (filterTier === 'Tier 3') return c.matchPercentage === 50;
      return true;
    });
  }, [results, filterTier]);

  const counts = useMemo(() => {
    return {
      'All': results.length,
      'Tier 1': results.filter((c) => c.matchPercentage === 100).length,
      'Tier 2': results.filter((c) => c.matchPercentage === 75).length,
      'Tier 3': results.filter((c) => c.matchPercentage === 50).length,
      'Low': results.filter((c) => c.matchPercentage < 50).length,
    };
  }, [results]);

  return (
    <View style={styles.container}>
      {/* Glow Blob */}
      <View style={styles.glowBlobContainer} pointerEvents="none">
        <Svg width={300} height={300}>
          <Defs>
            <RadialGradient id="blobGlow" cx="50%" cy="50%" r="50%">
              <Stop offset="0%" stopColor={accent} stopOpacity="0.07" />
              <Stop offset="100%" stopColor={accent} stopOpacity="0" />
            </RadialGradient>
          </Defs>
          <Circle cx={150} cy={150} r={150} fill="url(#blobGlow)" />
        </Svg>
      </View>

      <SafeAreaView style={styles.safeArea} edges={['top', 'bottom']}>
        {/* ── App bar ────────────────────────────────────────── */}
        <View style={styles.appBar}>
          <Pressable onPress={() => navigation.goBack()} hitSlop={10} style={styles.backButton}>
            <Ionicons name="arrow-back" color={AppColors.textSecondary} size={24} />
          </Pressable>

          {isMock && (
            <View style={styles.mockBadge}>
              <Ionicons name="information-circle-outline" color={AppColors.amber} size={14} style={{ marginRight: 6 }} />
              <Text style={styles.mockBadgeText}>Demo Mode</Text>
            </View>
          )}
        </View>

        <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
          {/* ── Header ─────────────────────────────────────────── */}
          <Animated.View entering={FadeInDown.springify()}>
            <View style={styles.headerRow}>
              <View style={[styles.headerIconBox, { backgroundColor: addAlpha(accent, 0.12), borderColor: addAlpha(accent, 0.3) }]}>
                <Ionicons name={isAI ? 'sparkles' : 'git-network'} color={accent} size={20} />
              </View>
              <View style={styles.headerTextCol}>
                <Text style={styles.headerTitle}>Recommendations</Text>
                <Text style={[styles.headerSubtitle, { color: accent }]}>
                  {form.dept}  ·  {Array.from(form.prefs).join(', ')}
                </Text>
              </View>
            </View>
          </Animated.View>

          <View style={styles.spacerMedium} />

          {/* ── Stats bar ──────────────────────────────────────── */}
          <Animated.View entering={FadeIn.delay(100)}>
            <StatsBar total={results.length} tier1={counts['Tier 1']} dept={form.dept} accent={accent} />
          </Animated.View>

          <View style={styles.spacerMedium} />

          {/* ── Tier filter chips ──────────────────────────────── */}
          <Animated.View entering={FadeIn.delay(150)}>
            <TierFilterRow selected={filterTier} accent={accent} counts={counts} onSelect={setFilterTier} />
          </Animated.View>

          <View style={styles.spacerLarge} />

          {/* ── Results list ───────────────────────────────────── */}
          {filtered.length === 0 ? (
            <Animated.View entering={FadeIn.delay(200)}>
              <EmptyState accent={accent} />
            </Animated.View>
          ) : (
            <>
              <View style={styles.listHeaderRow}>
                <SectionLabel text="Matched Courses" />
                <Text style={[styles.listCountText, { color: accent }]}>{filtered.length} shown</Text>
              </View>
              <View style={styles.spacerSmall} />

              {filtered.map((course, index) => (
                <Animated.View key={`${course.name}-${index}`} entering={FadeInRight.delay(200 + index * 50).springify()}>
                  <CourseCard course={course} rank={index + 1} accent={accent} />
                </Animated.View>
              ))}
            </>
          )}

          <View style={styles.spacerExtraLarge} />
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};

// ── Sub-components ────────────────────────────────────────────

const StatsBar: React.FC<{ total: number; tier1: number; dept: string; accent: string }> = ({
  total,
  tier1,
  dept,
  accent,
}) => (
  <View style={styles.statsContainer}>
    <Stat value={total.toString()} label="Total Found" color={accent} />
    <View style={styles.statsDivider} />
    <Stat value={tier1.toString()} label="Perfect Match" color={accent} />
    <View style={styles.statsDivider} />
    <Stat value={dept} label="Department" color={accent} />
  </View>
);

const Stat: React.FC<{ value: string; label: string; color: string }> = ({ value, label, color }) => (
  <View style={styles.statCol}>
    <Text style={[styles.statValue, { color }]} numberOfLines={1}>
      {value}
    </Text>
    <Text style={styles.statLabel}>{label}</Text>
  </View>
);

const TierFilterRow: React.FC<{
  selected: string;
  accent: string;
  counts: Record<string, number>;
  onSelect: (t: string) => void;
}> = ({ selected, counts, onSelect }) => {
  const tiers = ['All', 'Tier 1', 'Tier 2', 'Tier 3', 'Low'];

  const getChipColor = (tier: string) => {
    switch (tier) {
      case 'Tier 1': return AppColors.success;
      case 'Tier 2': return AppColors.amber;
      case 'Tier 3': return '#6C8EF5';
      case 'Low': return AppColors.error;
      default: return AppColors.teal;
    }
  };

  return (
    <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.filterScroll}>
      {tiers.map((t) => {
        const sel = selected === t;
        const color = getChipColor(t);

        return (
          <Pressable key={t} onPress={() => onSelect(t)}>
            <View
              style={[
                styles.filterChip,
                {
                  backgroundColor: sel ? addAlpha(color, 0.15) : AppColors.surfaceElevated,
                  borderColor: sel ? color : AppColors.border,
                  borderWidth: sel ? 1.5 : 1,
                },
              ]}
            >
              <Text style={[styles.filterChipText, { color: sel ? color : AppColors.textMuted }]}>{t}</Text>
              <View style={[styles.filterChipBadge, { backgroundColor: sel ? addAlpha(color, 0.2) : AppColors.border }]}>
                <Text style={[styles.filterChipBadgeText, { color: sel ? color : AppColors.textMuted }]}>
                  {counts[t] || 0}
                </Text>
              </View>
            </View>
          </Pressable>
        );
      })}
    </ScrollView>
  );
};

const CourseCard: React.FC<{ course: CourseResult; rank: number; accent: string }> = ({ course, rank, accent }) => {
  const isTop = rank === 1;

  const getTierColor = (pct: number) => {
    if (pct >= 100) return AppColors.success;
    if (pct >= 75) return AppColors.amber;
    if (pct >= 50) return '#6C8EF5';
    return AppColors.error;
  };

  const getDifficultyColor = (diff: string) => {
    switch (diff) {
      case 'Easy': return AppColors.success;
      case 'Hard': return AppColors.error;
      default: return AppColors.amber;
    }
  };

  const tierColor = getTierColor(course.matchPercentage);
  const diffColor = getDifficultyColor(course.difficulty);

  return (
    <View style={styles.cardWrapper}>
      <GlowCard glowColor={tierColor} isSelected={isTop} padding={16}>
        {/* Row 1: Rank + Name + Match Badge */}
        <View style={styles.cardHeader}>
          <View
            style={[
              styles.cardRankBox,
              {
                backgroundColor: rank <= 3 ? addAlpha(tierColor, 0.15) : AppColors.surface,
                borderColor: rank <= 3 ? tierColor : AppColors.border,
                borderWidth: isTop ? 2 : 1,
              },
            ]}
          >
            <Text style={[styles.cardRankText, { color: rank <= 3 ? tierColor : AppColors.textMuted }]}>
              #{rank}
            </Text>
          </View>

          <View style={styles.cardTitleCol}>
            <Text style={styles.cardTitle}>{course.name}</Text>
            <Text style={[styles.cardDepartment, { color: accent }]}>{course.department}</Text>
          </View>

          <MatchBadge percentage={course.matchPercentage} color={tierColor} />
        </View>

        {/* Divider */}
        <View style={styles.cardDivider} />

        {/* Row 3: Metadata Chips */}
        <View style={styles.metaChipsContainer}>
          <MetaChip icon="cellular" label={course.difficulty} color={diffColor} />
          <MetaChip icon="school" label={`Year ${course.yearOfStudy}`} color={accent} />
          <MetaChip icon="pricetag" label={course.preference} color={addAlpha(accent, 0.8)} />
          {course.prerequisite ? (
            <MetaChip icon="lock-closed" label={`Req: ${course.prerequisite}`} color={AppColors.textMuted} />
          ) : (
            <MetaChip icon="lock-open" label="No Prereq" color={addAlpha(AppColors.success, 0.7)} />
          )}
        </View>

        {/* Tier label + TOP PICK badge */}
        {course.matchTier.length > 0 && (
          <View style={styles.cardFooter}>
            <View style={[styles.tierLabelBox, { backgroundColor: addAlpha(tierColor, 0.1), borderColor: addAlpha(tierColor, 0.3) }]}>
              <Text style={[styles.tierLabelText, { color: tierColor }]}>{course.matchTier}</Text>
            </View>

            {isTop && (
              <View style={[styles.topPickBox, { backgroundColor: addAlpha(accent, 0.15) }]}>
                <Text style={[styles.topPickText, { color: accent }]}>TOP PICK</Text>
              </View>
            )}
          </View>
        )}
      </GlowCard>
    </View>
  );
};

const MatchBadge: React.FC<{ percentage: number; color: string }> = ({ percentage, color }) => (
  <View style={[styles.matchBadgeBox, { backgroundColor: addAlpha(color, 0.1), borderColor: addAlpha(color, 0.4) }]}>
    <Text style={[styles.matchBadgeValue, { color }]}>{Math.round(percentage)}</Text>
    <Text style={[styles.matchBadgePercent, { color: addAlpha(color, 0.7) }]}>%</Text>
  </View>
);

const MetaChip: React.FC<{ icon: keyof typeof Ionicons.glyphMap; label: string; color: string }> = ({
  icon,
  label,
  color,
}) => (
  <View style={[styles.metaChipBox, { backgroundColor: addAlpha(color, 0.08), borderColor: addAlpha(color, 0.25) }]}>
    <Ionicons name={icon} size={11} color={color} style={{ marginRight: 4 }} />
    <Text style={[styles.metaChipText, { color }]}>{label}</Text>
  </View>
);

const EmptyState: React.FC<{ accent: string }> = ({ accent }) => (
  <View style={styles.emptyContainer}>
    <Ionicons name="search" color={addAlpha(accent, 0.4)} size={56} />
    <Text style={styles.emptyTitle}>No courses found</Text>
    <Text style={styles.emptySubtitle}>Try a different filter or adjust{'\n'}your profile preferences.</Text>
  </View>
);

// ── Styles ────────────────────────────────────────────────────
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: AppColors.obsidian,
  },
  glowBlobContainer: {
    position: 'absolute',
    top: -80,
    right: -80,
    width: 300,
    height: 300,
    zIndex: 0,
  },
  safeArea: {
    flex: 1,
  },
  appBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingTop: 12,
    zIndex: 10,
  },
  backButton: {
    padding: 8,
  },
  mockBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: AppColors.amberSoft,
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: addAlpha(AppColors.amber, 0.4),
  },
  mockBadgeText: {
    fontSize: 11,
    color: AppColors.amber,
    fontWeight: '600',
  },
  scrollContent: {
    paddingHorizontal: 24,
    paddingTop: 16,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
  },
  headerIconBox: {
    width: 44,
    height: 44,
    borderRadius: 12,
    borderWidth: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 14,
  },
  headerTextCol: {
    flex: 1,
  },
  headerTitle: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 22,
    fontWeight: '800',
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  },
  headerSubtitle: {
    fontSize: 11,
    fontWeight: '600',
    marginTop: 2,
  },

  // Stats Bar
  statsContainer: {
    flexDirection: 'row',
    backgroundColor: AppColors.surface,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: AppColors.border,
    padding: 16,
  },
  statsDivider: {
    width: 1,
    height: 30,
    backgroundColor: AppColors.border,
    alignSelf: 'center',
  },
  statCol: {
    flex: 1,
    alignItems: 'center',
  },
  statValue: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 15,
    fontWeight: '800',
    marginBottom: 2,
  },
  statLabel: {
    fontSize: 10,
    color: AppColors.textMuted,
    fontWeight: '600',
  },

  // Filter Chips
  filterScroll: {
    overflow: 'visible',
  },
  filterChip: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 8,
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: 20,
  },
  filterChipText: {
    fontSize: 12,
    fontWeight: '700',
    marginRight: 5,
  },
  filterChipBadge: {
    paddingHorizontal: 5,
    paddingVertical: 1,
    borderRadius: 8,
  },
  filterChipBadgeText: {
    fontSize: 10,
    fontWeight: '700',
  },

  // List Header
  listHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  listCountText: {
    fontSize: 11,
    fontWeight: '600',
  },

  // Course Card
  cardWrapper: {
    marginBottom: 12,
  },
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'flex-start',
  },
  cardRankBox: {
    width: 34,
    height: 34,
    borderRadius: 17,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  cardRankText: {
    fontSize: 10,
    fontWeight: '800',
  },
  cardTitleCol: {
    flex: 1,
    marginRight: 8,
  },
  cardTitle: {
    fontFamily: 'Syne-Bold',
    fontSize: 14,
    fontWeight: '700',
    color: AppColors.textPrimary,
    lineHeight: 18,
    marginBottom: 4,
  },
  cardDepartment: {
    fontSize: 11,
    fontWeight: '600',
  },
  cardDivider: {
    height: 1,
    backgroundColor: addAlpha(AppColors.border, 0.5),
    marginVertical: 12,
  },
  metaChipsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 6,
  },
  cardFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 12,
  },
  tierLabelBox: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
    borderWidth: 1,
  },
  tierLabelText: {
    fontSize: 10,
    fontWeight: '700',
    letterSpacing: 0.3,
  },
  topPickBox: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  topPickText: {
    fontSize: 9,
    fontWeight: '800',
    letterSpacing: 1,
  },

  // Match Badge
  matchBadgeBox: {
    width: 52,
    height: 52,
    borderRadius: 26,
    borderWidth: 1.5,
    justifyContent: 'center',
    alignItems: 'center',
  },
  matchBadgeValue: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 15,
    fontWeight: '800',
    lineHeight: 15,
  },
  matchBadgePercent: {
    fontSize: 9,
    fontWeight: '600',
    marginTop: -2,
  },

  // Meta Chip
  metaChipBox: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
    borderWidth: 1,
  },
  metaChipText: {
    fontSize: 11,
    fontWeight: '600',
  },

  // Empty State
  emptyContainer: {
    alignItems: 'center',
    paddingVertical: 60,
  },
  emptyTitle: {
    fontFamily: 'Syne-Bold',
    fontSize: 20,
    fontWeight: '700',
    color: AppColors.textPrimary,
    marginTop: 16,
    marginBottom: 8,
  },
  emptySubtitle: {
    fontSize: 13,
    color: AppColors.textSecondary,
    lineHeight: 19.5,
    textAlign: 'center',
  },

  // Spacers
  spacerSmall: { height: 14 },
  spacerMedium: { height: 20 },
  spacerLarge: { height: 24 },
  spacerExtraLarge: { height: 48 },
});
