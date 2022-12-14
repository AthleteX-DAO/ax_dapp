import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DropdownMenuMobile extends StatefulWidget {
  const DropdownMenuMobile({super.key});

  @override
  State<DropdownMenuMobile> createState() => _DropdownMenuMobileState();
}

class _DropdownMenuMobileState extends State<DropdownMenuMobile> {
  String? dropdownValue = '';
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text(
              'Help',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://athletex-markets.gitbook.io/athletex-huddle/start-here/litepaper',
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.earthAmericas,
            ),
            title: Text(
              'Website',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://www.athletex.io/',
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.github,
            ),
            title: Text(
              'GitHub',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://github.com/SportsToken',
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.discord,
            ),
            title: Text(
              'Discord',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://discord.com/invite/WFsyAuzp9V',
            ),
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.twitter,
            ),
            title: Text(
              'Twitter',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://twitter.com/athletex_dao?s=20',
            ),
          ),
        ),
        PopupMenuItem(
          value: 6,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.instagram,
              size: 25,
            ),
            title: Text(
              'Instagram',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://www.instagram.com/athletexmarkets/?hl=en',
            ),
          ),
        ),
        PopupMenuItem(
          value: 7,
          child: const ListTile(
            leading: FaIcon(
              FontAwesomeIcons.tiktok,
              size: 25,
            ),
            title: Text(
              'TikTok',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => launchUrl(
            Uri.parse(
              'https://www.tiktok.com/@athlete_x',
            ),
          ),
        ),
        PopupMenuItem(
          value: 8,
          child: const ListTile(
            leading: Icon(Icons.share),
            title: Text(
              'Share',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          onTap: () => _shareApplication(context),
        ),
      ],
      icon: const Icon(Icons.more_horiz),
      offset: const Offset(0, 45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _shareApplication(BuildContext context) {
    const applicationUrl = 'https://app.athletex.io/#/';
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      applicationUrl,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
