import Foundation
import WebSockets

extension Sword {

  func getGateway(completion: @escaping (Error?, [String: Any]?) -> Void) {
    requester.request(endpoint.gateway, authorization: true) { error, data in
      if error != nil {
        completion(error, nil)
        return
      }

      guard let data = data as? [String: Any] else {
        completion(.unknown, nil)
        return
      }

      completion(nil, data)
    }
  }

  func startWS() {
    try? WebSocket.connect(to: gatewayUrl!) { ws in
      print("Connected to \(self.gatewayUrl!)")

      ws.onText = { ws, text in
        let packet = self.getPacket(text)

        self.event(packet)
      }

      ws.onClose = { ws, _, _, _ in
        print("WS Closed")
      }
    }
  }

  func getPacket(_ text: String) -> [String: Any] {
    let packet = try? JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: .allowFragments) as! [String: Any]

    return packet!
  }

  func event(_ packet: [String: Any]) {
    guard let eventName = packet["t"] as? String else {
      switch packet["op"]! {
        case OPCode.hello:
          print("Hello")
          break
        default:
          print("Some other opcode")
      }

      return
    }

    print(eventName)
  }

}
