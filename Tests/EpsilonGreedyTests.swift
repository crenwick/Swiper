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
      let algorithm = EpsilonGreedy(epsilon: 0.1, nArms: means.count)
      testAlgorithm(algorithm, arms: arms, numSims: 500, horizon: 250)
    }

    let file = "standardResults.tsv"
    let dir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true).first!
    let outputStream = NSOutputStream(toFileAtPath: dir.stringByAppendingPathComponent(file),
                                      append: true)!
    outputStream.open()

    let string = "hello world"
    let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    let bytes = UnsafePointer<UInt8>(data.bytes)
    outputStream.write(bytes, maxLength: data.length)
  }

}
