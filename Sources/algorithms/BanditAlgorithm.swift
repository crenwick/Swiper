public protocol BanditAlgorithm {
  func selectArm() -> Int
  func update(arm: Int, reward: Double) -> Self
}
