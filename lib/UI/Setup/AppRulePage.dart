import 'package:flutter/material.dart';

class AppRulePage extends StatelessWidget {
  const AppRulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('앱 이용규칙')),
      body: appRule()
    );
  }

  Widget appRule() {
    return ListView(
      children: [

        ruleText('앱 이용규칙', appRuleText),
        SizedBox(height: 15),
        ruleText('공통 금지사항', dontDoingText),
        SizedBox(height: 15),
        ruleText('공지사항 이용규칙', noticeRuleText),
        SizedBox(height: 15),
        ruleText('알림장 이용규칙', allimRuleText),
        SizedBox(height: 15),
        ruleText('일정표 이용규칙', calendarRuleText),
        SizedBox(height: 15),
        ruleText('면회 관리 이용규칙', visitRuleText),
        SizedBox(height: 15),
        ruleText('한마디 이용규칙', commentRuleText),

      ],
    );
  }

  Widget ruleText(String title, String content) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,10,5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.2
          ),
          SizedBox(height: 6),
          Text(content)
        ],
      ),
    );
  }

  final String appRuleText = '''
요양원 알리미 이용규칙은 쾌적한 서비스 운영을 위해 주기적으로 업데이트됩니다.
이용자가 운영 시스템, 금지 행위, 게시물 작성 · 수정 · 삭제 규칙 등 이용규칙을 숙지하지 않아 발생하는 피해에 대하여 회사의 고의 또는 중대한 과실이 없는 한 어떠한 책임도 지지 않습니다.

해당 이용규칙은 2023년 5월 22일에 개정되었습니다.
''';

  final String dontDoingText = '''
밑의 사항은 반드시 숙지하시기 바랍니다.
준수하지 않을 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.
  
① 욕설, 비하, 차별, 혐오, 폭력이 관련된 내용 금지
② 음란물, 성적 수치심을 유발하는 내용 금지
③ 정치, 사회 관련 내용 금지
④ 불법 촬영물 유통 금지
⑤ 홍보, 판매 관련 내용 금지 (요양원 알리미와 사전에 미리 협의된 경우 제외)
''';

  final String noticeRuleText = '''
모든 공지사항은 요양원 측에서 작성합니다.
'공통 금지사항'에 포함된 내용을 게시할 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.

게시물을 작성할 수 있는 권한을 가진 자는 게시한 내용이 변경되었을 경우, 보호자들이 혼란스럽지 않게 신속히 수정 또는 삭제 부탁드립니다.
''';

  final String allimRuleText = '''
모든 알림장은 요양원 측에서 작성합니다.
'공통 금지사항'에 포함된 내용을 게시할 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.
''';

  final String calendarRuleText = '''
모든 일정은 요양원 측에서 작성합니다.
'공통 금지사항'에 포함된 내용을 게시할 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.

게시물을 작성할 수 있는 권한을 가진 자는 게시한 내용이 변경되었을 경우, 보호자들이 혼란스럽지 않게 신속히 수정 또는 삭제 부탁드립니다.
''';

  final String visitRuleText = '''
면회 신청 시 '공통 금지사항'에 포함된 내용을 게시할 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.

보호자는 신청한 면회 시간에 제때 방문해주세요.
면회가 완료되었다면, 요양원 측에서 [완료] 버튼을 눌러 방문 완료 상태를 표시해주세요.
''';

  final String commentRuleText = '''
보호자는 요양보호사에게 간단한 메시지를 전달할 수 있습니다.
'공통 금지사항'에 포함된 내용을 게시할 경우, 별도의 통지 없이 서비스 이용이 일정 기간 제한될 수 있습니다.
''';
}
