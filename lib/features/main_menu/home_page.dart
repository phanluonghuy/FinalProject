import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/widgets/topic_item.dart';
import 'package:finalproject/features/profile/view_profile_page.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/auth_repo.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/features/auth/login_page.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthRepo _auth = AuthRepo();
  UserRepo _userRepo = UserRepo();
  final TopicRepo _topicRepo = TopicRepo();
  UserModel? user;
  late Future<UserModel?> userFuture =
      _userRepo.getUserByID(FirebaseAuth.instance.currentUser!.uid);

  List<TopicModel> _topics = [];
  List<TopicModel> _topicsFollowing = [];
  List<UserModel?> _suggestFollowing = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        user = await _userRepo.getUserByID(currentUser.uid);
        _topics = await _topicRepo.getAllPublicTopics();
        _topicsFollowing = await _topicRepo.getTopicFromYouFollowing(user!);
        _suggestFollowing = await _userRepo.suggestFollowing(user!);

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: SliverSearchAppBar(snapshot.data!),
                    pinned: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'images/poster.png',
                          )),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10),
                      child: Text(
                        "Hot topics",
                        style: AppTextStyles.bold20,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        addAutomaticKeepAlives: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (_topics.length < 5) ? _topics.length : 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 200,
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: TopicItem(topic: _topics.elementAt(index)),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                      child: Text(
                        "Topics from your following",
                        style: AppTextStyles.bold20,
                      ),
                    ),
                  ),
                  (_topicsFollowing.isNotEmpty)
                      ? SliverToBoxAdapter(
                          child: SizedBox(
                            height: 150,
                            child: ListView.builder(
                              addAutomaticKeepAlives: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: (_topicsFollowing.length < 5)
                                  ? _topicsFollowing.length
                                  : 5,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 200,
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: TopicItem(
                                      topic: _topicsFollowing.elementAt(index)),
                                );
                              },
                            ),
                          ),
                        )
                      : const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 110,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                  "SORRY !!! No topics from your following 😭 \n You can find more friends",
                                  style: AppTextStyles.bold20,
                                textAlign: TextAlign.center,
                                ),
                            ),
                          ),

                        ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 10, top: 10),
                      child: Text(
                        "People may you know",
                        style: AppTextStyles.bold20,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                        addAutomaticKeepAlives: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: (_suggestFollowing.length < 5)
                            ? _suggestFollowing.length
                            : 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 280,
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.grey4, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewProfilePage(
                                          userID: _suggestFollowing
                                                  .elementAt(index)
                                                  ?.id ??
                                              ''), // Pass the user object to ViewProfilePage
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(_suggestFollowing
                                          .elementAt(index)
                                          ?.name ??
                                      ""),
                                  leading: Container(
                                    height: 40, // Specify the desired height
                                    width: 40,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: _suggestFollowing
                                                  .elementAt(index)
                                                  ?.avatarUrl ??
                                              '',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle:
                                              StrutStyle(fontSize: 12.0),
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              text: _suggestFollowing
                                                      .elementAt(index)
                                                      ?.bio ??
                                                  ""),
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final UserModel userModel;
  SliverSearchAppBar(this.userModel);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
        shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.5;
    double topPadding = MediaQuery.of(context).padding.top + 16;
    final isShrink = shrinkOffset > 0;

    return Stack(
      children: [
        const BackgroundWave(
          height: 280,
        ),
        Positioned(
          top: topPadding + offset,
          child: const SearchBar(
            hintText: 'Start topic search',
            hintStyle: MaterialStatePropertyAll(AppTextStyles.normal16),
            leading: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            padding: MaterialStatePropertyAll(EdgeInsets.only(left: 20)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          left: 16,
          right: 16,
        ),
        Positioned(
          top: topPadding,
          left: 20,
          child: AnimatedOpacity(
            opacity: isShrink ? 0.0 : 1.0,
            duration:
                const Duration(milliseconds: 200), // Adjust animation speed
            curve: Curves.easeInOut, // Adjust animation curve
            child: Row(children: [
              Text("Hi, " + userModel.name! + "\nLet's find new topics",
                  style: AppTextStyles.boldWhite20),
              SizedBox(width: MediaQuery.of(context).size.width / 4),
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    CachedNetworkImageProvider(userModel.avatarUrl!),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}

class BackgroundWave extends StatelessWidget {
  final double height;

  const BackgroundWave({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFFF6EFE9)],
            )),
          )),
    );
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    const minSize = 140.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.4, size.height);
    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}
