"""
FCM 수동 발송 테스트 스크립트 (Android, data-only 고우선순위).

앱이 백그라운드/완전 종료 상태여도 CallKit 수신 화면이 뜨는지 확인하는 용도.
서버 코드 없이 이 스크립트로 직접 푸시를 쏴서 검증한다.

왜 이게 필요한가:
- Firebase 콘솔 "테스트 메시지"는 notification 메시지라 백그라운드에선 시스템 트레이로만 가고
  앱 코드(firebaseMessagingBackgroundHandler)가 실행되지 않는다.
- 아래처럼 **notification 없이 data만** + `android.priority=high` 로 보내야 종료 상태에서도
  백그라운드 isolate가 깨어나 showCallkitIncoming을 호출한다.

준비물:
1) pip install requests google-auth
2) 서비스 계정 JSON:
   Firebase 콘솔(프로젝트 beavertalk-e962f) → 프로젝트 설정 → 서비스 계정
   → "새 비공개 키 생성" → 내려받은 json 경로를 SERVICE_ACCOUNT_FILE 에 적기.
   (이 파일은 절대 커밋 금지 — .gitignore 권장)
3) 앱을 `flutter run` 후 로그에서 `[fcm] token=...` 값을 복사해 DEVICE_TOKEN 에 붙이기.

실행:
   python tools/fcm_send_test.py
"""

import json

import requests
from google.oauth2 import service_account
import google.auth.transport.requests

# ── 여기만 채우면 됨 ─────────────────────────────────────────────
PROJECT_ID = "beavertalk-e962f"                    # google-services.json 의 project_id
SERVICE_ACCOUNT_FILE = "service-account.json"      # 내려받은 서비스 계정 키 경로
DEVICE_TOKEN = "여기에 앱 로그의 [fcm] token 값"      # 대상 기기 토큰
# ────────────────────────────────────────────────────────────────

# 전화 표시에 쓰이는 값들(클라 IncomingCallPayloadDto 가 파싱하는 키).
# FCM data 는 값이 전부 문자열이어야 한다.
DATA = {
    "call_id": "test-" + "11111111-2222-3333-4444-555555555555",
    "character_id": "1",
    "name": "비버 튜터",
    "image_url": "",  # 있으면 캐릭터 이미지 URL
}


def _access_token() -> str:
    """서비스 계정으로 FCM HTTP v1 발송용 OAuth2 access token 발급."""
    cred = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE,
        scopes=["https://www.googleapis.com/auth/firebase.messaging"],
    )
    cred.refresh(google.auth.transport.requests.Request())
    return cred.token


def main() -> None:
    message = {
        "message": {
            "token": DEVICE_TOKEN,
            # ★ notification 키를 넣지 말 것 — data-only 여야 백그라운드/종료에서 코드가 돈다.
            "android": {
                "priority": "high",   # Doze 를 뚫고 즉시 전달
                "ttl": "60s",         # 60초 지나면 폐기(지난 전화가 늦게 뜨지 않게)
            },
            "data": DATA,
        }
    }

    resp = requests.post(
        f"https://fcm.googleapis.com/v1/projects/{PROJECT_ID}/messages:send",
        headers={
            "Authorization": f"Bearer {_access_token()}",
            "Content-Type": "application/json; UTF-8",
        },
        data=json.dumps(message),
    )
    print("status:", resp.status_code)
    print(resp.text)
    if resp.status_code == 200:
        print("\n✅ 발송 성공 — 기기에서 전화 오는 화면이 떠야 합니다.")
    else:
        print("\n❌ 실패 — 토큰/서비스계정/프로젝트ID를 확인하세요.")


if __name__ == "__main__":
    main()
