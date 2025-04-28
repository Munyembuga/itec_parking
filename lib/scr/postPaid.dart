import 'package:flutter/material.dart';

class PostpaidScreen extends StatefulWidget {
  const PostpaidScreen({super.key});

  @override
  State<PostpaidScreen> createState() => _PostpaidScreenState();
}

class _PostpaidScreenState extends State<PostpaidScreen> {
  final TextEditingController _licensePlateController = TextEditingController();
  bool _showRenewalForm = false;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedPlan = 'Monthly';

  @override
  void dispose() {
    _licensePlateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _researchLicensePlate() {
    // Here you would typically make an API call to get license plate data
    // For now, we'll just show the renewal form
    setState(() {
      _showRenewalForm = true;
    });

    // Simulate finding license plate data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'License plate ${_licensePlateController.text} found. Please complete renewal form.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _submitRenewalForm() {
    // Here you would handle form submission
    // For demonstration, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subscription renewal form submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset the form
    setState(() {
      _showRenewalForm = false;
      _licensePlateController.clear();
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
      _selectedPlan = 'Monthly';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA77D55),
        title: const Text('Post paid', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // License Plate Research Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFfbf7f4),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Research License Plate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _licensePlateController,
                    decoration: InputDecoration(
                      labelText: 'License Plate Number',
                      hintText: 'Enter license plate number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.directions_car),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _researchLicensePlate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Renewal Form Section (conditionally shown)
            if (_showRenewalForm) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFfbf7f4),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Subscription Renewal Form',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem('Full Name :', 'Itec Rwanda'),
                    const SizedBox(height: 8),
                    _buildInfoItem('Phone Number :', '+250784857700'),
                    const SizedBox(height: 8),
                    _buildInfoItem('Plate Number :', 'RAD780P'),
                    const SizedBox(height: 8),
                    _buildInfoItem('Perking Name :', 'CHIC '),
                    const SizedBox(height: 16),
                    const Text(
                      'Select Subscription Plan:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPlan,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Monthly',
                            child: Text('Monthly Plan (20000 RWF/month)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPlan = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitRenewalForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA77D55),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit Renewal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
