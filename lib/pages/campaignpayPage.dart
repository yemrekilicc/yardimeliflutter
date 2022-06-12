import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yardimeliflutter/Model/ModelCampaign.dart';
import 'package:yardimeliflutter/pages/addbalancePage.dart';
import 'package:flutter/services.dart';
import '../API/paytocampaignApiService.dart';
import '../animation/horizontalScrollAnimation.dart';
import '../authprovider.dart';

class campaignpayPage extends ConsumerStatefulWidget {
  final Campaign campaign;
  const campaignpayPage(this.campaign,{Key? key}) : super(key: key);

  @override
  _campaignpayPageState createState() => _campaignpayPageState();
}

class _campaignpayPageState extends ConsumerState<campaignpayPage> {
  paytocampaignApi payApi=paytocampaignApi();

  final paycontoller=TextEditingController();

  @override
  void dispose() {
    paycontoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authprovider = ref.watch(authProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Hero(
            tag: "yardimelibaslik",
            child: Material(
              color: Color(0xff7f0000),
              child: Text(
                "yardım eli ",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),
            )
        ),
        backgroundColor: Color(0xff7f0000),
      ),
      body: Column(
        children: [
          Material(
            elevation: 8,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                size: 70,
                              ))
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Bakiye",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                              Text(
                                "0.0 TL",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff7f0000),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 2,
                    height: 0,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Color(0xff7f0000),
                                  width: 2)
                              )
                          ),
                        foregroundColor: MaterialStateProperty.all<Color>(Color(0xff7f0000)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => addbalacePage(),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 300),
                            ),
                          );
                    },
                        child: Text("Cüzdana bakiye yükle")),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: horizontalSrollAnimation(
                        animationtext: Text(
                          widget.campaign.name,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8,right: 8,bottom: 8),
                    child: Text(
                      "${widget.campaign.limit} ₺ hedefin ${widget.campaign.currentMoney} ₺'si toplandı.",
                      style: TextStyle(color: Color(0xff5e5e5e)),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 2,
                    height: 0,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                      child: Text("Bağışta bulunmak istediğiniz tutarı giriniz")
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        width: 60,
                        child: TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
                          ],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          controller: paycontoller,
                          style: TextStyle(
                              fontSize: 22,
                          ),
                        ),
                      ),
                      Text(
                        "₺",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7f0000),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 75,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 12,right: 12,bottom: 30),
                    child: ElevatedButton(onPressed: () {
                      if(paycontoller.text!="" ){
                        showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            content: Text("${paycontoller.text} ₺ tutarında bağışta bulunacaktır"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("İptal et")),
                              ElevatedButton(
                                  onPressed: () async{
                                    var req= await payApi.paytocampaign(userprovider, widget.campaign.id, paycontoller.text);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Bağışta bulun")),
                            ],
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                        );
                      }
                      else{
                        showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            content: Text("Lütfen tutar giriniz"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("kapat")
                              )],
                            elevation: 10,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                        );

                      }
                    child: ElevatedButton(onPressed: () async{
                      var req= await payApi.paytocampaign(authprovider, widget.campaign.id, paycontoller.text);
                      print(req);
                    },
                        child: Text("Bağışta bulun"),
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
