import Foundation

typealias TestFrameworkDataSet = (simNums: [Int], times: [Int], chosenArms: [Int], rewards: [Double], cumulativeRewards: [Double])

/**
 - parameter algorithm: A bandit algorithm to test
 - parameter arms:      An array of arms to simulate draws from
 - parameter numSims:   Number of simulations to run
 - parameter horizon:   The number of times each algorithm can pull on arms during each simulation

 - throws: If there is an error selecting an arm from an algorithm

 - returns: A dataset that describes what arm was chosen in each simulation and how well the algorithm did at each point it ran.
 */
func testAlgorithm<T: Arm where T: Arm>(
  algorithm: EpsilonGreedy,
  arms: [T],
  numSims: Int,
  horizon: Int
  ) throws -> TestFrameworkDataSet {

  // make the algorithm mutable...
  var algorithm = algorithm

  let arrayOfInts = (0..<numSims * horizon).map { _ in 0 }
  let arrayOfDoubles: [Double] = arrayOfInts.map { _ in 0 }

  var dataSet: TestFrameworkDataSet = (
    simNums: arrayOfInts,
    times: arrayOfInts,
    chosenArms: arrayOfInts,
    rewards: arrayOfDoubles,
    cumulativeRewards: arrayOfDoubles
  )

  for sim in 1...numSims {
    // Reset the algoirthm to scratch
    algorithm = algorithm.initialize(nArms: arms.count)

    for t in 1...horizon {
      let index = (sim - 1) * horizon + t - 1

      dataSet.simNums[index] = sim
      dataSet.times[index] = t

      guard let chosenArm = algorithm.selectArm() else {
        throw NSError(domain: "Error selecing arm of algorithm", code: 1, userInfo: nil)
      }
      dataSet.chosenArms[index] = chosenArm

      let reward = arms[dataSet.chosenArms[index]].draw()
      dataSet.rewards[index] = reward

      dataSet.cumulativeRewards[index] = (t == 1) ? reward
        : dataSet.cumulativeRewards[index - 1] + reward

      algorithm = algorithm.update(chosenArm, reward: reward)
    }
  }
  return dataSet
}
