extension Array where Element: Comparable {
  /**
   Finds the highest value in an array of comparables.

   - returns: The index position of that highest value. If more than one index
   match the highest value, it will return the first index of the match.
   
   - todo: Keep this func O(self.count), but return a random index of matching
   values if more than one is equal to the highest value.

   This will be done through a custom `reduce` fuction that builds an object of
   (maxValue: Element.value, maxes: [Int]).
   
   If current index > maxValue, make `maxValue = self[current index]` and `maxes = [currrent index]`
   if current index == maxValue, make `maxes += [index]`
   if current index < maxValue, skip it
   
   Once complete, if `maxes.count == 1`, return `maxes[0]`, otherwise pick
   an element at random from `maxes`.
   */
  public func indMax() -> Int? {
    guard
      let max = self.maxElement(),
      let index = self.indexOf(max) else { return nil }
    return Int(index)
  }
}