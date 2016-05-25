import Foundation

public struct EpsilonGreedy {
  public typealias Handler = (count: Int, value: Double)

  public let epsilon: Double
  public let handlers: [Handler]
  public let topHandlerIndex: Int?

  private init(epsilon: Double, handlers: [Handler], topHandlerIndex: Int?) {
    self.epsilon = epsilon
    self.handlers = handlers
    self.topHandlerIndex = topHandlerIndex
  }

  public init(epsilon: Double, handlers: [Handler]) {
    self.epsilon = epsilon
    self.handlers = handlers

    guard let topHandler = handlers.maxElement({ (rhs, lhs) -> Bool in
      rhs.value > lhs.value
    }) else {
      self.topHandlerIndex = nil
      return
    }

    self.topHandlerIndex = handlers.indexOf { (handler) -> Bool in
      handler.count == topHandler.count && handler.value == topHandler.value
    }
  }

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

  public func update(chosenArm: Int, reward: Double) -> EpsilonGreedy {
    var newHandlers = handlers
    newHandlers[chosenArm].count += 1

    // compute the running average
    let c = Double(newHandlers[chosenArm].count)
    newHandlers[chosenArm].value = ((c - 1) / c) * handlers[chosenArm].value + (1 / c) * reward

    let newTopHandlerIndex: Int
    switch topHandlerIndex {
    case let index?:
      newTopHandlerIndex = (newHandlers[chosenArm].value > handlers[index].value) ? chosenArm : index
    case nil:
      newTopHandlerIndex = chosenArm
    }

    return EpsilonGreedy(epsilon: epsilon, handlers: newHandlers, topHandlerIndex: newTopHandlerIndex)
  }

}
