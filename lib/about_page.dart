import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About This App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.teal),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XY Calculator',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'This application is a custom calculator designed for '
                      'technicians who operate specific machines. The app helps '
                      'calculate output sizes based on input X and Y values. '
                      'It applies the required formula and adjustments so that '
                      'technicians can use the results directly on the machine.',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 20),
                Text(
                  'Key Features:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 10),
                BulletPoint(text: 'Enter multiple X and Y values separated by commas'),
                BulletPoint(text: 'Automatic validation of input numbers'),
                BulletPoint(text: 'Applies custom logic to generate final output'),
                BulletPoint(text: 'Lightweight and simple to use for technicians'),
                SizedBox(height: 20),
                Text(
                  'Disclaimer:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'This calculator is intended for use by trained technicians only. '
                      'The results are for assisting machine operations and should be '
                      'verified before practical use. The developer is not responsible '
                      'for incorrect usage or machine settings.',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 30),

                // ✅ Clickable text -> opens existing DeveloperDetailsPage via named route
                Center(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/developer-details'),
                    child: Text(
                      'Developed by Noni Gopal Chandro',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        color: Colors.teal.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
              )),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
