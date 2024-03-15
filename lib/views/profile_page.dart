import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:papi_burgers/common_ui/user_orders_box.dart';
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

  late Stream<QuerySnapshot<Object?>>? stream;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> getOrdersStream() async {
    if (uid != null) {
      stream = FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: uid)
          .snapshots();
    }
  }

  @override
  void initState() {
    super.initState();
    getOrdersStream();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyf1,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    user != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  setState(() {
                                    uid = null;
                                  });
                                },
                                child: const Text(
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
                    h20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.receipt_long),
                        w12,
                        Text(
                          'История заказов',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              h10,
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 7),
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 231, 231, 231),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      uid != null
                          ? SizedBox(
                              height: 200,
                              child: StreamBuilder<QuerySnapshot>(
                                stream: stream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.hasData) {
                                    final List<QueryDocumentSnapshot>
                                        documents = snapshot.data!.docs;
                                    return ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        var order = documents[index];
                                        int orderLength =
                                            order['menuItems'].length;
                                        String status;
                                        switch (order['orderStatus']) {
                                          case 'waiting':
                                            status = 'Ожидание';

                                            break;
                                          case 'confirmed':
                                            status = 'Подтверждено';

                                            break;
                                          case 'payed':
                                            status = 'Оплачено';

                                            break;
                                          case 'notPayed':
                                          case 'canceled':
                                            status = 'Отменено';

                                            break;
                                          default:
                                            status = 'Ошибка статуса';

                                            break;
                                        }
                                        Timestamp timestamp = order['datetime'];
                                        int seconds = timestamp.seconds;
                                        DateTime dateTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                seconds * 1000);
                                        String formattedDate =
                                            DateFormat.yMMMd().format(dateTime);

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              showOrderDetails(
                                                  context: context,
                                                  itemCount: orderLength,
                                                  dishName: order['menuItems']
                                                      [index]['name'],
                                                  quantity: order['menuItems']
                                                      [index]['quantity'],
                                                  price: order['menuItems']
                                                      [index]['price'],
                                                  totalPrice:
                                                      order['totalPrice'],
                                                  status: status,
                                                  isTakeAway:
                                                      order['isTakeAway'] ==
                                                              true
                                                          ? 'Самовывоз'
                                                          : 'Доставка',
                                                  date: formattedDate);
                                            },
                                            child: UserOrdersBox(
                                                date: '12.03.2024',
                                                dishCount: 5,
                                                totalPrice: 11234,
                                                type: 'Не оплачено'),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  return Text('not found');
                                },
                              ),
                            )
                          : const SizedBox(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showOrderDetails({
    required BuildContext context,
    required int itemCount,
    required String dishName,
    required int quantity,
    required int price,
    required String status,
    required int totalPrice,
    required String date,
    required String isTakeAway,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Детали заказа'),
          content: Container(
            width: MediaQuery.of(context).size.width - 40,
          height: 270,
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: ListView.builder(

                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(dishName),
                        subtitle: Text('$quantity шт./$price ₽'),
                        trailing: Text(
                          '${quantity * price}₽',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      );
                    },
                  ),
                ),
              h10,
                Container(
                  height: 1,
                  width: 200,
                  color: Colors.grey,
                ),
                h10,
                ParametersOrder(text: 'Дата', value: date),
                h6,
                ParametersOrder(text: 'Тип заказа', value: isTakeAway),
                 h6,
                ParametersOrder(text: 'Статус', value: status),
                 h6,
                ParametersOrder(
                    text: 'Полная стоимость', value: '$totalPrice ₽'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ОК'),
            ),
          ],
        );
      },
    );
  }
}

class ParametersOrder extends StatelessWidget {
  final String text;
  final String value;
  const ParametersOrder({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
