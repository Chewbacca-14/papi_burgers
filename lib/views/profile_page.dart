import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papi_burgers/common_ui/order_info.dart';
import 'package:papi_burgers/common_ui/user_orders_box.dart';
import 'package:papi_burgers/constants/statuses.dart';
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
                                  setState(() {});
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
                        : const SizedBox(),
                    const SizedBox(height: 30),
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
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 241, 241, 241),
                          size: 40,
                        ),
                      ),
                    ),
                    user != null
                        ? const SizedBox(height: 20)
                        : const SizedBox(),
                    user != null
                        ? const SizedBox()
                        : const SizedBox(height: 20),
                    user != null
                        ? Text(
                            name.substring(0, 1).toUpperCase() +
                                name.substring(1).toLowerCase(),
                            style: const TextStyle(
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 153, 153, 153),
                            ),
                          )
                        : const SizedBox(),
                    h25,
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 41),
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
                            height: 25,
                            onTap: () {
                              context.router
                                  .push(UserAddressesRoute(orders: const []));
                            },
                            buttonText: 'Мои адреса'),
                      ),
                    ),
                    h20,
                    user != null
                        ? const Row(
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
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const Spacer(),
              user != null
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 252,
                          width: MediaQuery.of(context).size.width,
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
                                  color:
                                      const Color.fromARGB(255, 231, 231, 231),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              uid != null
                                  ? Expanded(
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
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
                                                Color statusColor;
                                                IconData statusIcon;

                                                OrderStatuses orderStatuses;

                                                orderStatuses =
                                                    getStatusFromString(
                                                        order['orderStatus']);
                                                status = getStatusText(
                                                    orderStatuses);
                                                statusColor =
                                                    getColorFromStatusText(
                                                        orderStatuses);
                                                statusIcon =
                                                    getIconDataFromStatusText(
                                                        orderStatuses);

                                                Timestamp timestamp =
                                                    order['datetime'];
                                                int seconds = timestamp.seconds;
                                                DateTime dateTime = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        seconds * 1000);
                                                String formattedDate =
                                                    DateFormat.yMMMd()
                                                        .format(dateTime);
                                                int dishCountTotal =
                                                    order['menuItems'].length;

                                                List<Widget> menuItemsWidgets =
                                                    [];

                                                for (var menuItem
                                                    in order['menuItems']) {
                                                  int quantity =
                                                      menuItem['quantity'];
                                                  menuItemsWidgets.add(
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          List<dynamic>
                                                              extraIngredientsList =
                                                              menuItem[
                                                                      'extraIngredientsList'] ??
                                                                  [];
                                                          double totalPrice =
                                                              extraIngredientsList.fold(
                                                                  0,
                                                                  (previousValue,
                                                                          element) =>
                                                                      previousValue +
                                                                      element[
                                                                          "price"]);

                                                          // showOrderDetails(
                                                          //     extraIngredientsList:
                                                          //         extraIngredientsList
                                                          //             .cast(),
                                                          //     extraIngredientsPrice:
                                                          //         totalPrice
                                                          //             .toInt(),
                                                          //     orderID:
                                                          //         order['orderID'],
                                                          //     context: context,
                                                          //     itemCount:
                                                          //         orderLength,
                                                          //     dishName:
                                                          //         menuItem['name'],
                                                          //     quantity: menuItem[
                                                          //         'quantity'],
                                                          //     price:
                                                          //         menuItem['price'],
                                                          //     totalPrice: order[
                                                          //         'totalPrice'],
                                                          //     status: status,
                                                          //     isTakeAway:
                                                          //         order['isTakeAway'] ==
                                                          //                 true
                                                          //             ? 'Самовывоз'
                                                          //             : 'Доставка',
                                                          //     date: formattedDate);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderInfoPage(
                                                                // extraIngredients:
                                                                //     order['menuItems']
                                                                //                 [
                                                                //                 index]
                                                                //             [
                                                                //             'extraIngredientsList'] ??
                                                                //         [],
                                                                createdAt:
                                                                    formattedDate,
                                                                deliveryPrice:
                                                                    250,
                                                                isPayedByCard:
                                                                    false,
                                                                isTakeAway: order[
                                                                    'isTakeAway'],
                                                                menuList: order[
                                                                    'menuItems'],
                                                                orderNumber: order[
                                                                    'orderID'],
                                                                restarantAddress:
                                                                    'Later Adress Restaurant',
                                                                restaurantName:
                                                                    'Later Name Restaurant',
                                                                status: status,
                                                                totalPrice: order[
                                                                    'totalPrice'],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: UserOrdersBox(
                                                            statusIcon:
                                                                statusIcon,
                                                            orderStatus: status,
                                                            color: statusColor,
                                                            date: formattedDate,
                                                            dishCount:
                                                                dishCountTotal *
                                                                    quantity,
                                                            totalPrice: order[
                                                                'totalPrice'],
                                                            type:
                                                                'Не оплачено'),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Column(
                                                  children: menuItemsWidgets,
                                                );
                                              },
                                            );
                                          }

                                          return const Text('not found');
                                        },
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          )),
                    )
                  : const SizedBox(),
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
    required int extraIngredientsPrice,
    required int price,
    required String status,
    required int totalPrice,
    required String date,
    required String isTakeAway,
    required String orderID,
    required List<Map<String, dynamic>> extraIngredientsList,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String extraIngredientsString = concatenateItems(extraIngredientsList);
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text(
            'Заказ №$orderID',
            style: const TextStyle(fontSize: 16),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 70,
            height: 370,
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
                        subtitle: Text(extraIngredientsString),
                        // subtitle: Text(
                        //   '$quantity шт./$price ₽',
                        // ),
                        trailing: Text(
                          '${quantity * (price + extraIngredientsPrice)}₽',
                          style: const TextStyle(
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
              child: const Text('ОК'),
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
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

String concatenateItems(List<dynamic> items) {
  return items.map((item) => '${item['name']} - ${item['price']}₽').join(' ');
}
