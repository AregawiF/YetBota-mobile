import 'package:flutter/material.dart';
import 'package:yetbota_mobile/common/ui/widgets/bottom_nav.dart';
import 'package:yetbota_mobile/features/ai_assistant/presentation/pages/ai_assistant_chat_page.dart';
import 'package:yetbota_mobile/features/discovery_feed/presentation/pages/community_qa_page.dart';
import 'package:yetbota_mobile/features/location_feed/presentation/pages/create_location_post_page.dart';
import 'package:yetbota_mobile/features/location_feed/presentation/pages/location_feed_page.dart';
import 'package:yetbota_mobile/features/profile/presentation/pages/profile_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  final GlobalKey<NavigatorState> _feedKey = GlobalKey<NavigatorState>(
    debugLabel: 'feed',
  );
  final GlobalKey<NavigatorState> _qnaKey = GlobalKey<NavigatorState>(
    debugLabel: 'qna',
  );
  final GlobalKey<NavigatorState> _assistantKey = GlobalKey<NavigatorState>(
    debugLabel: 'assistant',
  );
  final GlobalKey<NavigatorState> _profileKey = GlobalKey<NavigatorState>(
    debugLabel: 'profile',
  );

  BottomNavItem _activeTab = BottomNavItem.feed;

  GlobalKey<NavigatorState> _keyFor(BottomNavItem item) {
    return switch (item) {
      BottomNavItem.feed => _feedKey,
      BottomNavItem.qna => _qnaKey,
      BottomNavItem.assistant => _assistantKey,
      BottomNavItem.profile => _profileKey,
    };
  }

  int _indexFor(BottomNavItem item) {
    return switch (item) {
      BottomNavItem.feed => 0,
      BottomNavItem.qna => 1,
      BottomNavItem.assistant => 2,
      BottomNavItem.profile => 3,
    };
  }

  void _popCurrentTabToRoot() {
    _keyFor(_activeTab).currentState?.popUntil((route) => route.isFirst);
  }

  void _onTabTapped(BottomNavItem item) {
    if (item == _activeTab) {
      _popCurrentTabToRoot();
      return;
    }
    final previousTab = _activeTab;
    setState(() => _activeTab = item);
    // Clear pushed routes
    _keyFor(previousTab).currentState?.popUntil((route) => route.isFirst);
  }

  void _onFabTapped() {
    _keyFor(_activeTab).currentState?.push<void>(
      MaterialPageRoute<void>(builder: (_) => const CreateLocationPostPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IndexedStack(
            index: _indexFor(_activeTab),
            children: [
              Navigator(
                key: _feedKey,
                onGenerateInitialRoutes:
                    (NavigatorState navigator, String initialRoute) {
                      return <Route<dynamic>>[
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(name: '/'),
                          builder: (_) => const LocationFeedPage(),
                        ),
                      ];
                    },
              ),
              Navigator(
                key: _qnaKey,
                onGenerateInitialRoutes:
                    (NavigatorState navigator, String initialRoute) {
                      return <Route<dynamic>>[
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(name: '/'),
                          builder: (_) => const CommunityQaPage(),
                        ),
                      ];
                    },
              ),
              Navigator(
                key: _assistantKey,
                onGenerateInitialRoutes:
                    (NavigatorState navigator, String initialRoute) {
                      return <Route<dynamic>>[
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(name: '/'),
                          builder: (_) => AiAssistantChatPage(
                            onBackFromRoot: () =>
                                _onTabTapped(BottomNavItem.feed),
                          ),
                        ),
                      ];
                    },
              ),
              Navigator(
                key: _profileKey,
                onGenerateInitialRoutes:
                    (NavigatorState navigator, String initialRoute) {
                      return <Route<dynamic>>[
                        MaterialPageRoute<void>(
                          settings: const RouteSettings(name: '/'),
                          builder: (_) => ProfilePage(
                            onBackFromRoot: () =>
                                _onTabTapped(BottomNavItem.feed),
                          ),
                        ),
                      ];
                    },
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomNav(
            activeItem: _activeTab,
            onItemTapped: _onTabTapped,
            onPrimaryActionTap: _onFabTapped,
          ),
        ),
      ],
    );
  }
}
