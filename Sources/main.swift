import Foundation

let means: [Double] = [0.1, 0.1, 0.1, 0.1, 0.9].shuffle()
let arms = means.map { BernoulliArm(probablity: $0) }
print("Best arm is", means.indMax())

do {
  let file = "standardResults.tsv"
  guard
  let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first,
  let outputStream = NSOutputStream(toFileAtPath: dir.stringByAppendingPathComponent(file), append: true) else {
    throw NSError(domain: "dir error", code: 1, userInfo: nil)
  }
  outputStream.open()

  for epsilon in [Double]([0.1, 0.2, 0.3, 0.4, 0.5]) {
    let algorithm = EpsilonGreedy(epsilon: epsilon, nArms: means.count)
    let results = testAlgorithm(algorithm, arms: arms, numSims: 5, horizon: 10)

    for i in results.simNums {
      outputStream.write("\(epsilon)\t", maxLength: "\(epsilon)\t".characters.count)
      outputStream.write("\(results.simNums[i])\t", maxLength: "\(results.simNums[i])\t".characters.count)
      outputStream.write("\(results.times[i])\t", maxLength: "\(results.times[i])\t".characters.count)
      outputStream.write("\(results.chosenArms[i])\t", maxLength: "\(results.chosenArms[i])\t".characters.count)
      outputStream.write("\(results.rewards[i])\t", maxLength: "\(results.rewards[i])\t".characters.count)
      outputStream.write("\(results.cumulativeRewards[i])", maxLength: "\(results.cumulativeRewards[i])".characters.count)
      outputStream.write("\n", maxLength: "\n".characters.count)
    }
  }
  outputStream.close()

  print("Results are @", dir.stringByAppendingPathComponent(file))

} catch let error as NSError {
  print("There was an error:", error)
}
