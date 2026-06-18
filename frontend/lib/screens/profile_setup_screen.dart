import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_card.dart';
import '../core/app_state.dart';
import '../core/gemini_service.dart';
import '../services/carbon_engine.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  String city = 'Chennai';
  int householdSize = 4;
  double monthlyElectricityBill = 2500;
  String vehicleType = 'Petrol Car';
  double dailyCommuteKm = 18;
  String foodPreference = 'Mixed';
  int flightsPerYear = 1;

  @override
  void initState() {
    super.initState();
    // Initialize AppState defaults
    AppState.initDefaults();
    if (AppState.currentUserProfile != null) {
      final p = AppState.currentUserProfile!;
      city = p.city;
      householdSize = p.householdSize;
      monthlyElectricityBill = p.monthlyElectricityBill;
      vehicleType = p.vehicleType;
      dailyCommuteKm = p.dailyCommuteKm;
      foodPreference = p.foodPreference;
      flightsPerYear = p.flightsPerYear;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final profile = UserProfile(
        city: city,
        householdSize: householdSize,
        monthlyElectricityBill: monthlyElectricityBill,
        vehicleType: vehicleType,
        dailyCommuteKm: dailyCommuteKm,
        foodPreference: foodPreference,
        flightsPerYear: flightsPerYear,
      );
      
      AppState.updateProfile(profile);
      
      // Navigate immediately, background fetch insights
      context.go('/home');
      GeminiService.generateGlobalInsights().then((insights) {
        if (insights != null) {
          AppState.aiInsights = insights;
          AppState.aiInsightsNotifier.value = insights;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                CustomCard(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: city,
                        decoration: const InputDecoration(labelText: 'City'),
                        onSaved: (val) => city = val ?? '',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: householdSize.toString(),
                        decoration: const InputDecoration(labelText: 'Household Size'),
                        keyboardType: TextInputType.number,
                        onSaved: (val) => householdSize = int.tryParse(val ?? '1') ?? 1,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: monthlyElectricityBill.toString(),
                        decoration: const InputDecoration(labelText: 'Monthly Electricity Bill (₹)'),
                        keyboardType: TextInputType.number,
                        onSaved: (val) => monthlyElectricityBill = double.tryParse(val ?? '0') ?? 0,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: vehicleType,
                        decoration: const InputDecoration(labelText: 'Vehicle Type'),
                        items: ['Petrol Car', 'Diesel Car', 'Motorcycle', 'EV', 'Public Transport', 'None']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => vehicleType = val!),
                        onSaved: (val) => vehicleType = val ?? 'Petrol Car',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: dailyCommuteKm.toString(),
                        decoration: const InputDecoration(labelText: 'Daily Commute (km)'),
                        keyboardType: TextInputType.number,
                        onSaved: (val) => dailyCommuteKm = double.tryParse(val ?? '0') ?? 0,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: foodPreference,
                        decoration: const InputDecoration(labelText: 'Food Preference'),
                        items: ['Vegetarian', 'Mixed', 'Non-Vegetarian']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => foodPreference = val!),
                        onSaved: (val) => foodPreference = val ?? 'Mixed',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: flightsPerYear.toString(),
                        decoration: const InputDecoration(labelText: 'Flights Per Year'),
                        keyboardType: TextInputType.number,
                        onSaved: (val) => flightsPerYear = int.tryParse(val ?? '0') ?? 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'Analyze Carbon Footprint',
                  icon: Icons.analytics,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
