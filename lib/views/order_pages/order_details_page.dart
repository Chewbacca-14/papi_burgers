import 'dart:async';
import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/common_ui/price_info_sheet.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';
import 'package:papi_burgers/constants/statuses.dart';
import 'package:papi_burgers/controllers/show_custom_snackbar.dart';
import 'package:papi_burgers/db/db_helper.dart';
import 'package:papi_burgers/models/address_model.dart';
import 'package:papi_burgers/models/order.dart';
import 'package:papi_burgers/providers/date_picker_provider.dart';
import 'package:papi_burgers/providers/delivery_price_provider.dart';
import 'package:papi_burgers/providers/order_address_provider.dart';
import 'package:papi_burgers/providers/order_provider.dart';
import 'package:papi_burgers/providers/order_type_provider.dart';
import 'package:papi_burgers/router/app_router.dart';
import 'package:papi_burgers/views/date_picker/date_picker.dart';
import 'package:provider/provider.dart';

@RoutePage()
class OrderDetailsPage extends StatefulWidget {
  final List<OrderModel> order;
  const OrderDetailsPage({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  TextEditingController controller = TextEditingController();
  bool isChoosedAsap = false;
  bool isChoosedOnlinePayment = true;
  String time = 'Выбрать дату и время';
  int dishPrice = 0;
  int totalPrice = 0;
  String? userPhone = 'Телефон';

  Map<String, dynamic> orderModelToMap(
      {required OrderModel order,
      required String phone,
      required Address address,
      required String name,
      required String comment,
      required DateTime datetime,
      required bool isCashPayment,
      required String orderStatus,
      required String paymentStatus,
      required bool isTakeAway,
      required String whenDeliveryOrTake,
      required String orderID}) {
    return {
      'userId': order.userId,
      'orderID': orderID,
      'menuItems': order.menuItems.map((menuItem) => menuItem.toMap()).toList(),
      'deliveryPrice': order.deliveryPrice,
      'totalPrice': order.totalPrice,
      'phone': phone,
      'address': {
        'id': address.id,
        'address': address.address,
        'frontDoorNumber': address.frontDoorNumber,
        'numberFlat': address.numberFlat,
        'floor': address.floor,
        'comment': address.comment,
      },
      'name': name,
      'comment': comment,
      'datetime': datetime,
      'isCashPayment': isCashPayment,
      'orderStatus': getStringFromStatus(OrderStatuses.created),
      'whenDeliveryOrTakeAway': whenDeliveryOrTake,
      'paymentStatus': paymentStatus,
      'isTakeAway': isTakeAway,
    };
  }

  Future<String> generateOrderNumber() async {
    // Generate a random 8-digit number
    String randomDigits =
        Random().nextInt(100000000).toString().padLeft(8, '0');

    // Concatenate 'PB' with the random digits
    String orderNumber = 'PB$randomDigits';

    // Check if the order number exists in Firestore
    bool exists = await checkIfOrderExists(orderNumber);

    // If the order number already exists, recursively generate a new one
    if (exists) {
      return generateOrderNumber();
    }

    return orderNumber;
  }

  Future<bool> checkIfOrderExists(String orderNumber) async {
    final CollectionReference ordersCollection =
        FirebaseFirestore.instance.collection('orders');
    try {
      var querySnapshot =
          await ordersCollection.where('orderID', isEqualTo: orderNumber).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking order existence: $e');
      return false;
    }
  }

  void addOrdersToFirestore({
    required List<OrderModel> orders,
    required String phone,
    required Address address,
    required String name,
    required String comment,
    required DateTime datetime,
    required bool isCashPayment,
    required String orderStatus,
    required String whenDeliveryOrTake,
    required String paymentStatus,
    required bool isTakeAway,
    required String orderID,
  }) {
    final firestore = FirebaseFirestore.instance;
    OrderProvider orderProvider =
        Provider.of<OrderProvider>(context, listen: false);

    for (final order in orderProvider.orders) {
      final orderData = orderModelToMap(
          orderID: orderID,
          order: order,
          phone: phone,
          address: address,
          name: name,
          comment: comment,
          datetime: datetime,
          isCashPayment: isCashPayment,
          orderStatus: orderStatus,
          whenDeliveryOrTake: whenDeliveryOrTake,
          isTakeAway: isTakeAway,
          paymentStatus: paymentStatus);
      firestore.collection('orders').add(orderData);
    }
  }

  Future<void> getUsersPhone() async {
    setState(() {
      userPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    getUsersPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeProvider = context.watch<DateTimeProvider>();
    final selectedDate = dateTimeProvider.selectedDate;
    final selectedHour = dateTimeProvider.selectedHour;
    final selectedMinute = dateTimeProvider.selectedMinute;
    OrderAddressProvider orderAddressProvider =
        Provider.of<OrderAddressProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            h16,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Оформление заказа',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            h16,
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                ),
                child: OrderDetailsContent(
                  nameController: nameController,
                  orders: widget.order,
                  time: time,
                  isChoosedAsap: isChoosedAsap,
                  isChoosedOnlinePayment: isChoosedOnlinePayment,
                  controller: controller,
                  dishPrice: dishPrice,
                  userPhone: userPhone,
                  totalPrice: totalPrice,
                  commentController: commentController,
                  addToFirebase: () async {
                    String orderID = await generateOrderNumber();
                    addOrdersToFirestore(
                      orders: widget.order,
                      phone: userPhone!,
                      address: orderAddressProvider.orderAddress,
                      name: nameController.text,
                      comment: commentController.text,
                      whenDeliveryOrTake: isChoosedAsap
                          ? 'Как можно быстрее'
                          : '$selectedDate в $selectedHour:${selectedMinute.toString().padLeft(2, '0')}',
                      isCashPayment: !isChoosedOnlinePayment,
                      orderStatus: 'created',
                      paymentStatus: 'LATER',
                      isTakeAway: true,
                      datetime: DateTime.now(),
                      orderID: orderID,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetailsContent extends StatefulWidget {
  final List<OrderModel> orders;
  final void Function()? addToFirebase;
  final TextEditingController nameController;
  final TextEditingController controller;
  final TextEditingController commentController;
  bool isChoosedAsap;
  bool isChoosedOnlinePayment;
  String time;
  int dishPrice;
  int totalPrice;
  String? userPhone;
  OrderDetailsContent({
    super.key,
    required this.orders,
    required this.addToFirebase,
    required this.nameController,
    required this.controller,
    required this.isChoosedAsap,
    required this.isChoosedOnlinePayment,
    required this.time,
    required this.dishPrice,
    required this.totalPrice,
    this.userPhone,
    required this.commentController,
  });

  @override
  State<OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  Future<void> calculatePrice() async {
    DeliveryPriceProvider deliveryPriceProvider =
        Provider.of<DeliveryPriceProvider>(context, listen: false);
    int getDishPrice = await DatabaseHelper.instance.calculatePrice();
    setState(() {
      widget.dishPrice = getDishPrice;
      widget.totalPrice =
          widget.dishPrice + deliveryPriceProvider.deliveryPrice;
    });
  }

  Future<void> getUsersPhone() async {
    setState(() {
      widget.userPhone = FirebaseAuth.instance.currentUser?.phoneNumber;
    });
  }

  int counter = 0;
  Timer? timer;
  void startTimer() {
    const period = Duration(seconds: 1);
    timer = Timer.periodic(period, (Timer t) {
      calculatePrice();
      setState(() {
        counter++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    calculatePrice();
    startTimer();
    getUsersPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeProvider = context.watch<DateTimeProvider>();
    final selectedDate = dateTimeProvider.selectedDate;
    final selectedHour = dateTimeProvider.selectedHour;
    final selectedMinute = dateTimeProvider.selectedMinute;
    DeliveryPriceProvider deliveryPriceProvider =
        Provider.of<DeliveryPriceProvider>(context, listen: true);
    bool isDelivery =
        Provider.of<OrderTypeProvider>(context, listen: true).isDelivery;
    OrderAddressProvider orderAddressProvider =
        Provider.of<OrderAddressProvider>(context, listen: true);
    if (!widget.isChoosedAsap) {
      setState(() {
        if (selectedMinute.toString().length == 1) {
          widget.time = '$selectedDate в $selectedHour:0$selectedMinute';
        } else {
          widget.time = '$selectedDate в $selectedHour:$selectedMinute';
        }
      });
    }
    return Stack(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      h20,
                      LightContainerField(
                        controller: widget.controller,
                        prefixIcon: Icons.phone,
                        hintText: widget.userPhone!,
                        onTap: () {},
                      ),
                      h16,
                      LightTextField(
                        controller: widget.nameController,
                        prefixIcon: Icons.person,
                        hintText: 'Имя',
                      ),
                      h16,
                      isDelivery
                          ? LightContainerField(
                              controller: widget.controller,
                              prefixIcon: Icons.phone,
                              hintText:
                                  orderAddressProvider.orderAddress.address,
                              onTap: () {
                                context.router.push(UserAddressesRoute(
                                    returnOrderDetails: true,
                                    orders: widget.orders));
                              },
                            )
                          : const SizedBox(),
                      isDelivery ? h16 : const SizedBox(),
                      LightTextField(
                        size: 88,
                        controller: widget.commentController,
                        prefixIcon: Icons.comment,
                        hintText: 'Примечания к заказу (код двери, доп инфо..)',
                      ),
                      h16,
                      ChoosingContainer(
                        isTopContainer: true,
                        isChoosed: widget.isChoosedAsap,
                        time: 'Как можно быстрее',
                        onChoose: () {
                          setState(() {
                            widget.isChoosedAsap = true;
                          });
                        },
                      ),
                      ChoosingContainer(
                        isTopContainer: false,
                        time: widget.time,
                        isChoosed: !widget.isChoosedAsap,
                        onChoose: () {
                          setState(() {
                            widget.isChoosedAsap = false;
                          });
                          dateTaxiBottomSheet(
                              context: context, minTime: 3, maxTime: 22);
                        },
                      ),
                      h16,
                      ChoosingContainer(
                        isPaymentMethodContainers: true,
                        isTopContainer: true,
                        isChoosed: !widget.isChoosedOnlinePayment,
                        time: 'Оплата наличными',
                        onChoose: () {
                          setState(() {
                            widget.isChoosedOnlinePayment = false;
                          });
                        },
                      ),
                      ChoosingContainer(
                        isPaymentMethodContainers: true,
                        isTopContainer: false,
                        time: 'Онлайн оплата',
                        isChoosed: widget.isChoosedOnlinePayment,
                        onChoose: () {
                          setState(() {
                            widget.isChoosedOnlinePayment = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PriceInfoSheet(
            extraIngredientsPrice: 0,
            isOrderDetailsPage: true,
            deliveryPrice: deliveryPriceProvider.deliveryPrice,
            dishPrice: widget.dishPrice,
            totalPrice: widget.totalPrice,
            onTap: () {
              int currentHour = DateTime.now().hour;
              int currentMinutes = DateTime.now().minute;
              int currentDay = DateTime.now().day;
              var now = DateTime.now();
              var formatter = DateFormat('dd.MM.yyyy');
              var currentFormattedDate = formatter.format(now);
              if (!widget.isChoosedAsap &&
                  (selectedDate.contains('$currentDay') ||
                      selectedDate.contains(currentFormattedDate)) &&
                  (currentHour > selectedHour ||
                      (currentHour == selectedHour &&
                          currentMinutes >= selectedMinute))) {
                showCustomSnackBar(context, 'Отредактируйте время заказ',
                    AnimatedSnackBarType.error);
              } else {
                if (widget.nameController.text.isEmpty) {
                  showCustomSnackBar(
                      context, 'Заполните имя', AnimatedSnackBarType.error);
                } else if (orderAddressProvider.orderAddress.address ==
                        'Выберите адрес' &&
                    isDelivery) {
                  showCustomSnackBar(context, 'Выберите адрес доставки',
                      AnimatedSnackBarType.error);
                } else {
                  context.router.replace(const OrderConfirmationRoute());
                  widget.addToFirebase?.call();
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class ChoosingContainer extends StatelessWidget {
  final bool isTopContainer;
  final bool isPaymentMethodContainers;
  final String time;
  final bool isChoosed;
  final void Function()? onChoose;
  const ChoosingContainer(
      {super.key,
      required this.isTopContainer,
      required this.time,
      this.isChoosed = false,
      required this.onChoose,
      this.isPaymentMethodContainers = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChoose,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isChoosed ? const Color.fromARGB(255, 250, 250, 250) : greyf1,
          borderRadius: isTopContainer
              ? const BorderRadius.only(
                  topLeft: Radius.circular(
                    16,
                  ),
                  topRight: Radius.circular(16),
                )
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    16,
                  ),
                  bottomRight: Radius.circular(16),
                ),
          border: isTopContainer
              ? const Border(
                  left: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                  top: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                )
              : const Border(
                  left: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                  bottom: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                  right: BorderSide(
                    width: 1,
                    color: greyf1,
                  ),
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Image.asset(
                  'assets/${isTopContainer && !isPaymentMethodContainers ? 'courier' : !isTopContainer && !isPaymentMethodContainers ? 'alarm' : isTopContainer && isPaymentMethodContainers ? 'wallet' : 'credit_card'}_icon.png'),
              w20,
              Expanded(
                flex: 13,
                child: Text(
                  time,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isChoosed ? Colors.black : Colors.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const Spacer(),
              isChoosed
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
