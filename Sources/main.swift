import Foundation

let means: [Double] = [0.1, 0.1, 0.1, 0.1, 0.9].shuffle()
let arms = means.map { BernoulliArm(probablity: $0) }
print("Best arm is", means.indMax() ?? "nil")

let file = "results_swift.tsv"

guard
  let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first,
  let outputStream = NSOutputStream(toFileAtPath: dir.stringByAppendingPathComponent(file), append: true) else {
  exit(0)
}
outputStream.open()

for epsilon in [Double]([0.1, 0.2, 0.3, 0.4, 0.5]) {
  let algorithm = EpsilonGreedy(epsilon: epsilon, nArms: means.count)
  let results = testAlgorithm(algorithm, arms: arms, numSims: 100, horizon: 250)

  for i in 0..<results.simNums.count {
    let algorithmResultLine = "\(epsilon)\t\(results.simNums[i])\t\(results.times[i])\t\(results.chosenArms[i])\t\(results.rewards[i])\t\(results.cumulativeRewards[i])\n"
    outputStream.write(algorithmResultLine, maxLength: algorithmResultLine.characters.count)
  }
}
outputStream.close()
