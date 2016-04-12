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

}
