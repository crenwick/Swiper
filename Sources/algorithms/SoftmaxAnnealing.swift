import Foundation

public struct Softmax: BanditAlgorithm {
  public typealias Handler = (count: Int, value: Double)

  public let handlers: [Handler]

  private init(handlers: [Handler]) {
    self.handlers = handlers
  }

  /**
   Makes a brand new Softmax algorithm object with a custom number of handlers.
   All handlers will have no data (count and values at 0)

   - parameter nArms: How many arms the algorithm should test

   - returns: A new instance of a Softmax object, with no data
   */
  public init(nArms: Int) {
    self = Softmax(handlers: [Handler](count: nArms, repeatedValue: (0, 0)))
  }

  public func selectArm() -> Int {
    let t = handlers.reduce(1) { $0 + $1.count }
    let temperature = 1 / log2(Double(t) + 0.0000001)

    let z = handlers
      .map { pow(2.718281828, $0.value / temperature) }
      .reduce(0, combine: +)
    let probs = handlers
      .map { pow(2.718281828, $0.value / temperature) / z }

    return categoricalDraw(probs)
  }

  private func categoricalDraw(probabilities: [Double]) -> Int {
    let random = Double(arc4random())/Double(UInt32.max)
    var cumulativeProbability: Double = 0
    for (i, probability) in probabilities.enumerate() {
      cumulativeProbability += probability
      if cumulativeProbability > random {
        return i
      }
    }
    return probabilities.count - 1
  }

  public func update(arm: Int, reward: Double) -> Softmax {
    // update the handler[arm].count += 1
    var newHandlers = handlers
    newHandlers[arm].count += 1

    let c = Double(newHandlers[arm].count)
    newHandlers[arm].value = ((c - 1) / c) * handlers[arm].value + (1 / c) * reward

    return Softmax(handlers: newHandlers)
  }
}
