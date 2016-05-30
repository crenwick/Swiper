# Swiper

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

A series of bandit algorithms in Swift, built with functional programing and immutable data structures. Inspired by [johnmyleswhite/BanditsBook][johnmyleswhite/BanditsBook].

![Swiper](http://i.imgur.com/EhLAg7t.png)

## Swift Build System Instructions
To run on the command line:

1. `$ swift build` // requires you to be in the `./Swiper` directory
1. `$ ./build/debug/Swiper` // builds a `results_swift.tsv` file in your `~/Documents/` directory

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
let softmax = Softmax(nArms: 4)
let selectedArm = softmax.selectArm()
somethingWithCallback(copy: selectedArm) { (reward) in
  let updatedSoftmax = softmax.update(selectedArm, reward: reward)
}
```

## UCB1 (Upper Confidence Bound)
[The UCB strategy](https://en.wikipedia.org/wiki/Multi-armed_bandit#Contextual_Bandit) uses context to select its next arm. The UCB1 assumes that your max reward is a value of 1.

*Example useage:*
```swift
let ucb = UCB1(nArms: 3)
let selectedArm = ucb.selectArm()
somethingWithCallback(displayPopup: selectedArm) { (reward) in
  let updatedUcb = ucb.update(selectedArm, reward: reward)
}
```
