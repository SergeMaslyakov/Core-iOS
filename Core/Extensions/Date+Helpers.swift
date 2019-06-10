import Foundation

public extension Date {

    func ifPeriodExpired(_ period: DateComponents) -> Bool {
        let nowDate = Date()

        let calendar = Calendar.current
        if let timeoutDate = calendar.date(byAdding: period, to: self) {
            return timeoutDate < nowDate
        } else {
            return true
        }
    }
}
