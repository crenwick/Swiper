import XCTest
@testable import Swiper

class EpsilonGreedyTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPerformanceEpislonAlgorithm() {
    let means: [Double] = [0.1, 0.1, 0.1, 0.1, 0.9].shuffle()
    let arms = means.map { BernoulliArm(probablity: $0) }

    self.measureBlock {
      let algorithm = EpsilonGreedy(epsilon: 0.1, nArms: means.count)
      testAlgorithm(algorithm, arms: arms, numSims: 500, horizon: 250)
    }
  }

  func testPerformanceSoftmaxAlgorithm() {
    let means: [Double] = [0.1, 0.1, 0.1, 0.1, 0.9].shuffle()
    let arms = means.map { BernoulliArm(probablity: $0) }

    self.measureBlock {
      let algorithm = Softmax(nArms: means.count)
      testAlgorithm(algorithm, arms: arms, numSims: 500, horizon: 250)
    }
  }

}
