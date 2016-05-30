import Foundation

protocol Arm {
  func draw() -> Double
}

struct BernoulliArm: Arm {
  let probablity: Double

  func draw() -> Double {
    return (Double(arc4random())/Double(UInt32.max) > self.probablity) ? 0.0 : 1.0
  }
}
