// lib/screens/advisor_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'results_screen.dart';

class AdvisorScreen extends StatefulWidget {
  final String mode;
  const AdvisorScreen({super.key, required this.mode});

  @override
  State<AdvisorScreen> createState() => _AdvisorScreenState();
}

class _AdvisorScreenState extends State<AdvisorScreen> {
  String? _selectedDept;
  final Set<String> _prefs        = {};
  final Set<String> _difficulties = {};
  final Set<int>    _years        = {};
  final Set<String> _prereqs      = {};

  bool _isLoading = false;

  bool get _isAI   => widget.mode == 'ai';
  Color get _accent => _isAI ? AppColors.amber : AppColors.teal;

  bool get _isFormValid =>
      _selectedDept != null &&
      _prefs.isNotEmpty &&
      _difficulties.isNotEmpty &&
      _years.isNotEmpty &&
      _prereqs.isNotEmpty;

  // ── Submit ──────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_isFormValid) {
      _showError('Please fill in all fields including at least one course taken.');
      return;
    }
    setState(() => _isLoading = true);

    final form = StudentForm(
      dept:         _selectedDept!,
      prefs:        Set.from(_prefs),
      difficulties: Set.from(_difficulties),
      years:        Set.from(_years),
      prereqs:      Set.from(_prereqs),
    );

    try {
      final results = _isAI
          ? await ApiService.getAiRecommendations(form)
          : await ApiService.getLogicRecommendations(form);

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ResultsScreen(results: results, form: form, mode: widget.mode),
        ));
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.surfaceElevated,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Connection Error',
                style: TextStyle(fontFamily: 'Syne', color: AppColors.textPrimary)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.toString(),
                    style: const TextStyle(color: AppColors.error, fontSize: 13)),
                const SizedBox(height: 12),
                const Text('Loading demo data instead.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final form2 = StudentForm(
                    dept: _selectedDept!, prefs: Set.from(_prefs),
                    difficulties: Set.from(_difficulties), years: Set.from(_years),
                    prereqs: Set.from(_prereqs),
                  );
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => ResultsScreen(
                      results: CourseResult.mockResults(_selectedDept!),
                      form: form2, mode: widget.mode, isMock: true,
                    ),
                  ));
                },
                child: Text('Continue with Demo', style: TextStyle(color: _accent)),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Prerequisite picker bottom sheet ────────────────────────
  void _openPrereqPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CoursePickerSheet(
        accent: _accent,
        selected: Set.from(_prereqs),
        onDone: (picked) => setState(() {
          _prereqs.clear();
          _prereqs.addAll(picked);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(width: 8, height: 8,
              decoration: BoxDecoration(color: _accent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(_isAI ? 'AI Advisor' : 'Logic Advisor',
              style: TextStyle(fontFamily: 'Syne', fontSize: 16,
                  fontWeight: FontWeight.w700, color: _accent)),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            Text('Build your\nProfile',
              style: const TextStyle(fontFamily: 'Syne', fontSize: 38,
                  fontWeight: FontWeight.w800, color: AppColors.textPrimary,
                  height: 1.1, letterSpacing: -1.5),
            ).animate().fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 6),
            const Text('All fields are required. Multiple selections allowed.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 36),

            // ── 1. Department (single) ─────────────────────────
            _RequiredLabel(label: 'Department', filled: _selectedDept != null),
            const SizedBox(height: 12),
            _DeptGrid(
              selected: _selectedDept,
              accent: _accent,
              onSelect: (d) => setState(() => _selectedDept = d),
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 28),

            // ── 2. Interests (multi) ───────────────────────────
            _RequiredLabel(label: 'Interests', filled: _prefs.isNotEmpty,
                hint: '${_prefs.length} selected'),
            const SizedBox(height: 12),
            _MultiTagWrap(
              options: AppConstants.preferences,
              selected: _prefs,
              accent: _accent,
              onToggle: (t) => setState(() =>
                  _prefs.contains(t) ? _prefs.remove(t) : _prefs.add(t)),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 28),

            // ── 3. Difficulty (multi) ──────────────────────────
            _RequiredLabel(label: 'Difficulty', filled: _difficulties.isNotEmpty,
                hint: '${_difficulties.length} selected'),
            const SizedBox(height: 12),
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: AppConstants.difficulties.map((d) {
                  final sel = _difficulties.contains(d);
                  final color = d == 'Easy' ? AppColors.success
                      : d == 'Hard' ? AppColors.error : AppColors.amber;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          sel ? _difficulties.remove(d) : _difficulties.add(d)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? color.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? color : AppColors.border,
                              width: sel ? 1.5 : 1),
                        ),
                        child: Column(children: [
                          if (sel)
                            Icon(Icons.check_rounded, color: color, size: 14),
                          if (sel) const SizedBox(height: 2),
                          Text(d, textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                                  color: sel ? color : AppColors.textMuted)),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 20),

            // ── 4. Year (multi) ────────────────────────────────
            _RequiredLabel(label: 'Year of Study', filled: _years.isNotEmpty,
                hint: '${_years.length} selected'),
            const SizedBox(height: 12),
            GlowCard(
              glowColor: _accent,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: AppConstants.years.map((y) {
                  final sel = _years.contains(y);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() =>
                          sel ? _years.remove(y) : _years.add(y)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: sel ? _accent.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? _accent : AppColors.border,
                              width: sel ? 1.5 : 1),
                        ),
                        child: Column(children: [
                          if (sel)
                            Icon(Icons.check_rounded, color: _accent, size: 12),
                          if (sel) const SizedBox(height: 2),
                          Text('Y$y', textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                                  color: sel ? _accent : AppColors.textMuted)),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 28),

            // ── 5. Courses taken (required, multi) ────────────
            _RequiredLabel(label: 'Courses Already Taken',
                filled: _prereqs.isNotEmpty,
                hint: '${_prereqs.length} selected'),
            const SizedBox(height: 6),
            const Text(
              'Select all courses you have already completed. Prolog uses these to filter recommendations.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 12),

            // Tap to open picker
            GestureDetector(
              onTap: _openPrereqPicker,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _prereqs.isNotEmpty ? _accent : AppColors.border,
                    width: _prereqs.isNotEmpty ? 1.5 : 1,
                  ),
                  boxShadow: _prereqs.isNotEmpty
                      ? [BoxShadow(color: _accent.withOpacity(0.15), blurRadius: 12)]
                      : [],
                ),
                child: Row(children: [
                  Icon(Icons.school_rounded,
                      color: _prereqs.isNotEmpty ? _accent : AppColors.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _prereqs.isEmpty
                        ? const Text('Tap to select courses taken...',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 14))
                        : Wrap(spacing: 6, runSpacing: 6,
                            children: _prereqs.map((c) =>
                              ChipTag(label: c, color: _accent,
                                onRemove: () => setState(() => _prereqs.remove(c)),
                              )).toList(),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded,
                      color: _accent.withOpacity(0.6), size: 20),
                ]),
              ),
            ).animate().fadeIn(delay: 350.ms),

            const SizedBox(height: 36),

            // ── Progress indicator ─────────────────────────────
            _ProgressBar(
              filled: [
                _selectedDept != null,
                _prefs.isNotEmpty,
                _difficulties.isNotEmpty,
                _years.isNotEmpty,
                _prereqs.isNotEmpty,
              ],
              accent: _accent,
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 24),

            // ── Submit ─────────────────────────────────────────
            NeonButton(
              label: 'Get Recommendations',
              icon: Icons.auto_awesome_rounded,
              fullWidth: true,
              color: _isFormValid ? _accent : AppColors.textMuted,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _submit,
            ).animate().fadeIn(delay: 450.ms),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ── Required label with filled indicator ─────────────────────
class _RequiredLabel extends StatelessWidget {
  final String label;
  final bool filled;
  final String? hint;
  const _RequiredLabel({required this.label, required this.filled, this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 3, height: 14,
        decoration: BoxDecoration(
          color: filled ? AppColors.success : AppColors.teal,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(label.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
            letterSpacing: 2, color: AppColors.textSecondary),
      ),
      const Spacer(),
      if (filled)
        Row(children: [
          Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
          if (hint != null) ...[
            const SizedBox(width: 4),
            Text(hint!, style: const TextStyle(fontSize: 11,
                color: AppColors.success, fontWeight: FontWeight.w600)),
          ],
        ])
      else
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: const Text('Required',
            style: TextStyle(fontSize: 10, color: AppColors.error,
                fontWeight: FontWeight.w600)),
        ),
    ]);
  }
}

// ── Progress bar (5 steps) ────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final List<bool> filled;
  final Color accent;
  const _ProgressBar({required this.filled, required this.accent});

  @override
  Widget build(BuildContext context) {
    final done = filled.where((f) => f).length;
    final labels = ['Dept', 'Interests', 'Difficulty', 'Year', 'Courses'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Profile Completion',
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
              fontWeight: FontWeight.w600, letterSpacing: 1)),
        Text('$done / ${filled.length}',
          style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 8),
      Row(children: List.generate(filled.length, (i) {
        return Expanded(child: Container(
          height: 4,
          margin: EdgeInsets.only(right: i < filled.length - 1 ? 4 : 0),
          decoration: BoxDecoration(
            color: filled[i] ? accent : AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ));
      })),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(filled.length, (i) => Text(labels[i],
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
            color: filled[i] ? accent : AppColors.textMuted),
        )),
      ),
    ]);
  }
}

// ── Department grid ───────────────────────────────────────────
class _DeptGrid extends StatelessWidget {
  final String? selected;
  final Color accent;
  final void Function(String) onSelect;
  const _DeptGrid({required this.selected, required this.accent, required this.onSelect});

  static const _icons = {
    'Architecture': Icons.apartment_rounded,
    'Basic and Applied Sciences': Icons.science_rounded,
    'CE': Icons.foundation_rounded,
    'CSE': Icons.computer_rounded,
    'EE': Icons.bolt_rounded,
    'Humanities': Icons.menu_book_rounded,
    'ME': Icons.settings_rounded,
    'PE': Icons.precision_manufacturing_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.8,
      children: AppConstants.departments.map((dept) {
        final sel = selected == dept;
        return GestureDetector(
          onTap: () => onSelect(dept),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: sel ? accent.withOpacity(0.12) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: sel ? accent : AppColors.border, width: sel ? 1.5 : 1),
              boxShadow: sel ? [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 12)] : [],
            ),
            child: Row(children: [
              Icon(_icons[dept] ?? Icons.school_rounded,
                  color: sel ? accent : AppColors.textMuted, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(AppConstants.deptLabels[dept] ?? dept,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: sel ? accent : AppColors.textSecondary),
                maxLines: 2, overflow: TextOverflow.ellipsis)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}

// ── Multi-select tag wrap ─────────────────────────────────────
class _MultiTagWrap extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final Color accent;
  final void Function(String) onToggle;
  const _MultiTagWrap({required this.options, required this.selected,
      required this.accent, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8,
      children: options.map((opt) {
        final sel = selected.contains(opt);
        return GestureDetector(
          onTap: () => onToggle(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? accent.withOpacity(0.15) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: sel ? accent : AppColors.border, width: sel ? 1.5 : 1),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              if (sel) ...[
                Icon(Icons.check_rounded, color: accent, size: 12),
                const SizedBox(width: 4),
              ],
              Text(opt, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: sel ? accent : AppColors.textSecondary)),
            ]),
          ),
        );
      }).toList(),
    );
  }
}

// ── Course picker bottom sheet ────────────────────────────────
class _CoursePickerSheet extends StatefulWidget {
  final Color accent;
  final Set<String> selected;
  final void Function(Set<String>) onDone;
  const _CoursePickerSheet({required this.accent, required this.selected, required this.onDone});

  @override
  State<_CoursePickerSheet> createState() => _CoursePickerSheetState();
}

class _CoursePickerSheetState extends State<_CoursePickerSheet> {
  late Set<String> _picked;
  String _search = '';
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _picked = Set.from(widget.selected);
  }

  List<String> get _filtered {
    final q = _search.toLowerCase();
    return q.isEmpty
        ? AppConstants.allCourses
        : AppConstants.allCourses.where((c) => c.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(children: [
        // Handle
        Container(width: 40, height: 4, margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(color: AppColors.border,
                borderRadius: BorderRadius.circular(2))),

        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Courses Taken',
                style: TextStyle(fontFamily: 'Syne', fontSize: 20,
                    fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text('${_picked.length} selected  ·  ${_filtered.length} shown',
                style: TextStyle(fontSize: 12, color: accent, fontWeight: FontWeight.w600)),
            ])),
            // Done button
            GestureDetector(
              onTap: () { Navigator.pop(context); widget.onDone(_picked); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accent, accent.withOpacity(0.75)]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: accent.withOpacity(0.35), blurRadius: 12)],
                ),
                child: const Text('Done',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.obsidian, letterSpacing: 0.5)),
              ),
            ),
          ]),
        ),

        // Search field
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
          child: TextField(
            controller: _ctrl,
            onChanged: (v) => setState(() => _search = v),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search courses...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.textMuted, size: 18),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textMuted, size: 16),
                      onPressed: () { _ctrl.clear(); setState(() => _search = ''); },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceElevated,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accent, width: 1.5)),
            ),
          ),
        ),

        // Quick actions
        if (_picked.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
            child: Row(children: [
              const Text('Selected: ', style: TextStyle(fontSize: 11,
                  color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              Expanded(child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                child: Row(children: _picked.map((c) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChipTag(label: c, color: accent,
                    onRemove: () => setState(() => _picked.remove(c))),
                )).toList()),
              )),
            ]),
          ),

        const SizedBox(height: 10),
        Divider(color: AppColors.border, height: 1),

        // Course list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final course = _filtered[i];
              final sel = _picked.contains(course);
              return GestureDetector(
                onTap: () => setState(() =>
                    sel ? _picked.remove(course) : _picked.add(course)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: sel ? accent.withOpacity(0.1) : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: sel ? accent : AppColors.border,
                        width: sel ? 1.5 : 1),
                  ),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: sel ? accent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: sel ? accent : AppColors.border, width: 1.5),
                      ),
                      child: sel
                          ? const Icon(Icons.check_rounded, size: 12, color: AppColors.obsidian)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(course,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                          color: sel ? accent : AppColors.textPrimary))),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
}