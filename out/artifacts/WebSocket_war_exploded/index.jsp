<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>TCP/IP 기말고사 과제물 - 멀티스레드 기반의 웹소켓 채팅 프로그램 </title>
</head>
<body>
  <textarea id="ChatArea" rows="10" cols="50"></textarea>
  <br />
  <form>
    <input id="nickname" type="text" value="Guest">
    <input id="message" type="text" onkeyup="EnterKey()">
    <input onclick="sendMessage()" value="전송" type="button">
    <input onclick="Disconnect()" value="연결 끊기" type="button">
  </form>
</body>
<script type="text/javascript">
  // WebSocket 생성과 동시에 onopen 함수 실행
  var webSocket = new WebSocket("ws://localhost:9190/websocket");

  // 메세지 내용을 보여주기 위한 Element 객체를 ChatArea 변수에 지정
  var ChatArea = document.getElementById("ChatArea");

  // WebSocket 연결 시 TextArea에 연결 안내문구 출력
  webSocket.onopen = function(message) {
    ChatArea.value += "채팅 서버에 연결되었습니다.\n";
  };

  // WebSocket 종료 시 TextArea에 종료 안내문구 출력
  webSocket.onclose = function(message) {
    ChatArea.value += "채팅 서버와의 연결을 종료합니다..\n";
  };

  // WebSocket 에러 발생 시 TextArea에 에러 안내문구 출력
  webSocket.onerror = function(message) {
    ChatArea.value += "에러가 발생하였습니다.\n";
  };

  // WebSocket 서버로부터 메세지 수신 시 TextArea에 해당 메세지를 출력
  webSocket.onmessage = function(message) {
    ChatArea.value += message.data + "\n";
  };


  // 전송 버튼 클릭 시, 닉네임과 메세지의 값을 TextArea에 추가하고 WebSocket에 전송하여 다른 클라이언트에서도 해당 메세지를 볼 수 있도록 함. (이후 메세지 입력 창 초기화)
  function sendMessage() {
    var nickname = document.getElementById("nickname");
    var message = document.getElementById("message");
    ChatArea.value += nickname.value + "(나) : " + message.value + "\n";
    webSocket.send(nickname.value + " : " + message.value);
    message.value = "";
  }

  // 연결 해제 버튼 클릭 시, WebSocket 연결 종료
  function Disconnect() {
    webSocket.close();
  }

  // EnterKey 이벤트 바인딩하여 버튼 입력과 EnterKey 입력 모두 지원하도록 함.
  function EnterKey(){
    if(window.event.which == 13)
      sendMessage();
  }

</script>
</html>