import 'package:flutter/material.dart';
import 'package:itec_parking/scr/parkingFees.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingsiteScreen extends StatelessWidget {
  const ParkingsiteScreen({super.key});
  Future<void> _launchCommunication(String type) async {
    Uri? uri;

    try {
      switch (type) {
        case 'email':
          uri = Uri.parse('mailto:munyembugajd@gmail.com');
          break;
        case 'phone':
          uri = Uri.parse('tel:+250784857700');
          break;
        case 'whatsapp':
          // Fix the WhatsApp URL format
          uri = Uri.parse('whatsapp://send?phone=250784857700');
          break;
        case 'messagephone':
          // Fix the WhatsApp URL format
          uri = Uri.parse('sms:0784857700');
          break;
        default:
          return;
      }

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // Show a snackbar or alert to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA77D55),
        title:
            const Text('Parking site', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Type Rates Card
              GestureDetector(
                onTap: () => _navigateToParkingDetails(context, 'CHIC'),
                child: _buildTariffCard(
                  title: 'Parking Site',
                  icon: Icons.directions_car,
                  rates: [
                    {'label': 'Parking Site', 'value': 'CHIC'},
                    {'label': 'Location', 'value': 'Location'},
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => _navigateToParkingDetails(context, 'Kacyiru'),
                child: _buildTariffCard(
                  title: 'Parking Site',
                  icon: Icons.directions_car,
                  rates: [
                    {'label': 'Parking Site', 'value': 'Kacyiru'},
                    {'label': 'Location', 'value': 'Location'},
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => _navigateToParkingDetails(context, 'Nyabugongo'),
                child: _buildTariffCard(
                  title: 'Parking Site',
                  icon: Icons.directions_car,
                  rates: [
                    {'label': 'Parking Site', 'value': 'Nyabugongo'},
                    {'label': 'Location', 'value': 'Location'},
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => _navigateToParkingDetails(context, 'Kigali'),
                child: _buildTariffCard(
                  title: 'Parking Site',
                  icon: Icons.directions_car,
                  rates: [
                    {'label': 'Parking Site', 'value': 'Kigali'},
                    {'label': 'Location', 'value': 'Location'},
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Contact Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFA77D55).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Need Assistance?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                        onTap: () => _launchCommunication("phone"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.phone, color: Color(0xFFA77D55)),
                            SizedBox(width: 8),
                            Text(
                              '+25 078 367 890',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    const SizedBox(height: 8),
                    GestureDetector(
                        onTap: () => _launchCommunication("email"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.email, color: Color(0xFFA77D55)),
                            SizedBox(width: 8),
                            Text(
                              'info@itec.com',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation function to handle card taps
  void _navigateToParkingDetails(BuildContext context, String parkingName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParkingDetailsScreen(parkingName: parkingName),
      ),
    );
  }

  Widget _buildTariffCard({
    required String title,
    required IconData icon,
    required List<Map<String, String>> rates,
  }) {
    return Card(
      elevation: 0, // Added elevation to make the card more "clickable" looking
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFA77D55), size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Adding an arrow icon to indicate the card is clickable
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFA77D55),
                  size: 16,
                ),
              ],
            ),
            const Divider(height: 24),
            ...rates
                .map((rate) => _buildTariffRow(
                      rate['label']!,
                      rate['value']!,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTariffRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA77D55),
            ),
          ),
        ],
      ),
    );
  }
}
