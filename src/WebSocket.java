import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

// @ServerEndpoint Annotation은 웹 소켓 서버의 Uri 공간에 배포되고 이용 가능하게 될 웹 소켓 끝점임을 선언한다.
@ServerEndpoint("/websocket")
public class WebSocket {

  // 접속한 클라이언트의 WebSocket Session을 관리하기 위한 리스트
  private static List<Session> clientSession = Collections.synchronizedList(new ArrayList<>());

  @OnOpen
  public void onOpen(Session session) {
    // 클라이언트가 접속하였을 경우 세션을 리스트에 저장한 후 콘솔에 안내 문구를 출력한다.
    clientSession.add(session);
    System.out.println("클라이언트가 연결되었습니다.");
  }

  @OnMessage
  public void onMessage(String message, Session session) throws IOException {
    //Session 리스트에서 client를 추츨한 뒤, 메세지를 보낸 세션과 리스트의 세션이 같다면 메세지를 보내지 않고, 같지 않다면 리스트에 존재하는 모든 세션에 수신한 메세지를 다시 보낸다.
    clientSession.forEach(client -> {
      if (client == session)
        return;
      try {
        client.getBasicRemote().sendText(message);
      } catch (IOException e) {
        e.printStackTrace();
      }
    });
  }

  @OnClose
  public void onClose(Session session) {
    // 웹소켓이 종료되었을 경우 Session을 담은 리스트에서 해당 Session을 삭제한 뒤 콘솔에 삭제 문구를 출력한다.
    clientSession.remove(session);
    System.out.println("클라이언트가 접속을 종료하였습니다.");
  }

  @OnError
  public void onError(Throwable e){
    // 웹소켓과 관련된 오류가 발생하였을 경우 콘솔에 오류 문구를 출력한다.
    e.printStackTrace();
  }
}

