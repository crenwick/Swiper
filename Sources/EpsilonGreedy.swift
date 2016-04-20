import Foundation

public struct EpsilonGreedy {
  public let epsilon: Double
  public let counts: [Int]
  public let values: [Double]

  public init(epsilon: Double, counts: [Int], values: [Double]) {
    self.epsilon = epsilon
    self.counts = counts
    self.values = values
  }

  public init(epsilon: Double, nArms: Int) {
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

  public func newEpsilon(epsilon: Double) -> EpsilonGreedy {
    return EpsilonGreedy(epsilon: epsilon, counts: counts, values: values)
  }

  public func selectArm() -> Int? {
    if Double(arc4random())/Double(UInt32.max) > epsilon {
      return values.indMax()
    }
    return Int(arc4random_uniform(UInt32(values.count)))
  }

  public func update(chosenArm: Int, reward: Double) -> EpsilonGreedy {
    var newCounts = counts
    newCounts[chosenArm] = counts[chosenArm] + 1

    var newValues = values
    let n = Double(newCounts[chosenArm])
    // compute the running average
    newValues[chosenArm] = ((n - 1) / n) * values[chosenArm] + (1 / n) * reward

    return EpsilonGreedy(epsilon: epsilon, counts: newCounts, values: newValues)
  }
  
}