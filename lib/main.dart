import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'about_page.dart'; // ✅ Added import for About Page

void main() {
  runApp(XYCalculatorApp());
}

class XYCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XY Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: Colors.teal,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
      // ✅ Add this routes map
      routes: {
        '/developer-details': (context) => DeveloperDetailsPage(),
      },
      home: XYCalculatorPage(),
    );
  }
}

class XYCalculatorPage extends StatefulWidget {
  @override
  _XYCalculatorPageState createState() => _XYCalculatorPageState();
}

class _XYCalculatorPageState extends State<XYCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController xController = TextEditingController();
  final TextEditingController yController = TextEditingController();

  String resultX = '';
  String resultY = '';
  bool _isCalculating = false;
  bool _showResult = false;

  List<double> parseValues(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .map((e) => double.tryParse(e))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  void calculate() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isCalculating = true;
      _showResult = false;
      resultX = '';
      resultY = '';
    });

    await Future.delayed(Duration(milliseconds: 500)); // Small delay to show spinner

    final xValues = parseValues(xController.text);
    final yValues = parseValues(yController.text);

    if (xValues.isEmpty || yValues.isEmpty) {
      setState(() {
        resultX = 'Enter valid numbers for X and Y.';
        resultY = '';
        _isCalculating = false;
        _showResult = true;
      });
      return;
    }

    double avgX = xValues.reduce((a, b) => a + b) / xValues.length;
    double avgY = yValues.reduce((a, b) => a + b) / yValues.length;

    avgX = double.parse(avgX.toStringAsFixed(2));
    avgY = (avgY * 100).ceilToDouble() / 100;

    double finalX = avgX + 50;
    double finalY = avgY + 30;

    setState(() {
      resultX = 'X = ${finalX.toStringAsFixed(2)}';
      resultY = 'Y = ${finalY.toStringAsFixed(2)}';
      _isCalculating = false;
      _showResult = true;
    });
  }

  String? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter values';
    }
    final parts = value.split(',');
    for (var part in parts) {
      if (part.trim().isEmpty) continue;
      if (double.tryParse(part.trim()) == null) {
        return 'Invalid number: "${part.trim()}"';
      }
    }
    return null;
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    super.dispose();
  }

  void _openDeveloperDetails() {
    Navigator.of(context).push(_createFadeRoute(DeveloperDetailsPage()));
  }

  void _openAboutPage() {
    Navigator.of(context).push(_createFadeRoute(AboutPage())); // ✅ Navigate to About Page
  }

  Route _createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XY Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Developer Details',
            icon: Icon(Icons.developer_mode_outlined, color: Colors.teal),
            onPressed: _openDeveloperDetails,
          ),
          IconButton(
            tooltip: 'About App',
            icon: Icon(Icons.info_outline, color: Colors.teal), // ✅ New About button
            onPressed: _openAboutPage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Enter X Values:', style: theme.textTheme.titleMedium),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: xController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '140.04, 140.04',
                          prefixIcon: Icon(Icons.linear_scale),
                        ),
                        validator: validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(height: 24),
                      Text('Enter Y Values:', style: theme.textTheme.titleMedium),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: yController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: '129.96, 129.96',
                          prefixIcon: Icon(Icons.linear_scale_outlined),
                        ),
                        validator: validator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isCalculating
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 2),
                  )
                      : Icon(Icons.calculate, color: Colors.teal),
                  label: Text(
                    _isCalculating ? 'Calculating...' : 'Calculate',
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                  onPressed: _isCalculating ? null : calculate,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              SizedBox(height: 30),
              AnimatedOpacity(
                opacity: _showResult ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: (_showResult)
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Calculated Output Results',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.teal),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          if (resultX.isNotEmpty)
                            Text(
                              resultX,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                          if (resultY.isNotEmpty)
                            Text(
                              resultY,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeveloperDetailsPage extends StatelessWidget {
  final String facebookUrl = 'fb://facewebmodal/f?href=https://facebook.com/hacku2day';
  final String fallbackFacebookUrl = 'https://facebook.com/hacku2day';
  final String whatsappNumber = '+8801734173832';
  final String telegramUsername = 'nonigopalchandro';

  void _launchFacebook() async {
    if (await canLaunchUrl(Uri.parse(facebookUrl))) {
      await launchUrl(Uri.parse(facebookUrl));
    } else {
      await launchUrl(Uri.parse(fallbackFacebookUrl), mode: LaunchMode.externalApplication);
    }
  }

  void _launchWhatsapp() async {
    final whatsappUrl = 'whatsapp://send?phone=${whatsappNumber.replaceAll('+', '')}';
    final fallbackUrl = 'https://wa.me/${whatsappNumber.replaceAll('+', '')}';
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    }
  }

  void _launchTelegram() async {
    final telegramUrl = 'tg://resolve?domain=$telegramUsername';
    final fallbackUrl = 'https://t.me/$telegramUsername';
    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl));
    } else {
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Developer Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/images/developer.jpg'),
                  ),
                ),
                SizedBox(height: 24),
                Text('Developed By:', style: theme.textTheme.titleMedium),
                Text(
                  'Noni Gopal Chandro',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                SizedBox(height: 16),
                InfoRow(label: 'Role:', value: 'Full Stack Web and Mobile App Developer'),
                InfoRow(label: 'Address:', value: 'Roghunathpur Ghatpara, Parbatipur, Dinajpur'),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Contact Now',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.teal.shade700),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue.shade800),
                      iconSize: 36,
                      tooltip: 'Facebook',
                      onPressed: _launchFacebook,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green.shade700),
                      iconSize: 36,
                      tooltip: 'WhatsApp',
                      onPressed: _launchWhatsapp,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.telegram, color: Colors.blue),
                      iconSize: 36,
                      tooltip: 'Telegram',
                      onPressed: _launchTelegram,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}