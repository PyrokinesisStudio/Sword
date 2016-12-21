import Foundation

struct Payload {

  let op: Int
  let d: Any
  let s: Int?
  let t: String?

  init(with text: String) {
    let data = text.decode() as! [String: Any]
    self.op = data["op"] as! Int
    self.d = data["d"]!
    self.s = data["s"] as? Int
    self.t = data["t"] as? String
  }

  init(op: OPCode, data: Any) {
    self.op = op.rawValue
    self.d = data
    self.s = nil
    self.t = nil
  }

  func encode() -> String {
    let payload = ["op": self.op, "d": self.d]
    return payload.encode()
  }

}