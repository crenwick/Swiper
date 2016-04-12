import Foundation

public struct EpsilonGreedy {
  public let epsilon: Float
  public let counts: [Int]
  public let values: [Float]

  public init(epsilon: Float, counts: [Int], values: [Float]) {
    self.epsilon = epsilon
    self.counts = counts
    self.values = values
  }

  public init(epsilon: Float, nArms: Int) {
    self = EpsilonGreedy(epsilon: epsilon, counts: [], values: [])
      .initialize(nArms: nArms)
  }

  public func initialize(nArms nArms: Int) -> EpsilonGreedy {
    return EpsilonGreedy(
      epsilon: epsilon,
      counts: (0..<nArms).map({ _ in 0 }),
      values: (0..<nArms).map({ _ in 0 })
    )
  }

  public func newEpsilon(epsilon: Float) -> EpsilonGreedy {
    return EpsilonGreedy(epsilon: epsilon, counts: counts, values: values)
  }

  public func indMax(values: [Float]) -> Int? {
    guard
      let max = values.maxElement(),
      let index = values.indexOf(max) else { return nil }
    return Int(index)
  }

  public func selectArm() -> Int? {
    if Float(arc4random())/Float(UInt32.max) > epsilon {
      return indMax(values)
    }
    return Int(arc4random_uniform(UInt32(values.count)) + 1)
  }

  public func update(chosenArm: Int, reward: Float) -> EpsilonGreedy {
    var newCounts = counts
    newCounts[chosenArm] = counts[chosenArm] + 1

    var newValues = values
    let n = Float(newCounts[chosenArm])
    // compute the running average
    newValues[chosenArm] = ((n - 1) / n) * values[chosenArm] + (1 / n) * reward

    return EpsilonGreedy(epsilon: epsilon, counts: newCounts, values: newValues)
  }
  
}