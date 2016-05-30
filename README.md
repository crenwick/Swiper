# Swiper

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A series of bandit algorithms in Swift, built with functional programing and immutable data structures.

![Swiper](http://i.imgur.com/EhLAg7t.png)

## Swift Build System Instructions
To run on the command line:

1. `$ swift build` // requires you to be in the `./Swiper` directory
1. `$ ./build/debug/Swiper`

## Epsilon-Greedy
The epsilon in the [Epsilon-greedy strategy](https://en.wikipedia.org/wiki/Multi-armed_bandit#Semi-uniform_strategies) controls the proportion of explorations vs exploitations.

*Example usage:*
```swift
let epsilonGreedy = EpsilonGreedy(epsilon: 0.1, nArms: 2)
let selectedArm = epsilonGreedy.selectArm()
somethingWithCallback(color: selectedArm) { (reward) in
  let updatedEpsilonGreedy = epsilonGreedy.update(selectedArm, reward: reward)
}
```

## Softmax (Annealing)
The Annealing Softmax object selects arms based on a [softmax function](https://en.wikipedia.org/wiki/Softmax_function).
This object does not require a temperature—the algorithm automatically manages it via simulated annealing.

*Example usage:*
```swift
let softmax = Softmax(nArms: 3)
let selectedArm = softmax.selectArm()
somethingWithCallback(copy: selectedArm) { (reward) in
  let updatedSoftmax = softmax.update(selectedArm, reward: reward)
}
```
