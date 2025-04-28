import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class IBMScreen extends StatefulWidget {
  const IBMScreen({super.key});

  @override
  State<IBMScreen> createState() => _IBMScreenState();
}

class _IBMScreenState extends State<IBMScreen> {
  TextEditingController searchController = TextEditingController();
  bool showResults = false;
  int selectedVehicle = 1; // Default selected vehicle
  bool isGeneratingPdf = false;
  int? processingCardIndex; // Track which card is being processed

  // Date range controllers
  DateTime? startDate;
  DateTime? endDate;

  // Sample data for results
  final List<Map<String, String>> resultData = [
    {
      'transId': '120',
      'customer': 'JDeDieu',
      'plateNumber': 'RAD300P',
      'parkingSite': 'MIC',
    },
    {
      'transId': '121',
      'customer': 'JDeDieu',
      'plateNumber': 'RAD300P',
      'parkingSite': 'MIC',
    },
    {
      'transId': '122',
      'customer': 'JDeDieu',
      'plateNumber': 'RAD300P',
      'parkingSite': 'MIC',
    },
  ];

  void performSearch() {
    setState(() {
      showResults = true;
    });
  }

  // Function to pick date range
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFA77D55),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  // Format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get temporary directory for PDF generation
  Future<Directory> _getTemporaryDirectory() async {
    return await getTemporaryDirectory();
  }

  // Generate PDF for a specific card
  Future<File> _generateCardPdf(Map<String, String> cardData) async {
    final pdf = pw.Document();

    // Add logo
    final ByteData byteData =
        await rootBundle.load('assets/images/itec_cone.png');
    final Uint8List logoBytes = byteData.buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 60, height: 60),
                  pw.Text('IBM Search Result',
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),

              // Search details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Search Details:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('License Plate: ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(searchController.text.isEmpty
                            ? 'N/A'
                            : searchController.text),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('Date Range: ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(startDate != null && endDate != null
                            ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                            : 'All dates'),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Result
              pw.Text('Result Details:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // Single Result Card
              _buildPdfResultCard(
                transId: cardData['transId'] ?? '',
                customer: cardData['customer'] ?? '',
                plateNumber: cardData['plateNumber'] ?? '',
                parkingSite: cardData['parkingSite'] ?? '',
              ),

              // Footer
              pw.Spacer(),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Generated on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Get temporary directory
    final directory = await _getTemporaryDirectory();

    // Create a filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final transId = cardData['transId'] ?? 'unknown';
    final plateText = cardData['plateNumber'] ?? 'unknown';
    final filename = 'ibm_result_${transId}_${plateText}_$timestamp.pdf';

    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Generate PDF for all results
  Future<File> _generateAllResultsPdf() async {
    final pdf = pw.Document();

    // Add logo
    final ByteData byteData =
        await rootBundle.load('assets/images/itec_cone.png');
    final Uint8List logoBytes = byteData.buffer.asUint8List();
    final logo = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 60, height: 60),
                  pw.Text('IBM Search Results',
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),

              // Search details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: pw.BorderRadius.circular(5),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Search Details:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('License Plate: ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(searchController.text.isEmpty
                            ? 'N/A'
                            : searchController.text),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.Row(
                      children: [
                        pw.Text('Date Range: ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(startDate != null && endDate != null
                            ? '${_formatDate(startDate)} - ${_formatDate(endDate)}'
                            : 'All dates'),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Results
              pw.Text('Results:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // All Result Cards
              for (int i = 0; i < resultData.length; i++) ...[
                _buildPdfResultCard(
                  transId: resultData[i]['transId'] ?? '',
                  customer: resultData[i]['customer'] ?? '',
                  plateNumber: resultData[i]['plateNumber'] ?? '',
                  parkingSite: resultData[i]['parkingSite'] ?? '',
                ),
                if (i < resultData.length - 1) pw.SizedBox(height: 10),
              ],

              // Footer
              pw.Spacer(),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Generated on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Get temporary directory
    final directory = await _getTemporaryDirectory();

    // Create a filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final plateText =
        searchController.text.isEmpty ? 'all' : searchController.text;
    final filename = 'ibm_results_${plateText}_$timestamp.pdf';

    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // PDF Result Card
  pw.Widget _buildPdfResultCard({
    required String transId,
    required String customer,
    required String plateNumber,
    required String parkingSite,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildPdfInfoRow('TransID', transId),
          _buildPdfInfoRow('Customer', customer),
          _buildPdfInfoRow('Plate number', plateNumber),
          _buildPdfInfoRow('Parking site', parkingSite),
        ],
      ),
    );
  }

  // PDF Info Row
  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // Share PDF for all results
  Future<void> _shareAllPdf() async {
    setState(() {
      isGeneratingPdf = true;
    });

    try {
      final file = await _generateAllResultsPdf();

      setState(() {
        isGeneratingPdf = false;
      });

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'IBM Search Results',
      );
    } catch (e) {
      setState(() {
        isGeneratingPdf = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Share PDF for a specific card
  Future<void> _shareCardPdf(int cardIndex) async {
    setState(() {
      processingCardIndex = cardIndex;
    });

    try {
      final file = await _generateCardPdf(resultData[cardIndex]);

      setState(() {
        processingCardIndex = null;
      });

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'IBM Search Result',
      );
    } catch (e) {
      setState(() {
        processingCardIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Share specific card result as text
  Future<void> _shareCardText(int cardIndex) async {
    final Map<String, String> cardData = resultData[cardIndex];

    // Generate content to share
    final shareText = 'IBM Search Result\n\n'
        'TransID: ${cardData['transId']}\n'
        'Customer: ${cardData['customer']}\n'
        'Plate Number: ${cardData['plateNumber']}\n'
        'Parking Site: ${cardData['parkingSite']}\n\n'
        'Search Details:\n'
        'License Plate: ${searchController.text}\n'
        'Date Range: ${startDate != null && endDate != null ? "${_formatDate(startDate)} - ${_formatDate(endDate)}" : "All dates"}';

    await Share.share(shareText, subject: 'IBM Search Result');
  }

  // Share all results as text
  Future<void> _shareAllText() async {
    // Generate content to share
    String shareText = 'IBM Search Results\n\n'
        'License Plate: ${searchController.text}\n'
        'Date Range: ${startDate != null && endDate != null ? "${_formatDate(startDate)} - ${_formatDate(endDate)}" : "All dates"}\n\n'
        'Results:\n';

    for (int i = 0; i < resultData.length; i++) {
      final cardData = resultData[i];
      shareText += '- TransID: ${cardData['transId']}, '
          'Customer: ${cardData['customer']}, '
          'Plate: ${cardData['plateNumber']}, '
          'Site: ${cardData['parkingSite']}\n';
    }

    await Share.share(shareText, subject: 'IBM Search Results');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA77D55),
        title: const Text('IBM', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'License Plate',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                          ),
                          onSubmitted: (_) => performSearch(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        onPressed: () {
                          performSearch();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (showResults)
                  // Date Range Selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Date Range:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDateRange(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'From: ${_formatDate(startDate)}',
                                        style: TextStyle(
                                            color: startDate == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDateRange(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To: ${_formatDate(endDate)}',
                                        style: TextStyle(
                                            color: endDate == null
                                                ? Colors.grey
                                                : Colors.black),
                                      ),
                                      const Icon(Icons.calendar_today,
                                          size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Filter results based on date range
                              if (startDate != null && endDate != null) {
                                // Apply date filter logic here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Filtering results from ${_formatDate(startDate)} to ${_formatDate(endDate)}',
                                    ),
                                    backgroundColor: const Color(0xFFA77D55),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please select a date range first'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA77D55),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Apply Filter'),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                if (!showResults)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Search for a license plate to see results',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Results header with actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              startDate != null && endDate != null
                                  ? 'Results for ${_formatDate(startDate)} - ${_formatDate(endDate)}'
                                  : 'All Results',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          // Action buttons for all results
                          Row(
                            children: [
                              // Share all as PDF button
                              isGeneratingPdf
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFA77D55)),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.picture_as_pdf,
                                          color: Color(0xFFA77D55)),
                                      tooltip: 'Share All Results as PDF',
                                      onPressed: _shareAllPdf,
                                    ),
                              // Share all as text button
                              // IconButton(
                              //   icon: const Icon(Icons.format_align_left,
                              //       color: Color(0xFFA77D55)),
                              //   tooltip: 'Share All Results as Text',
                              //   onPressed: _shareAllText,
                              // ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Results list with individual card actions
                      for (int i = 0; i < resultData.length; i++) ...[
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 4),
                                _buildInfoRow(
                                    'TransID', resultData[i]['transId'] ?? ''),
                                _buildInfoRow('Customer',
                                    resultData[i]['customer'] ?? ''),
                                _buildInfoRow('Plate number',
                                    resultData[i]['plateNumber'] ?? ''),
                                _buildInfoRow('Parking site',
                                    resultData[i]['parkingSite'] ?? ''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _shareCardPdf(i),
                                      child: Text(
                                        "Download the IBM file here",
                                        style: TextStyle(
                                          color: Color(0xFFA77D55),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    processingCardIndex == i
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFFA77D55)),
                                            ),
                                          )
                                        : IconButton(
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(
                                                Icons.picture_as_pdf,
                                                color: Color(0xFFA77D55)),
                                            tooltip: 'Share as PDF',
                                            onPressed: () => _shareCardPdf(i),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (i < resultData.length - 1)
                          const SizedBox(height: 8),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
