import 'package:flutter/material.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용약관'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '슈포마켓은 사용자가 아래와 같이 잘못된 방법이나 행위로 서비스를 이용할 경우 사용에 대한 제재(이용정지, 강제탈퇴 등)를 가할 수 있습니다.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '1. 잘못된 방법으로 서비스의 제공을 방해하거나 슈포마켓이 안내하는 방법 이외의 다른 방법을 사용하여 슈포마켓 서비스에 접근하는 행위\n'
                  '2. 다른 이용자의 정보를 무단으로 수집, 이용하거나 다른 사람들에게 제공하는 행위\n'
                  '3. 서비스를 영리나 홍보 목적으로 이용하는 행위\n'
                  '4. 음란 정보나 저작권 침해 정보 등 공서양속 및 법령에 위반되는 내용의 정보 등을 발송하거나 게시하는 행위\n'
                  '5. 슈포마켓의 동의 없이 슈포마켓 서비스 또는 이에 포함된 소프트웨어의 일부를 복사, 수정, 배포, 판매, 양도, 대여, 담보제공하거나 타인에게 그 이용을 허락하는 행위\n'
                  '6. 소프트웨어를 역설계하거나 소스 코드의 추출을 시도하는 등 슈포마켓 서비스를 복제, 분해 또는 모방하거나 기타 변형하는 행위\n'
                  '7. 관련 법령, 슈포마켓의 모든 약관 또는 운영정책을 준수하지 않는 행위\n',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '개인정보 보호 관련',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '개인정보는 슈포마켓 서비스의 원활한 제공을 위하여 사용자가 동의한 목적과 범위 내에서만 이용됩니다. 개인정보 보호 관련 기타 상세한 사항은 슈포마켓 웹사이트의 개인정보처리방침을 참고하시기 바랍니다.',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 20.0),
            Text(
              '게시물의 저작권 보호',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(
              '슈포마켓 서비스 사용자가 서비스 내에 게시한 게시물의 저작권은 해당 게시물의 저작자에게 귀속됩니다.\n\n'
                  '사용자가 서비스 내에 게시하는 게시물은 검색결과 내지 서비스 및 관련 프로모션, 광고 등에 노출될 수 있으며, 해당 노출을 위해 필요한 범위 내에서는 일부 수정, 복제, 편집되어 게시될 수 있습니다. 이 경우, 슈포마켓은 저작권법 규정을 준수하며, 사용자는 언제든지 고객센터 또는 운영자 문의 기능을 통해 해당 게시물에 대해 삭제, 검색결과 제외, 비공개 등의 조치를 요청할 수 있습니다.\n\n'
                  '위 이외의 방법으로 사용자의 게시물을 이용하고자 하는 경우에는 전화, 팩스, 전자우편 등을 통해 사전에 사용자의 동의를 얻어야 합니다.',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
