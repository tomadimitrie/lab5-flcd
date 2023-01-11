import Foundation

class TableData {
    let rowSymbol: String
    let columnSymbol: String
    let tokens: [String]
    let index: Int

    init(rowSymbol: String, columnSymbol: String, tokens: [String], index: Int) {
        self.rowSymbol = rowSymbol
        self.columnSymbol = columnSymbol
        self.tokens = tokens
        self.index = index
    }
}
