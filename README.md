# Swiper

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A series of bandit algorithms in Swift, built with functional programing and immutable data structures.

## Epsilon-Greedy
The epsilon in the [Epsilon-greedy strategy](https://en.wikipedia.org/wiki/Multi-armed_bandit#Semi-uniform_strategies) controls the proportion of explorations vs exploitations.

*Example usage:*
swift
```
let epsilonGreedy = EpsilonGreedy(0.1, nArms: 2)
let selectedArm = epsilonGreedy.selectArm()
somethingWithCallback(color: selectedArm) { (reward) in
  epsilonGreedy.update(selectArm, reward: reward)
}
```
