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
  ) -> TestFrameworkDataSet {

  var dataSet: TestFrameworkDataSet = (
    simNums: [Int](count: numSims * horizon, repeatedValue: 0),
    times: [Int](count: numSims * horizon, repeatedValue: 0),
    chosenArms: [Int](count: numSims * horizon, repeatedValue: 0),
    rewards: [Double](count: numSims * horizon, repeatedValue: 0),
    cumulativeRewards: [Double](count: numSims * horizon, repeatedValue: 0)
  )

  for sim in 1...numSims {

    func selectArmAndUpdateDataSet(algorithm: EpsilonGreedy, simNumber: Int, simGoal: Int) -> Void {
      if simNumber > simGoal {
        return
      }

      let index = (sim - 1) * horizon + simNumber - 1

      dataSet.simNums[index] = sim
      dataSet.times[index] = simNumber

      let chosenArm = algorithm.selectArm()

      dataSet.chosenArms[index] = chosenArm

      let reward = arms[dataSet.chosenArms[index]].draw()
      dataSet.rewards[index] = reward

      dataSet.cumulativeRewards[index] = (simNumber == 1) ? reward
        : dataSet.cumulativeRewards[index - 1] + reward

      let newAlgo = algorithm.update(chosenArm, reward: reward)
      selectArmAndUpdateDataSet(newAlgo, simNumber: simNumber + 1, simGoal: simGoal)
    }
    selectArmAndUpdateDataSet(algorithm.initialize(nArms: arms.count), simNumber: 1, simGoal: horizon)

  }
  return dataSet
}
