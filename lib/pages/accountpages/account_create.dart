import 'package:i_account/bill/models/account_model.dart';
import 'package:i_account/res/colours.dart';
import 'package:flutter/material.dart';
import 'package:i_account/widgets/appbar.dart';
import 'package:i_account/router_jump.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_account/widgets/my_pickertool.dart';
import 'package:i_account/widgets/highlight_well.dart';
import 'package:flutter/services.dart';
import 'package:i_account/db/db_helper.dart';

class AccountCreatePage extends StatefulWidget {
  @override
  _AccountCreatePageState createState() =>
      _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {

  TextEditingController _accountName = new TextEditingController();
  TextEditingController _accountAmount = new TextEditingController();
  var _typePickerData = ["资产账户", "负债账户"];
  String _accountType = '';
  int _accountTypeDB = 0;

  _buildAppBarTitle() {
    return Container(
      child: ButtonTheme(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          '创建账户',
          style: TextStyle(
              fontSize: 18,
              color: Colours.app_main,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
    ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
      ..init(context);
    return Scaffold(
      appBar: MyAppBar(
        titleWidget: _buildAppBarTitle(),
        actionName: "确定",
        onPressed: () async{
          if(_accountName.text.isNotEmpty){
            AccountClassification dba = new AccountClassification(_accountName.text, _accountTypeDB,balance: double.parse(_accountAmount.text));
            int idReturn = await dbHelp.insertAccount(dba);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RouterJump()), ModalRoute.withName('/'));
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[idReturn != -1? Text("账户创建成功！") : Text("已有同名账户！")],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"),
                    ),
                  ],
                );
              },
            ).then((val) {
              print(val);
            });
          }else{
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("提示"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[Text("账户名不能为空！")],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("确定"),
                    ),
                  ],
                );
              },
            ).then((val) {
              print(val);
            });
          }
        },
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("账户名称", style: TextStyle(fontSize: 18),),
            ),
            TextField(
              decoration: new InputDecoration(
                hintText: "请输入账户名称",
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid),
                ),
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
              controller: _accountName,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              textCapitalization: TextCapitalization.sentences,
            ),
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("账户类型", style: TextStyle(fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: HighLightWell(
                onTap: () {
                  MyPickerTool.showStringPicker(context,
                      data: _typePickerData,
                      normalIndex: 0,
                      title: "请选择", clickCallBack: (int index, var str) {
                        setState(() {
                          _accountType = str;
                          _accountTypeDB = index;
                          print(_accountTypeDB);
                        });
                      });
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colours.gray, width: 0.6)),
                  child: Text(_accountType.isEmpty ? '资产账户' : _accountType),
                ),
              ),
            ),
            Container(
              height: 48,
              padding: EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              child: Text("初始金额", style: TextStyle(fontSize: 18),),
            ),
            TextField(
                decoration: new InputDecoration(
                  hintText: "请输入初始金额",
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid),
                  ),
                  prefixIcon: Icon(Icons.input),
                ),
                controller: _accountAmount,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters:[
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  _MyNumberTextInputFormatter(digit:2),
                ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MyNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;
  ///允许的小数位数，-1代表不限制位数
  int digit;
  _MyNumberTextInputFormatter({this.digit=-1});
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }
  ///获取目前的小数位数
  static int getValueDigit(String value){
    if(value.contains(".")){
      return value.split(".")[1].length;
    }else{
      return -1;
    }
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if(value=="-"){
      value = "-";
      selectionIndex++;
    }else if (value != "" &&
        value != defaultDouble.toString() &&
        strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}


