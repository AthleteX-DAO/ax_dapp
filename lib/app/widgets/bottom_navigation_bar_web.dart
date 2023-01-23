import 'package:ax_dapp/pages/footer/simple_tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomNavigationBarWeb extends StatelessWidget {
  const BottomNavigationBarWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Center(
        child: Row(
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 20,
                  child: InkWell(
                    child: const Text('athletex.io'),
                    onTap: () => launchUrl(
                      Uri.parse(
                        'https://www.athletex.io/',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      //Discord button
                      launchUrl(
                    Uri.parse(
                      'https://discord.com/invite/WFsyAuzp9V',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.discord,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://twitter.com/athletex_dao?s=20',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.twitter,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://github.com/SportsToken',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.github,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.instagram.com/athletexmarkets/?hl=en',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.instagram,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                IconButton(
                  onPressed: () => launchUrl(
                    Uri.parse(
                      'https://www.tiktok.com/@athlete_x',
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.tiktok,
                    size: 25,
                    color: Colors.grey[400],
                  ),
                ),
                Container(width: _width - 500),
                AppToolTip(
                  'Invest in what you know best at AthleteX Markets.',
                  IconButton(
                    onPressed: () => launchUrl(
                      Uri.parse(
                        'https://athletex-markets.gitbook.io/athletex-huddle/start-here/litepaper',
                      ),
                    ),
                    icon: FaIcon(
                      FontAwesomeIcons.circleQuestion,
                      size: 25,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
