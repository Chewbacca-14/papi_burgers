import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/common_ui/classic_long_button.dart';
import 'package:papi_burgers/common_ui/notification_card.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null; // User not found
      }
    } catch (e) {
      return null;
    }
  }

  String name = 'Вы не авторизованы';
  String phoneNumber = '';
  late bool isUserExists;
  User? user = FirebaseAuth.instance.currentUser;
  void fetchUserData() async {
    if (user != null) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic>? userData = await getUserData(uid);
      if (userData != null) {
        setState(() {
          name = userData['name'];
          phoneNumber = userData['phone'];
        });
      }
    }
  }

  late var stream;
  String? uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .snapshots();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyf1,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                user != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              setState(() {});
                            },
                            child: Text(
                              'Выйти',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 30),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 228, 228, 228)
                            .withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 241, 241, 241),
                      size: 40,
                    ),
                  ),
                ),
                user != null ? SizedBox(height: 20) : SizedBox(),
                user != null ? SizedBox() : SizedBox(height: 20),
                user != null
                    ? Text(
                        name.substring(0, 1).toUpperCase() +
                            name.substring(1).toLowerCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : ClassicLongButton(
                        onTap: () {
                          context.mounted
                              ? context.router.push(const LoginRoute())
                              : null;
                        },
                        buttonText: 'Войти'),
                h6,
                user != null
                    ? Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 153, 153, 153),
                        ),
                      )
                    : SizedBox(),
                h25,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 41),
                  child: NotificationCard(),
                ),
                h16,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 41),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 241, 241, 241),
                      ),
                    ),
                    child: ClassicLongButton(
                        onTap: () {
                          context.router.push(const UserAddressesRoute());
                        },
                        buttonText: 'Мои адреса'),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.hasData) {
                        final List<QueryDocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final dishName =
                                documents[index]['menuItems'][index]['name'];
                            return ListTile(
                              title: Text(dishName),
                            );
                          },
                        );
                      }

                      return Text('No orders found for this user.');
                    },
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
