import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:papi_burgers/common_ui/classic_text_field.dart';
import 'package:papi_burgers/constants/color_palette.dart';
import 'package:papi_burgers/constants/sized_box.dart';

@RoutePage()
class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: OrderDetailsContent(),
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
  const OrderDetailsContent({super.key});

  @override
  State<OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  TextEditingController controller = TextEditingController();
  bool isChoosedAsap = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LightContainerField(
          controller: controller,
          prefixIcon: Icons.phone,
          hintText: 'Телефон',
          onTap: () {},
        ),
        h16,
        LightTextField(
          controller: controller,
          prefixIcon: Icons.person,
          hintText: 'Имя',
        ),
        h16,
        LightContainerField(
          controller: controller,
          prefixIcon: Icons.phone,
          hintText: 'Выбор адреса',
          onTap: () {},
        ),
        h16,
        LightTextField(
          size: 88,
          controller: controller,
          prefixIcon: Icons.comment,
          hintText: 'Примечания к заказу (код двери, доп инфо..)',
        ),
        h16,
        ChoosingContainer(
          isAsap: true,
          isChoosed: isChoosedAsap,
          onChoose: () {
            setState(() {
              isChoosedAsap = true;
            });
          },
        ),
        ChoosingContainer(
          isAsap: false,
          isChoosed: !isChoosedAsap,
          onChoose: () {
            setState(() {
              isChoosedAsap = false;
            });
          },
        ),
      ],
    );
  }
}

class ChoosingContainer extends StatelessWidget {
  final bool isAsap;
  final String time;
  final bool isChoosed;
  final void Function()? onChoose;
  const ChoosingContainer({
    super.key,
    this.isAsap = false,
    this.time = 'Выбрать дату и время доставки',
    this.isChoosed = false,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChoose,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isChoosed ? const Color.fromARGB(255, 250, 250, 250) : greyf1,
          borderRadius: isAsap
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
          border: isAsap
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
              Image.asset('assets/${isAsap ? 'courier' : 'alarm'}_icon.png'),
              w20,
              Expanded(
                flex: 13,
                child: Text(
                  isAsap ? 'Доставить как можно быстрее' : time,
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
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(Icons.circle_outlined, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
