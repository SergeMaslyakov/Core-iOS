import Foundation

public extension Array {
    mutating func moveOnTop(from index: Int) {
        guard index > 0, index < count else { return }

        insert(remove(at: index), at: 0)
    }
}
