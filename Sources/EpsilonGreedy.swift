import Foundation

struct EpsilonGreedy {
  let epsilon: Float
  let counts: [Int]
  let values: [Float]

  init(epsilon: Float, counts: [Int], values: [Float]) {
    self.epsilon = epsilon
    self.counts = counts
    self.values = values
  }

  init(epsilon: Float, nArms: Int) {
    self = EpsilonGreedy(epsilon: epsilon, counts: [], values: [])
      .initialize(nArms: nArms)
  }

  func initialize(nArms nArms: Int) -> EpsilonGreedy {
    return EpsilonGreedy(
      epsilon: epsilon,
      counts: (0..<nArms).map({ _ in 0 }),
      values: (0..<nArms).map({ _ in 0 })
    )
  }

  func newEpsilon(epsilon: Float) -> EpsilonGreedy {
    return EpsilonGreedy(epsilon: epsilon, counts: counts, values: values)
  }

  func indMax(values: [Float]) -> Int? {
    guard
      let max = values.maxElement(),
      let index = values.indexOf(max) else { return nil }
    return Int(index)
  }

  func selectArm() -> Int? {
    if Float(arc4random())/Float(UInt32.max) > epsilon {
      return indMax(values)
    }
    return Int(arc4random_uniform(UInt32(values.count)) + 1)
  }

  func update(chosenArm: Int, reward: Float) -> EpsilonGreedy {
    var newCounts = counts
    newCounts[chosenArm] = counts[chosenArm] + 1

    var newValues = values
    let n = Float(newCounts[chosenArm])
    // compute the running average
    newValues[chosenArm] = ((n - 1) / n) * values[chosenArm] + (1 / n) * reward

    return EpsilonGreedy(epsilon: epsilon, counts: newCounts, values: newValues)
  }
  
}