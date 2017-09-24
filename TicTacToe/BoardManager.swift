//
//  BoardManager.swift
//  TicTacToe
//
//  Created by Anteneh Sahledengel on 8/30/17.
//  Copyright © 2017 Anteneh Sahledengel. All rights reserved.
//

import UIKit

enum BoardValueType: String {
    case x = "X"
    case o = "O"
    case Empty = ""
}

struct BoardValue {
    var type: BoardValueType
    var indexInBoard: Int
}

enum GameStatus {
    case Open, Draw
    case Won (winningValues: [BoardValue])
    case Lost (winningValues: [BoardValue])
    
    func isOpen() -> Bool {
        switch self {
        case .Open:
            return true
        default:
            return false
        }
    }
    
    func winningValues() -> [BoardValue]? {
        switch self {
        case .Won(let winningValues):
            return winningValues
        case .Lost(let winningValues):
            return winningValues
        default:
            return nil
        }
    }
    
    func message() -> String {
        switch self {
        case .Open:
            return ""
        case .Won:
            return "You Won!"
        case .Lost:
            return "Loooooser"
        case .Draw:
            return "It's a draw"
        }
    }
}

class BoardManager {

    class func nextBestMove(forBoard board: [BoardValueType]) -> Int {
        
        //winning move
        for line in board.allLines() {
            let oCount = line.filter({ $0.type == .o }).count
            if oCount == 2 {
                if let index = line.index(where: { $0.type == .Empty}) {
                    return line[index].indexInBoard
                }
            }
        }
        
        //blocking move
        for line in board.allLines() {
            let oCount = line.filter({ $0.type == .x }).count
            if oCount == 2 {
                if let index = line.index(where: { $0.type == .Empty}) {
                    return line[index].indexInBoard
                }
            }
        }
        
        if board[4] == .Empty {
            return 4
        }
        
        for (index, value) in board.enumerated() {
            if value == .Empty { return index }
        }
        
        return -1
    }
    
    class func status(forBoard board: [BoardValueType]) -> GameStatus {
        //Check rows
        var allLines = board.rows()
        allLines.append(contentsOf: board.cols())
        allLines.append(contentsOf: board.diags())
        
        for line in allLines {
            let lineStatus = status(forValues: line)
            if !lineStatus.isOpen() { return lineStatus }
        }

        if board.filter({ $0 == .Empty }).count == 0 {
            return .Draw
        }
        
        return .Open
    }
    
    class func status(forValues values: [BoardValue]) -> GameStatus {
        let xs = values.filter {$0.type == .x }.count
        if xs == 3 { return .Won(winningValues: values) }
        
        let os = values.filter {$0.type == .o }.count
        if os == 3 { return .Lost(winningValues: values) }
        
        return .Open
    }
    
}

extension Array where Element == BoardValueType {
    func allLines() -> [[BoardValue]] {
        var allLines = self.rows()
        allLines.append(contentsOf: self.cols())
        allLines.append(contentsOf: self.diags())
        
        return allLines
    }
    
    func rows() -> [[BoardValue]] {
        return [[ BoardValue(type: self[0], indexInBoard: 0),
                  BoardValue(type: self[1], indexInBoard: 1),
                  BoardValue(type: self[2], indexInBoard: 2)],
                [ BoardValue(type: self[3], indexInBoard: 3),
                  BoardValue(type: self[4], indexInBoard: 4),
                  BoardValue(type: self[5], indexInBoard: 5)],
                [ BoardValue(type: self[6], indexInBoard: 6),
                  BoardValue(type: self[7], indexInBoard: 7),
                  BoardValue(type: self[8], indexInBoard: 8)]]
    }
    
    func cols() -> [[BoardValue]] {
        return [[ BoardValue(type: self[0], indexInBoard: 0),
                  BoardValue(type: self[3], indexInBoard: 3),
                  BoardValue(type: self[6], indexInBoard: 6)],
                [ BoardValue(type: self[1], indexInBoard: 1),
                  BoardValue(type: self[4], indexInBoard: 4),
                  BoardValue(type: self[7], indexInBoard: 7)],
                [ BoardValue(type: self[2], indexInBoard: 2),
                  BoardValue(type: self[5], indexInBoard: 5),
                  BoardValue(type: self[8], indexInBoard: 8)]]
    }
    
    func diags() -> [[BoardValue]] {
        return [[ BoardValue(type: self[0], indexInBoard: 0),
                  BoardValue(type: self[4], indexInBoard: 4),
                  BoardValue(type: self[8], indexInBoard: 8)],
                [ BoardValue(type: self[2], indexInBoard: 2),
                  BoardValue(type: self[4], indexInBoard: 4),
                  BoardValue(type: self[6], indexInBoard: 6)]]
    }
}
