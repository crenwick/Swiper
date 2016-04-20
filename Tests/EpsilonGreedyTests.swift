import XCTest
@testable import Swiper

class EpsilonGreedyTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testInitializers() {
    let epsilonGreedy = EpsilonGreedy(epsilon: 1, nArms: 2)
    let newEpsilon = epsilonGreedy.newEpsilon(0)
    XCTAssertEqual(epsilonGreedy.epsilon, 1)
    XCTAssertEqual(newEpsilon.epsilon, 0)
  }

  func testPerformanceEpislonAlgorithm() {
    let means: [Double] = [0.1, 0.1, 0.1, 0.1, 0.9].shuffle()
    let arms = means.map { BernoulliArm(probablity: $0) }

    self.measureBlock {
      do {
        let algorithm = EpsilonGreedy(epsilon: 0.1, nArms: means.count)
        try testAlgorithm(algorithm, arms: arms, numSims: 500, horizon: 250)
      } catch {
        XCTFail()
      }
    }
  }

}
