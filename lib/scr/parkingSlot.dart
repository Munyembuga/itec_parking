
import 'package:flutter/material.dart';

class ParkingSlotsScreen extends StatelessWidget {
  const ParkingSlotsScreen({super.key});

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
              _buildTariffCard(
                title: 'Parking Site ',
                icon: Icons.directions_car,
                rates: [
                  {'label': 'Parking Site','value' :'CHIC'},
                  {'label': 'Available', 'value': '102'},
                
                ],
              ),                

_buildTariffCard(
                title: 'Parking Site ',
                icon: Icons.directions_car,
                rates: [
                  {'label': 'Parking Site','value' :'Kacyiru'},
                  {'label': 'Available', 'value': '180'},
                
                ],
              ),
_buildTariffCard(
                title: 'Parking Site ',
                icon: Icons.directions_car,
                rates: [
                  {'label': 'Parking Site','value' :'Nyabugongo'},
                  {'label': 'Available', 'value': '160'},
                  
                ],
              ),
                _buildTariffCard(
                title: 'Parking Site ',
                icon: Icons.directions_car,
                rates: [
                  {'label': 'Parking Site','value' :'Kigali'},
                  {'label': 'Available', 'value': '100'},
                  
                ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone, color: Color(0xFFA77D55)),
                        SizedBox(width: 8),
                        Text(
                          '+25 078 367 890',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.email, color: Color(0xFFA77D55)),
                        SizedBox(width: 8),
                        Text(
                          'info@itec.com',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTariffCard({
    required String title,
    required IconData icon,
    required List<Map<String, String>> rates,
  }) {
    return Card(
      elevation: 0,
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

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
