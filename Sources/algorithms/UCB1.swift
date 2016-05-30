import Foundation

public struct UCB1: BanditAlgorithm {
  public typealias Handler = (count: Int, value: Double)

  public let handlers: [Handler]

  private init(handlers: [Handler]) {
    self.handlers = handlers
  }

  public init(nArms: Int) {
    self = UCB1(handlers: [Handler](count: nArms, repeatedValue: (0, 0)))
  }

  public func selectArm() -> Int {
    var totalCounts = 0
    for (i, handler) in handlers.enumerate() {
      if handler.count == 0 {
        return i
      }
      totalCounts += handler.count
    }

    let totalCountsLog = log2(Double(totalCounts))

    var cursor: (highestUCBValue: Double, index: Int) = (0, 0)
    for (index, handler) in handlers.enumerate() {
      let bonus = sqrt((2 * totalCountsLog) / floor(Double(handler.count)))
      if (handler.value + bonus) > cursor.highestUCBValue {
        cursor = (handler.value, index)
      }
    }

    return cursor.index
  }

  public func update(arm: Int, reward: Double) -> UCB1 {
    var newHandlers = handlers
    newHandlers[arm].count += 1

    let c = Double(newHandlers[arm].count)
    newHandlers[arm].value = ((c - 1) / c) * handlers[arm].value + (1 / c) * reward

    return UCB1(handlers: newHandlers)
  }
}