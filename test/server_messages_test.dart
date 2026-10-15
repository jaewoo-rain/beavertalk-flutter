// 2026-10-16 PM-DEC-674 보완 — 서버 한국어 오류 문구 사전(GET /i18n/server-messages).
import 'package:beavertalk/core/error/app_exception.dart';
import 'package:beavertalk/core/error/dio_error_mapper.dart';
import 'package:beavertalk/core/i18n/server_messages.dart';
import 'package:beavertalk/features/normalcall/presentation/normalcall_controller.dart';
import 'package:beavertalk/l10n/app_localizations_en.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final _bundle = <String, dynamic>{
  'locale': 'en',
  'messages': [
    {'key': 'a', 'codes': [], 'ko': '이미 완료한 과제입니다.', 'text': 'You have already completed this assignment.'},
    {'key': 'b', 'codes': [], 'ko': '이 차시({0})의 표현학습이 아직 끝나지 않았어요(status={1}).',
     'text': 'Expression learning for this lesson ({0}) isn\'t finished yet (status={1}).'},
    {'key': 'c', 'codes': [], 'ko': '순서 바꿈 {0} 그리고 {1}', 'text': '{1} then {0}'},
    {'key': 'd', 'codes': [], 'ko': '그대로', 'text': '그대로'},
  ],
  'payment_labels': {'subscription': 'Subscription payment'},
};

DioException _err(int status, Object data) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: RequestOptions(path: '/x'), statusCode: status, data: data),
    );

class _FailAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future<void>? cancelFuture) =>
      throw DioException.connectionError(requestOptions: options, reason: 'offline');
}

void main() {
  tearDown(ServerMessages.clear);

  test('사전이 없으면 원문 그대로', () {
    expect(ServerMessages.localize('이미 완료한 과제입니다.'), '이미 완료한 과제입니다.');
  });

  test('정확 일치 · 앞뒤 공백 무시 · 다른 문구는 원문', () {
    ServerMessages.applyBundle(_bundle);
    expect(ServerMessages.localize('이미 완료한 과제입니다.'), 'You have already completed this assignment.');
    expect(ServerMessages.localize(' 이미 완료한 과제입니다. '), 'You have already completed this assignment.');
    expect(ServerMessages.localize('이미 완료한 과제입니다'), '이미 완료한 과제입니다');
  });

  test('자리표시 틀은 자리값을 옮기고 순서가 바뀌어도 맞춘다', () {
    ServerMessages.applyBundle(_bundle);
    expect(ServerMessages.localize('이 차시(A1-T01-1)의 표현학습이 아직 끝나지 않았어요(status=learning).'),
        "Expression learning for this lesson (A1-T01-1) isn't finished yet (status=learning).");
    expect(ServerMessages.localize('순서 바꿈 가 그리고 나'), '나 then 가');
  });

  test('REST 오류 detail.message·문자열 detail 둘 다 바꾸고 fromServer 는 그대로', () {
    ServerMessages.applyBundle(_bundle);
    final a = mapDioException(_err(409, {'detail': {'code': 'X', 'message': '이미 완료한 과제입니다.'}}));
    expect(a.message, 'You have already completed this assignment.');
    expect(a.fromServer, isTrue);
    final b = mapDioException(_err(404, {'detail': '이미 완료한 과제입니다.'}));
    expect(b, isA<NotFoundFailure>());
    expect(b.message, 'You have already completed this assignment.');
    final c = mapDioException(_err(400, {'detail': {'message': '처음 보는 문구'}}));
    expect(c.message, '처음 보는 문구');
  });

  test('WS error 프레임 기본 갈래도 사전을 탄다 · 앱 문구 코드는 그대로', () {
    ServerMessages.applyBundle(_bundle);
    final l10n = AppLocalizationsEn();
    expect(serverErrorMessage({'code': 'COURSE_LOCKED', 'message': '이 차시(A1)의 표현학습이 아직 끝나지 않았어요(status=x).'}, l10n),
        "Expression learning for this lesson (A1) isn't finished yet (status=x).");
    expect(serverErrorMessage({'code': 'ALREADY_IN_CALL', 'message': '이미 완료한 과제입니다.'}, l10n), l10n.callAlreadyInCall);
    expect(serverErrorMessage({'code': 'X'}, l10n), l10n.callErrorGeneric);
  });

  test('받기 실패는 던지지 않고 원문 표시로 둔다 · ko 는 사전을 비운다', () async {
    ServerMessages.applyBundle(_bundle);
    final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:9'))..httpClientAdapter = _FailAdapter();
    await ServerMessages.load(dio, 'vi');
    expect(ServerMessages.locale, isNull);
    expect(ServerMessages.localize('이미 완료한 과제입니다.'), '이미 완료한 과제입니다.');
    ServerMessages.applyBundle(_bundle);
    await ServerMessages.load(dio, 'ko');
    expect(ServerMessages.localize('이미 완료한 과제입니다.'), '이미 완료한 과제입니다.');
  });
}
