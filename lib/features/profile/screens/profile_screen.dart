import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  UnitPreference _unitPreference = UnitPreference.metric;
  bool _formInitialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _populateForm(UserProfile profile) {
    _nameController.text = profile.name;
    _phoneController.text = profile.phoneNumber;
    _weightController.text = profile.weightKg?.toString() ?? '';
    _heightController.text = profile.heightCm?.toString() ?? '';
    _ageController.text = profile.age?.toString() ?? '';
    _unitPreference = profile.unitPreference;
    _formInitialized = true;
  }

  Future<void> _save(UserProfile currentProfile) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = currentProfile.copyWith(
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      weightKg: double.tryParse(_weightController.text),
      heightCm: double.tryParse(_heightController.text),
      age: int.tryParse(_ageController.text),
      unitPreference: _unitPreference,
    );

    await ref.read(profileRepositoryProvider).saveProfile(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Not signed in'));
          }
          if (!_formInitialized) {
            _populateForm(profile);
          }
          return _buildForm(context, profile);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Something went wrong: $error')),
      ),
    );
  }

  Widget _buildForm(BuildContext context, UserProfile profile) {
    final bmi = profile.bmi;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              profile.email,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone number'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 16),
            SegmentedButton<UnitPreference>(
              segments: const [
                ButtonSegment(
                  value: UnitPreference.metric,
                  label: Text('Metric'),
                ),
                ButtonSegment(
                  value: UnitPreference.imperial,
                  label: Text('Imperial'),
                ),
              ],
              selected: {_unitPreference},
              onSelectionChanged: (selection) {
                setState(() => _unitPreference = selection.first);
              },
            ),
            if (bmi != null) ...[
              const SizedBox(height: 16),
              Text('BMI: ${bmi.toStringAsFixed(1)}'),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : () => _save(profile),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
