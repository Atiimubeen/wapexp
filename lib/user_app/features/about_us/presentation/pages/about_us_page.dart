import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // Helper function to launch URLs
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About Wapexp')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Icon(
              Icons
                  .business_center_outlined, // Aap yahan apna logo bhi laga sakte hain
              size: 80,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Wapexp Institute of IT',
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Empowering the Future with Technology',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.7),
            ),
          ),
          const Divider(height: 48),

          _buildSectionTitle(context, 'Our Mission'),
          const SizedBox(height: 12),
          _buildSectionContent(
            context,
            'Our mission is to provide high-quality, accessible, and affordable IT education to empower individuals with the skills needed to succeed in the digital world. We are committed to fostering a learning environment that encourages innovation, creativity, and practical problem-solving.',
          ),

          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Our Vision'),
          const SizedBox(height: 12),
          _buildSectionContent(
            context,
            'To be a leading IT training institute recognized for producing highly skilled professionals who can make a significant impact in the global tech industry. We envision a future where every student has the opportunity to achieve their full potential.',
          ),

          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Connect With Us'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                onTap: () => _launchURL(
                  'https://www.facebook.com/Wapexp.Institute.of.IT',
                ),
              ),
              _buildSocialButton(
                icon: Icons.camera_alt_outlined,
                label: 'Instagram',
                onTap: () =>
                    _launchURL('https://www.instagram.com/wapexpinstitute'),
              ),
              _buildSocialButton(
                icon: Icons.chat_bubble_outline,
                label: 'WhatsApp',
                onTap: () => _launchURL('https://wa.me/+923269909794'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context, String content) {
    return Text(
      content,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(radius: 30, child: Icon(icon, size: 30)),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
