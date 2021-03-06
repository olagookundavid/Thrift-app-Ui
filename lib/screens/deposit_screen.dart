// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:thrift_project/resources/dialogues.dart';
import 'package:thrift_project/services/deposit_service.dart';
import '../widgets/rounded_button.dart';
import '../widgets/text_input_fields.dart';

class DepositPage extends StatelessWidget {
  DepositPage({Key? key}) : super(key: key);
  final TextEditingController cardNo = TextEditingController();
  final TextEditingController amountNo = TextEditingController();
  final TextEditingController accountNo = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Enter Deposit',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                TextNumInputField(
                  hintText: 'Card Number',
                  controller: cardNo,
                  isbold: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextNumInputField(
                  hintText: 'Account Number  (optional)',
                  controller: accountNo,
                  isbold: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextNumInputField(
                  hintText: 'Amount',
                  controller: amountNo,
                ),
                const SizedBox(
                  height: 15,
                ),
                ClickableButton(
                  press: () async {
                    bool isDeposit = await DepositService()
                        .deposit(cardNo.text, accountNo.text, amountNo.text);
                    if (isDeposit) {
                      await successDialog(context, 'Transfer successful');
                    }
                    await showErrorDialog(context, 'Transfer failed');
                  },
                  text: 'Deposit',
                ),
                const Spacer(),
                const Image(image: AssetImage('assets/logo.png')),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Thrift safely with us',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
