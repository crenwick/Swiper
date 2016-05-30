import Foundation

public struct EpsilonGreedy: BanditAlgorithm {
  public typealias Handler = (count: Int, value: Double)

  public let epsilon: Double
  public let handlers: [Handler]
  public let topHandlerIndex: Int?

  private init(epsilon: Double, handlers: [Handler], topHandlerIndex: Int?) {
    self.epsilon = epsilon
    self.handlers = handlers
    self.topHandlerIndex = topHandlerIndex
  }

  /**
   Makes a brand new EpsilonGreedy algorithm object.
   This initializes a custom number of handlers, all with zero data.

   - parameter epsilon: The frequency to explore
   - parameter nArms:   How many arms the algorithm should test

   - returns: A new instance of an Epsilon Greedy object, with no data
   */
  public init(epsilon: Double, nArms: Int) {
    self = EpsilonGreedy(epsilon: epsilon,
                         handlers: [Handler](count: nArms,
                                             repeatedValue: (0, 0)),
                         topHandlerIndex: nil)
  }

  public func selectArm() -> Int {
    if Double(arc4random())/Double(UInt32.max) > epsilon {
      return topHandlerIndex ?? Int(arc4random_uniform(UInt32(handlers.count)))
    }
    return Int(arc4random_uniform(UInt32(handlers.count)))
  }

  public func update(arm: Int, reward: Double) -> EpsilonGreedy {
    var newHandlers = handlers
    newHandlers[arm].count += 1

    // compute the running average
    let c = Double(newHandlers[arm].count)
    newHandlers[arm].value = ((c - 1) / c) * handlers[arm].value + (1 / c) * reward

    let newTopHandlerIndex: Int
    switch topHandlerIndex {
    case let index?:
      newTopHandlerIndex = (newHandlers[arm].value > handlers[index].value) ? arm : index
    case nil:
      newTopHandlerIndex = arm
    }

    return EpsilonGreedy(epsilon: epsilon, handlers: newHandlers, topHandlerIndex: newTopHandlerIndex)
  }

}
