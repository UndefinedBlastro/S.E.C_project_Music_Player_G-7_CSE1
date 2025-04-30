import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:singularity/CustomWidgets/drawer.dart';
import 'package:singularity/Screens/Home/saavn.dart';
import 'package:singularity/Screens/Search/search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool rotated = MediaQuery.sizeOf(context).height < screenWidth;
    return SafeArea(
      child: Stack(
        children: [
          NestedScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxScrolled,
            ) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  stretch: true,
                  toolbarHeight: 65,
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, child) {
                        return GestureDetector(
                          child: AnimatedContainer(
                            width: MediaQuery.sizeOf(context).width -
                                (rotated ? 0 : 75),
                            height: 55.0,
                            duration: const Duration(
                              milliseconds: 150,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            // margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              color: Theme.of(context).cardColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5.0,
                                  offset: Offset(1.5, 1.5),
                                  // shadow direction: bottom right
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  CupertinoIcons.search,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!
                                      .searchText,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .color,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchPage(
                                query: '',
                                fromHome: true,
                                autofocus: true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ];
            },
            body: SaavnHomePage(),
          ),
          if (!rotated)
            homeDrawer(
              context: context,
              padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            ),
        ],
      ),
    );
  }
}
