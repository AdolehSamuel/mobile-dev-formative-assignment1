import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/post.dart';
import '../../models/user_profile.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/primary_button.dart';

/// Form for creating a new feed post. The fields shown change based on
/// the selected category (events need a date and time, opportunities
/// need an application deadline, and so on).
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagsController = TextEditingController();

  PostCategory _category = PostCategory.event;
  Campus _campus = Campus.kigali;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  DateTime? _deadlineDate;
  String _coverThemeKey = kCoverThemes.first.key;
  bool _saving = false;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser;
    if (user != null) _campus = user.campus;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(DateTime.now()) ? DateTime.now() : _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadlineDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deadlineDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _submit() async {
    final isOpportunity = _category.isOpportunity;
    final formValid = _formKey.currentState!.validate();

    setState(() {
      _dateError = (isOpportunity && _deadlineDate == null)
          ? 'Select an application deadline'
          : null;
    });

    if (!formValid || _dateError != null) return;

    setState(() => _saving = true);

    final appState = context.read<AppState>();
    final user = appState.currentUser!;

    final dateTime = isOpportunity
        ? DateTime(_deadlineDate!.year, _deadlineDate!.month,
            _deadlineDate!.day, 23, 59)
        : DateTime(
            _date.year, _date.month, _date.day, _time.hour, _time.minute);

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final post = Post(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      campus: _campus,
      dateTime: dateTime,
      location: _locationController.text.trim(),
      organizerName: user.name,
      organizerRole: user.role,
      coverThemeKey: _coverThemeKey,
      tags: tags,
      deadline: isOpportunity ? dateTime : null,
      isUserCreated: true,
    );

    await appState.addPost(post);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Posted! Your post is now live in the feed.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;
    final isOpportunity = _category.isOpportunity;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user != null) _RoleBanner(user: user),
                const SizedBox(height: 20),
                Text('Category', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PostCategory.values.map((category) {
                    return FilterChipPill(
                      label: category.label,
                      icon: category.icon,
                      selected: _category == category,
                      onTap: () => setState(() => _category = category),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Title',
                  hint: 'e.g. AI for Social Impact Workshop',
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Enter a title'
                      : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Description',
                  hint: 'What should people know?',
                  controller: _descriptionController,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Enter a description'
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  isOpportunity ? 'Application Deadline' : 'Date & Time',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (isOpportunity)
                  _PickerTile(
                    icon: Icons.event_rounded,
                    label: _deadlineDate == null
                        ? 'Select a date'
                        : formatFullDate(_deadlineDate!),
                    onTap: _pickDeadline,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _PickerTile(
                          icon: Icons.event_rounded,
                          label: formatFullDate(_date),
                          onTap: _pickDate,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PickerTile(
                          icon: Icons.schedule_rounded,
                          label: _time.format(context),
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                if (_dateError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _dateError!,
                    style: const TextStyle(
                        color: AppColors.danger, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Location',
                  hint: isOpportunity
                      ? 'e.g. Remote, all campuses'
                      : 'e.g. Innovation Lab, Kigali Campus',
                  controller: _locationController,
                  textCapitalization: TextCapitalization.sentences,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) => (value?.trim().isEmpty ?? true)
                      ? 'Enter a location'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Campus', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                DropdownButtonFormField<Campus>(
                  initialValue: _campus,
                  items: Campus.values
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.label)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _campus = value ?? _campus),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.public_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Tags (optional)',
                  hint: 'e.g. Workshop, Tech, AI (separate with commas)',
                  controller: _tagsController,
                  prefixIcon: Icons.sell_outlined,
                ),
                const SizedBox(height: 20),
                Text('Cover Theme',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                _CoverThemeGrid(
                  selectedKey: _coverThemeKey,
                  onSelect: (key) => setState(() => _coverThemeKey = key),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Post',
                  icon: Icons.send_rounded,
                  loading: _saving,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleBanner extends StatelessWidget {
  final UserProfile user;

  const _RoleBanner({required this.user});

  @override
  Widget build(BuildContext context) {
    final verified = user.role.isVerifiedPoster;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            verified ? Icons.verified_rounded : Icons.school_rounded,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Posting as ${user.role.label}',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  verified
                      ? 'Your post will show a "Verified Organizer" badge to '
                          'other students.'
                      : 'Your post will be shared as student content.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverThemeGrid extends StatelessWidget {
  final String selectedKey;
  final ValueChanged<String> onSelect;

  const _CoverThemeGrid({required this.selectedKey, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemCount: kCoverThemes.length,
      itemBuilder: (context, index) {
        final theme = kCoverThemes[index];
        final selected = theme.key == selectedKey;
        return InkWell(
          onTap: () => onSelect(theme.key),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: theme.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: selected
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(theme.icon,
                      color: Colors.white.withValues(alpha: 0.9), size: 28),
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Text(
                    theme.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (selected)
                  const Positioned(
                    right: 6,
                    top: 6,
                    child: Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 18),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
