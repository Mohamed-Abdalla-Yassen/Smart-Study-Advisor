// AdvisorScreen.tsx
import React, { useState, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Pressable,
  Modal,
  TextInput,
  Alert,
  FlatList,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Animated, { FadeInDown, FadeInUp, FadeIn } from 'react-native-reanimated';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { LinearGradient } from 'expo-linear-gradient';

import { AppColors, AppTypography } from '../theme/theme';
import { GlowCard, NeonButton, ChipTag } from '../widgets/widgets';
import { AppConstants, StudentForm, CourseResult, CourseMapper } from '../models/models';
import { ApiService } from '../services/apiService';

// Add to your navigation types file
type RootStackParamList = {
  Home: undefined;
  Advisor: { mode: 'ai' | 'logic' };
  Results: { results: CourseResult[]; form: StudentForm; mode: string; isMock?: boolean };
};

type AdvisorScreenNavigationProp = NativeStackNavigationProp<RootStackParamList, 'Advisor'>;
type AdvisorScreenRouteProp = RouteProp<RootStackParamList, 'Advisor'>;

// Helper to add alpha to hex colors
const addAlpha = (hex: string, opacity: number): string => {
  const alpha = Math.round(opacity * 255).toString(16).padStart(2, '0').toUpperCase();
  return `${hex}${alpha}`;
};

// Generic helper to toggle items in a Set stored in React state
const toggleSetItem = <T,>(item: T, currentSet: Set<T>, setFn: (s: Set<T>) => void) => {
  const newSet = new Set(currentSet);
  if (newSet.has(item)) newSet.delete(item);
  else newSet.add(item);
  setFn(newSet);
};

export const AdvisorScreen: React.FC = () => {
  const navigation = useNavigation<AdvisorScreenNavigationProp>();
  const route = useRoute<AdvisorScreenRouteProp>();
  const mode = route.params.mode;

  const [selectedDept, setSelectedDept] = useState<string | null>(null);
  const [prefs, setPrefs] = useState<Set<string>>(new Set());
  const [difficulties, setDifficulties] = useState<Set<string>>(new Set());
  const [years, setYears] = useState<Set<number>>(new Set());
  const [prereqs, setPrereqs] = useState<Set<string>>(new Set());

  const [isLoading, setIsLoading] = useState(false);
  const [isPickerVisible, setIsPickerVisible] = useState(false);

  const isAI = mode === 'ai';
  const accent = isAI ? AppColors.amber : AppColors.teal;

  const isFormValid =
    selectedDept !== null &&
    prefs.size > 0 &&
    difficulties.size > 0 &&
    years.size > 0 &&
    prereqs.size > 0;

  // ── Submit ──────────────────────────────────────────────────
  const handleSubmit = async () => {
    if (!isFormValid) {
      Alert.alert('Missing Fields', 'Please fill in all fields including at least one course taken.');
      return;
    }

    setIsLoading(true);

    const form: StudentForm = {
      dept: selectedDept!,
      prefs: new Set(prefs),
      difficulties: new Set(difficulties),
      years: new Set(years),
      prereqs: new Set(prereqs),
    };

    try {
      const results = isAI
        ? await ApiService.getAiRecommendations(form)
        : await ApiService.getLogicRecommendations(form);

      navigation.navigate('Results', { results, form, mode });
    } catch (e: any) {
      // Show custom dialog equivalent using standard Alert with buttons
      Alert.alert(
        'Connection Error',
        `${e.message}\n\nLoading demo data instead.`,
        [
          { text: 'Cancel', style: 'cancel' },
          {
            text: 'Continue with Demo',
            onPress: () => {
              navigation.navigate('Results', {
                results: CourseMapper.mockResults(selectedDept!),
                form,
                mode,
                isMock: true,
              });
            },
          },
        ],
        { cancelable: true }
      );
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container} edges={['top', 'bottom']}>
      {/* ── AppBar ────────────────────────────────────────────── */}
      <View style={styles.appBar}>
        <Pressable onPress={() => navigation.goBack()} style={styles.backButton} hitSlop={10}>
          <Ionicons name="arrow-back" color={AppColors.textSecondary} size={24} />
        </Pressable>
        <View style={styles.appBarTitle}>
          <View style={[styles.appBarDot, { backgroundColor: accent }]} />
          <Text style={[styles.appBarTitleText, { color: accent }]}>
            {isAI ? 'AI Advisor' : 'Logic Advisor'}
          </Text>
        </View>
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent} showsVerticalScrollIndicator={false}>
        {/* ── Header ────────────────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(50).springify()}>
          <Text style={styles.headerTitle}>Build your{'\n'}Profile</Text>
        </Animated.View>

        <Animated.View entering={FadeIn.delay(100)}>
          <Text style={styles.headerSubtitle}>
            All fields are required. Multiple selections allowed.
          </Text>
        </Animated.View>

        <View style={styles.spacerLarge} />

        {/* ── 1. Department ─────────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(150).springify()}>
          <RequiredLabel label="Department" filled={selectedDept !== null} />
          <View style={styles.spacerSmall} />
          <DeptGrid
            selected={selectedDept}
            accent={accent}
            onSelect={(d) => setSelectedDept(d)}
          />
        </Animated.View>

        <View style={styles.spacerLarge} />

        {/* ── 2. Interests ──────────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(200).springify()}>
          <RequiredLabel
            label="Interests"
            filled={prefs.size > 0}
            hint={`${prefs.size} selected`}
          />
          <View style={styles.spacerSmall} />
          <MultiTagWrap
            options={AppConstants.preferences}
            selected={prefs}
            accent={accent}
            onToggle={(t) => toggleSetItem(t, prefs, setPrefs)}
          />
        </Animated.View>

        <View style={styles.spacerLarge} />

        {/* ── 3. Difficulty ─────────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(250).springify()}>
          <RequiredLabel
            label="Difficulty"
            filled={difficulties.size > 0}
            hint={`${difficulties.size} selected`}
          />
          <View style={styles.spacerSmall} />
          <GlowCard glowColor={accent} padding={16}>
            <View style={styles.rowWrapper}>
              {AppConstants.difficulties.map((d) => {
                const sel = difficulties.has(d);
                const color = d === 'Easy' ? AppColors.success : d === 'Hard' ? AppColors.error : AppColors.amber;
                return (
                  <Pressable
                    key={d}
                    style={styles.flexItem}
                    onPress={() => toggleSetItem(d, difficulties, setDifficulties)}
                  >
                    <View
                      style={[
                        styles.selectionBox,
                        {
                          backgroundColor: sel ? addAlpha(color, 0.15) : 'transparent',
                          borderColor: sel ? color : AppColors.border,
                          borderWidth: sel ? 1.5 : 1,
                        },
                      ]}
                    >
                      {sel && <Ionicons name="checkmark" color={color} size={14} style={{ marginBottom: 2 }} />}
                      <Text style={[styles.selectionBoxText, { color: sel ? color : AppColors.textMuted }]}>
                        {d}
                      </Text>
                    </View>
                  </Pressable>
                );
              })}
            </View>
          </GlowCard>
        </Animated.View>

        <View style={styles.spacerMedium} />

        {/* ── 4. Year of Study ──────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(300).springify()}>
          <RequiredLabel label="Year of Study" filled={years.size > 0} hint={`${years.size} selected`} />
          <View style={styles.spacerSmall} />
          <GlowCard glowColor={accent} padding={16}>
            <View style={styles.rowWrapper}>
              {AppConstants.years.map((y) => {
                const sel = years.has(y);
                return (
                  <Pressable key={y} style={styles.flexItem} onPress={() => toggleSetItem(y, years, setYears)}>
                    <View
                      style={[
                        styles.selectionBox,
                        {
                          backgroundColor: sel ? addAlpha(accent, 0.15) : 'transparent',
                          borderColor: sel ? accent : AppColors.border,
                          borderWidth: sel ? 1.5 : 1,
                        },
                      ]}
                    >
                      {sel && <Ionicons name="checkmark" color={accent} size={12} style={{ marginBottom: 2 }} />}
                      <Text style={[styles.selectionBoxTextYear, { color: sel ? accent : AppColors.textMuted }]}>
                        Y{y}
                      </Text>
                    </View>
                  </Pressable>
                );
              })}
            </View>
          </GlowCard>
        </Animated.View>

        <View style={styles.spacerLarge} />

        {/* ── 5. Courses Taken ──────────────────────────────────── */}
        <Animated.View entering={FadeInDown.delay(350).springify()}>
          <RequiredLabel
            label="Courses Already Taken"
            filled={prereqs.size > 0}
            hint={`${prereqs.size} selected`}
          />
          <Text style={styles.helperText}>
            Select all courses you have already completed. Prolog uses these to filter recommendations.
          </Text>
          <View style={styles.spacerSmall} />

          <Pressable onPress={() => setIsPickerVisible(true)}>
            <View
              style={[
                styles.prereqTriggerBox,
                {
                  borderColor: prereqs.size > 0 ? accent : AppColors.border,
                  borderWidth: prereqs.size > 0 ? 1.5 : 1,
                  shadowColor: prereqs.size > 0 ? accent : 'transparent',
                  shadowOpacity: 0.15,
                  shadowRadius: 12,
                },
              ]}
            >
              <Ionicons
                name="school"
                color={prereqs.size > 0 ? accent : AppColors.textMuted}
                size={20}
                style={{ marginRight: 12 }}
              />
              <View style={styles.prereqTriggerContent}>
                {prereqs.size === 0 ? (
                  <Text style={styles.prereqTriggerPlaceholder}>Tap to select courses taken...</Text>
                ) : (
                  <View style={styles.tagsContainer}>
                    {Array.from(prereqs).map((c) => (
                      <ChipTag
                        key={c}
                        label={c}
                        color={accent}
                        onRemove={() => toggleSetItem(c, prereqs, setPrereqs)}
                      />
                    ))}
                  </View>
                )}
              </View>
              <Ionicons name="chevron-forward" color={addAlpha(accent, 0.6)} size={20} />
            </View>
          </Pressable>
        </Animated.View>

        <View style={styles.spacerLarge} />
        <View style={styles.spacerSmall} />

        {/* ── Progress Indicator ────────────────────────────────── */}
        <Animated.View entering={FadeIn.delay(400)}>
          <ProgressBar
            filled={[selectedDept !== null, prefs.size > 0, difficulties.size > 0, years.size > 0, prereqs.size > 0]}
            accent={accent}
          />
        </Animated.View>

        <View style={styles.spacerMedium} />

        {/* ── Submit Button ─────────────────────────────────────── */}
        <Animated.View entering={FadeInUp.delay(450)}>
          <NeonButton
            label="Get Recommendations"
            icon="sparkles"
            fullWidth
            color={isFormValid ? accent : AppColors.textMuted}
            isLoading={isLoading}
            onPressed={isLoading ? undefined : handleSubmit}
          />
        </Animated.View>

        <View style={styles.spacerLarge} />
      </ScrollView>

      {/* ── Prereq Picker Bottom Sheet ────────────────────────── */}
      <Modal visible={isPickerVisible} animationType="slide" transparent>
        <CoursePickerSheet
          accent={accent}
          selected={prereqs}
          onDone={(picked) => {
            setPrereqs(picked);
            setIsPickerVisible(false);
          }}
          onClose={() => setIsPickerVisible(false)}
        />
      </Modal>
    </SafeAreaView>
  );
};

// ── Required Label ────────────────────────────────────────────
const RequiredLabel: React.FC<{ label: string; filled: boolean; hint?: string }> = ({ label, filled, hint }) => (
  <View style={styles.reqLabelContainer}>
    <View
      style={[
        styles.reqLabelLine,
        { backgroundColor: filled ? AppColors.success : AppColors.teal },
      ]}
    />
    <Text style={styles.reqLabelText}>{label.toUpperCase()}</Text>
    <View style={styles.reqLabelRight}>
      {filled ? (
        <View style={styles.reqLabelFilled}>
          <Ionicons name="checkmark-circle" color={AppColors.success} size={14} />
          {hint && <Text style={styles.reqLabelHint}>{hint}</Text>}
        </View>
      ) : (
        <View style={styles.reqLabelBadge}>
          <Text style={styles.reqLabelBadgeText}>Required</Text>
        </View>
      )}
    </View>
  </View>
);

// ── Progress Bar ──────────────────────────────────────────────
const ProgressBar: React.FC<{ filled: boolean[]; accent: string }> = ({ filled, accent }) => {
  const done = filled.filter((f) => f).length;
  const labels = ['Dept', 'Interests', 'Difficulty', 'Year', 'Courses'];

  return (
    <View>
      <View style={styles.progressHeader}>
        <Text style={styles.progressTitle}>Profile Completion</Text>
        <Text style={[styles.progressScore, { color: accent }]}>{done} / {filled.length}</Text>
      </View>
      <View style={styles.progressRow}>
        {filled.map((isFilled, i) => (
          <View
            key={`bar-${i}`}
            style={[
              styles.progressSegment,
              { backgroundColor: isFilled ? accent : AppColors.border, marginRight: i < filled.length - 1 ? 4 : 0 },
            ]}
          />
        ))}
      </View>
      <View style={styles.progressLabels}>
        {labels.map((label, i) => (
          <Text key={label} style={[styles.progressLabel, { color: filled[i] ? accent : AppColors.textMuted }]}>
            {label}
          </Text>
        ))}
      </View>
    </View>
  );
};

// ── Department Grid ───────────────────────────────────────────
const DeptGrid: React.FC<{
  selected: string | null;
  accent: string;
  onSelect: (d: string) => void;
}> = ({ selected, accent, onSelect }) => {
  const icons: Record<string, keyof typeof Ionicons.glyphMap> = {
    'Architecture': 'business',
    'Basic and Applied Sciences': 'flask',
    'CE': 'construct',
    'CSE': 'desktop',
    'EE': 'flash',
    'Humanities': 'book',
    'ME': 'settings',
    'PE': 'cog',
  };

  return (
    <View style={styles.gridContainer}>
      {AppConstants.departments.map((dept) => {
        const sel = selected === dept;
        const label = AppConstants.deptLabels[dept] || dept;
        return (
          <View key={dept} style={styles.gridCell}>
            <Pressable onPress={() => onSelect(dept)}>
              <View
                style={[
                  styles.gridItem,
                  {
                    backgroundColor: sel ? addAlpha(accent, 0.12) : AppColors.surfaceElevated,
                    borderColor: sel ? accent : AppColors.border,
                    borderWidth: sel ? 1.5 : 1,
                  },
                ]}
              >
                <Ionicons
                  name={icons[dept] ?? 'school'}
                  color={sel ? accent : AppColors.textMuted}
                  size={16}
                  style={{ marginRight: 8 }}
                />
                <Text style={[styles.gridItemText, { color: sel ? accent : AppColors.textSecondary }]} numberOfLines={2}>
                  {label}
                </Text>
              </View>
            </Pressable>
          </View>
        );
      })}
    </View>
  );
};

// ── Multi-select Tag Wrap ─────────────────────────────────────
const MultiTagWrap: React.FC<{
  options: readonly string[] | string[];
  selected: Set<string>;
  accent: string;
  onToggle: (opt: string) => void;
}> = ({ options, selected, accent, onToggle }) => (
  <View style={styles.tagsContainer}>
    {options.map((opt) => {
      const sel = selected.has(opt);
      return (
        <Pressable key={opt} onPress={() => onToggle(opt)}>
          <View
            style={[
              styles.tagItem,
              {
                backgroundColor: sel ? addAlpha(accent, 0.15) : AppColors.surfaceElevated,
                borderColor: sel ? accent : AppColors.border,
                borderWidth: sel ? 1.5 : 1,
              },
            ]}
          >
            {sel && <Ionicons name="checkmark" color={accent} size={12} style={{ marginRight: 4 }} />}
            <Text style={[styles.tagItemText, { color: sel ? accent : AppColors.textSecondary }]}>{opt}</Text>
          </View>
        </Pressable>
      );
    })}
  </View>
);

// ── Course Picker Bottom Sheet ────────────────────────────────
const CoursePickerSheet: React.FC<{
  accent: string;
  selected: Set<string>;
  onDone: (picked: Set<string>) => void;
  onClose: () => void;
}> = ({ accent, selected, onDone, onClose }) => {
  const [picked, setPicked] = useState<Set<string>>(new Set(selected));
  const [search, setSearch] = useState('');

  const filtered = useMemo(() => {
    const q = search.toLowerCase();
    return q === ''
      ? AppConstants.allCourses
      : AppConstants.allCourses.filter((c) => c.toLowerCase().includes(q));
  }, [search]);

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
      style={styles.sheetOverlay}
    >
      <View style={styles.sheetBackground} onTouchEnd={onClose} />
      <View style={styles.sheetContainer}>
        <View style={styles.sheetHandle} />

        {/* Header */}
        <View style={styles.sheetHeader}>
          <View style={styles.sheetHeaderTitles}>
            <Text style={styles.sheetTitle}>Courses Taken</Text>
            <Text style={[styles.sheetSubtitle, { color: accent }]}>
              {picked.size} selected  ·  {filtered.length} shown
            </Text>
          </View>
          <Pressable onPress={() => onDone(picked)}>
            <LinearGradient
              colors={[accent, addAlpha(accent, 0.75)]}
              style={styles.sheetDoneButton}
            >
              <Text style={styles.sheetDoneText}>Done</Text>
            </LinearGradient>
          </Pressable>
        </View>

        {/* Search */}
        <View style={styles.sheetSearchContainer}>
          <Ionicons name="search" color={AppColors.textMuted} size={18} style={styles.sheetSearchIcon} />
          <TextInput
            style={styles.sheetSearchInput}
            placeholder="Search courses..."
            placeholderTextColor={AppColors.textMuted}
            value={search}
            onChangeText={setSearch}
            autoCorrect={false}
          />
          {search.length > 0 && (
            <Pressable onPress={() => setSearch('')} style={styles.sheetSearchClear}>
              <Ionicons name="close-circle" color={AppColors.textMuted} size={16} />
            </Pressable>
          )}
        </View>

        {/* Selected Quick View */}
        {picked.size > 0 && (
          <View style={styles.sheetSelectedQuick}>
            <Text style={styles.sheetSelectedLabel}>Selected: </Text>
            <ScrollView horizontal showsHorizontalScrollIndicator={false}>
              {Array.from(picked).map((c) => (
                <View key={`q-${c}`} style={{ marginRight: 6 }}>
                  <ChipTag label={c} color={accent} onRemove={() => toggleSetItem(c, picked, setPicked)} />
                </View>
              ))}
            </ScrollView>
          </View>
        )}

        <View style={styles.sheetDivider} />

        {/* List */}
        <FlatList
          data={filtered}
          keyExtractor={(item) => item}
          contentContainerStyle={styles.sheetListContent}
          initialNumToRender={20}
          renderItem={({ item: course }) => {
            const sel = picked.has(course);
            return (
              <Pressable onPress={() => toggleSetItem(course, picked, setPicked)}>
                <View
                  style={[
                    styles.sheetListItem,
                    {
                      backgroundColor: sel ? addAlpha(accent, 0.1) : AppColors.surfaceElevated,
                      borderColor: sel ? accent : AppColors.border,
                      borderWidth: sel ? 1.5 : 1,
                    },
                  ]}
                >
                  <View
                    style={[
                      styles.sheetListCheckbox,
                      {
                        backgroundColor: sel ? accent : 'transparent',
                        borderColor: sel ? accent : AppColors.border,
                      },
                    ]}
                  >
                    {sel && <Ionicons name="checkmark" size={12} color={AppColors.obsidian} />}
                  </View>
                  <Text style={[styles.sheetListItemText, { color: sel ? accent : AppColors.textPrimary }]}>
                    {course}
                  </Text>
                </View>
              </Pressable>
            );
          }}
        />
      </View>
    </KeyboardAvoidingView>
  );
};

// ── Styles ────────────────────────────────────────────────────
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: AppColors.obsidian,
  },
  appBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    height: 56,
  },
  backButton: {
    padding: 8,
  },
  appBarTitle: {
    flexDirection: 'row',
    alignItems: 'center',
    marginLeft: 16,
  },
  appBarDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginRight: 8,
  },
  appBarTitleText: {
    fontFamily: 'Syne-Bold',
    fontSize: 16,
    fontWeight: '700',
  },
  scrollContent: {
    paddingHorizontal: 24,
    paddingBottom: 48,
  },
  headerTitle: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 38,
    lineHeight: 42,
    fontWeight: '800',
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    marginTop: 8,
  },
  headerSubtitle: {
    fontSize: 14,
    color: AppColors.textSecondary,
    lineHeight: 21,
    marginTop: 6,
  },
  helperText: {
    fontSize: 12,
    color: AppColors.textMuted,
    lineHeight: 18,
    marginTop: 6,
  },
  
  // Required Label
  reqLabelContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  reqLabelLine: {
    width: 3,
    height: 14,
    borderRadius: 2,
    marginRight: 8,
  },
  reqLabelText: {
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 2,
    color: AppColors.textSecondary,
  },
  reqLabelRight: {
    flex: 1,
    alignItems: 'flex-end',
  },
  reqLabelFilled: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  reqLabelHint: {
    fontSize: 11,
    fontWeight: '600',
    color: AppColors.success,
    marginLeft: 4,
  },
  reqLabelBadge: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    backgroundColor: addAlpha(AppColors.error, 0.1),
    borderRadius: 6,
    borderWidth: 1,
    borderColor: addAlpha(AppColors.error, 0.3),
  },
  reqLabelBadgeText: {
    fontSize: 10,
    fontWeight: '600',
    color: AppColors.error,
  },

  // Progress Bar
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  progressTitle: {
    fontSize: 11,
    color: AppColors.textMuted,
    fontWeight: '600',
    letterSpacing: 1,
  },
  progressScore: {
    fontSize: 12,
    fontWeight: '700',
  },
  progressRow: {
    flexDirection: 'row',
    height: 4,
  },
  progressSegment: {
    flex: 1,
    borderRadius: 2,
  },
  progressLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 6,
  },
  progressLabel: {
    fontSize: 9,
    fontWeight: '600',
  },

  // Grid
  gridContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    marginHorizontal: -5,
  },
  gridCell: {
    width: '50%',
    padding: 5,
  },
  gridItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: 12,
  },
  gridItemText: {
    flex: 1,
    fontSize: 11,
    fontWeight: '600',
  },

  // Tags Wrap
  tagsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  tagItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 10,
  },
  tagItemText: {
    fontSize: 13,
    fontWeight: '500',
  },

  // Glow Cards Flex Row
  rowWrapper: {
    flexDirection: 'row',
    gap: 8,
  },
  flexItem: {
    flex: 1,
  },
  selectionBox: {
    alignItems: 'center',
    paddingVertical: 14,
    borderRadius: 10,
  },
  selectionBoxText: {
    fontSize: 13,
    fontWeight: '700',
  },
  selectionBoxTextYear: {
    fontSize: 14,
    fontWeight: '800',
  },

  // Prereq trigger
  prereqTriggerBox: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    backgroundColor: AppColors.surfaceElevated,
    borderRadius: 14,
  },
  prereqTriggerContent: {
    flex: 1,
  },
  prereqTriggerPlaceholder: {
    color: AppColors.textMuted,
    fontSize: 14,
  },

  // Spacers
  spacerSmall: { height: 12 },
  spacerMedium: { height: 20 },
  spacerLarge: { height: 28 },

  // Bottom Sheet
  sheetOverlay: {
    flex: 1,
    justifyContent: 'flex-end',
  },
  sheetBackground: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  sheetContainer: {
    height: '88%',
    backgroundColor: AppColors.surface,
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
  },
  sheetHandle: {
    width: 40,
    height: 4,
    backgroundColor: AppColors.border,
    borderRadius: 2,
    alignSelf: 'center',
    marginTop: 12,
  },
  sheetHeader: {
    flexDirection: 'row',
    paddingHorizontal: 24,
    paddingTop: 16,
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  sheetHeaderTitles: {
    flex: 1,
  },
  sheetTitle: {
    fontFamily: 'Syne-ExtraBold',
    fontSize: 20,
    fontWeight: '800',
    color: AppColors.textPrimary,
  },
  sheetSubtitle: {
    fontSize: 12,
    fontWeight: '600',
    marginTop: 2,
  },
  sheetDoneButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 10,
  },
  sheetDoneText: {
    fontSize: 13,
    fontWeight: '700',
    color: AppColors.obsidian,
    letterSpacing: 0.5,
  },
  sheetSearchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: AppColors.surfaceElevated,
    marginHorizontal: 24,
    marginTop: 14,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: AppColors.border,
    paddingHorizontal: 16,
    height: 44,
  },
  sheetSearchIcon: {
    marginRight: 8,
  },
  sheetSearchInput: {
    flex: 1,
    color: AppColors.textPrimary,
    fontSize: 14,
    height: '100%',
  },
  sheetSearchClear: {
    padding: 4,
  },
  sheetSelectedQuick: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 24,
    marginTop: 10,
  },
  sheetSelectedLabel: {
    fontSize: 11,
    color: AppColors.textMuted,
    fontWeight: '600',
    marginRight: 8,
  },
  sheetDivider: {
    height: 1,
    backgroundColor: AppColors.border,
    marginTop: 10,
  },
  sheetListContent: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  sheetListItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 12,
    borderRadius: 10,
    marginBottom: 6,
  },
  sheetListCheckbox: {
    width: 20,
    height: 20,
    borderRadius: 10,
    borderWidth: 1.5,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  sheetListItemText: {
    flex: 1,
    fontSize: 13,
    fontWeight: '500',
  },
});

