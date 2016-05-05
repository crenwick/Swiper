extension Array where Element: Comparable {
  /**
   Finds the highest value in an array of comparables.

   - returns: The index position of that highest value. If more than one index
   match the highest value, it will return the first index of the match.
   */
  public func indMax() -> Int? {
    guard let max = self.maxElement() else { return nil }
    return self.indexOf(max)
  }
}