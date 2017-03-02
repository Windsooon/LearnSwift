import Foundation

class NoSQLTableFactory {
    static var supportedTables: [Table] {
        return [
            LendMoneyTable(),
            OweMoneyTable(),
        ]
    }
}
