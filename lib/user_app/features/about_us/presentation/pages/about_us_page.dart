import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  AboutUsPage({super.key});

  // Data for the expandable cards
  final Map<String, String> whoWeAreDetails = const {
    'WapExp':
        'WAPEXP is a company for Software Development, App Development, Artificial Intelligence, Data science, Web Development, Graphics designing and SEO which delivers exclusive and finest solutions to the clients being top internet marketing firm.',
    'Internet Marketing':
        'Established with the vision "To be the leading, dynamic & efficient Internet Marketing Services Providers collaborating with our customers in order to be their primary choice". Our definition of quality is "Complete Customer Satisfaction".',
    'Company Association':
        'We are a self-directed, autonomous, quality aware company having strong existence in the IT industry. We entirely apprehend and acknowledge the significance of our engagements and our association with our clients. Thus we have a devoted crew of exceedingly trained, competent and expert workforces',
  };

  final Map<String, String> whatWeDoDetails = const {
    'Graphic Design':
        'Graphic design is all around us. It is in our morning paper, all around our streets, and on the cover of our favorite books. We excel to pass the graphic design products to our cherished clients such as Logos, Websites, Business Cards, Advertisements, Book Design, Brochures, Billboards, Product Packaging, Posters, Magazine Layout, Newspaper Layout, Greeting Cards, Stationary design, Flyers, Calendars and all other digital or print media.',
    'Web Design':
        'Web design is the planning and creation of websites. We offer Distinctive, visually striking websites that involve operators, cheering them to repeatedly return to the site. Web designing includes the creation of new websites, regeneration of forgoing websites, web layouts and logos design using the latest technology up to the utmost client satisfaction.',
    'Web Development':
        'Web development is the back-end of the website. We make websites that are user and SEO friendly, can be navigated smoothly and use the latest web standards to ensure functionality across all modern browsers. We focus on how a site works and how the customers get things done on it for its small or large scale businesses or personal official websites. We develop static and dynamic sites using HTML, CSS, PHP, word press, joomla, Drupal, AJAX and jquery',
    'Content Writing':
        'SEO is a way of analyzing and building websites so that they can be found a lot easier when they are indexed by the Search Engines. SEO can help make the content on your website more relevant and easier to understand when the search engines are crawling your site and indexing the data. The SEO service provided by WAPEXP is ongoing, creating dynamic content on your site to ensure that search engines can easily find and index relevant content on your site.',
    'Software Development':
        'As an IT Service Provider, WAPEXP strives to provide our customers quality application development services that help them to remain in step with their competitors. For this, we practice modern software development platforms, application development tools as well as apply modern project management performances and software Development practices.',
    'SEO':
        'SEO is a way of analyzing and building websites so that they can be found a lot easier when they are indexed by the Search Engines. SEO can help make the content on your website more relevant and easier to understand when the search engines are crawling your site and indexing the data. The SEO service provided by WAPEXP is ongoing, creating dynamic content on your site to ensure that search engines can easily find and index relevant content on your site.',
    'App Development':
        'App development is the process of creating software applications that run on mobile devices, desktops, or web platforms. It involves designing user-friendly interfaces, building functional features, and ensuring seamless performance across various devices and operating systems. At WAPEXP, we specialize in designing and building apps that deliver seamless experiences and real-world solutions.WAPEXP is your trusted partner in bringing your vision to life.',
    'Artificial Intelligence':
        'Artificial Intelligence (AI) is the technology that enables machines to think, learn, and make decisions like humans. It is transforming the way we live and work by automating tasks, analyzing vast amounts of data, and delivering smarter, faster solutions across all industries.At WAPEXP, we don'
        't just build websites and apps — we build smart, future-ready solutions. That'
        's why we proudly offer Artificial Intelligence (AI) services to help businesses automate processes, gain deep insights, and deliver personalized user experiences.',
    'Data Science':
        'Data Science is the field of extracting meaningful insights from large sets of structured and unstructured data. By combining techniques from statistics, computer science, and machine learning, data science helps businesses make smarter, data-driven decisions.WAPEXP, we are proud to offer cutting-edge Artificial Intelligence (AI) and Data Science services to help businesses stay ahead in a rapidly evolving digital world.',
  };

  // Helper function to launch URLs (mailto, tel, https)
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
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('About Us'),
        // backgroundColor: colors.primary,
        // foregroundColor: colors.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Professional Header with Gradient
            _buildHeader(context),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Overview Card
                  _buildOverviewCard(context),
                  const SizedBox(height: 32),

                  // Who Are We Section
                  _buildSectionTitle(context, 'Who Are We?'),
                  const SizedBox(height: 16),
                  ...whoWeAreDetails.entries
                      .map(
                        (entry) => _buildExpansionCard(
                          context,
                          entry.key,
                          entry.value,
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 32),

                  // What We Do Section
                  _buildSectionTitle(context, 'Our Services'),
                  const SizedBox(height: 16),
                  ...whatWeDoDetails.entries
                      .map(
                        (entry) => _buildExpansionCard(
                          context,
                          entry.key,
                          entry.value,
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 32),

                  // Contact Info
                  _buildContactSection(context),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Reduced height for banner-style image
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with proper scaling for wide images
          ClipRect(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/aboutus.jpg',
                fit: BoxFit.fitWidth, // Changed to fitWidth for wide images
                width: double.infinity,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.business,
                        size: 80,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WAPEXP',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Digital Success Partner',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.business_center,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Leading IT Solutions Provider',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We deliver cutting-edge technology solutions that transform businesses and drive digital success across multiple industries.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionCard(
    BuildContext context,
    String title,
    String content,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        iconColor: colors.primary,
        collapsedIconColor: colors.onSurface.withOpacity(0.6),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: colors.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Get In Touch',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildContactRow(
              context,
              icon: Icons.person_outline,
              text: 'CEO: Mr. Salman Raza',
              color: Colors.indigo,
            ),
            const SizedBox(height: 16),

            _buildContactRow(
              context,
              icon: Icons.location_on_outlined,
              text:
                  '2nd Floor Ghauri Arcade Plaza, Saleemi chowk, Satayana Rd, Batala Colony, Faisalabad, 38000, Pakistan.',
              color: Colors.red,
            ),
            const SizedBox(height: 16),

            // Email
            _buildContactRow(
              context,
              icon: Icons.email_outlined,
              text: 'wapexp2@gmail.com',
              onTap: () => _launchURL('mailto:wapexp2@gmail.com'),
              color: Colors.blue,
            ),
            const SizedBox(height: 16),

            // Phone
            _buildContactRow(
              context,
              icon: Icons.phone_outlined,
              text: '+92 321 7658485',
              onTap: () => _launchURL('tel:+923217658485'),
              color: Colors.green,
            ),
            const SizedBox(height: 16),

            // WhatsApp
            _buildContactRow(
              context,
              icon: Icons.chat_bubble_outline,
              text: 'WhatsApp',
              onTap: () => _launchURL('https://wa.me/923217658485'),
              color: Colors.green[600]!,
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),

            // Social Media Section
            Text(
              'Follow Us',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _buildSocialButton(
                  context,
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchURL(
                    'https://www.facebook.com/Wapexp.Institute.of.IT',
                  ), // Replace with your Facebook URL
                ),
                const SizedBox(width: 12),
                _buildSocialButton(
                  context,
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchURL(
                    'https://www.instagram.com/wapexpinstitute',
                  ), // Replace with your Instagram URL
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap != null
                ? color.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          color: onTap != null
              ? color.withOpacity(0.05)
              : Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: onTap != null
                      ? color.withOpacity(0.9)
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: onTap != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            if (onTap != null)
              Icon(Icons.open_in_new, size: 16, color: color.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
