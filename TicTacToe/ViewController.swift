//
//  ViewController.swift
//  TicTacToe
//
//  Created by Anteneh Sahledengel on 8/30/17.
//  Copyright © 2017 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var boardView: UIView!
    @IBOutlet var lineView: LineView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var newGameButton: UIButton!
    
    var board: [BoardValueType] = [] {
        didSet {
            updateButtonTitles()
        }
    }
    
    var buttons: [UIButton] = []
    
    var isPlayersTurn = true
    var isXsTurn = true
    var gameStatus: GameStatus = .Open
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupInitialState()
    }
    
    // MARK: View setup
    
    func setupInitialState() {
        boardView.subviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        board = Array(repeating: BoardValueType.Empty, count: 9)
        isPlayersTurn = true
        gameStatus = .Open
        infoLabel.isHidden = true
        newGameButton.isHidden = true
        lineView.isHidden = true
        
        let width = boardView.frame.size.width * 0.3
        let height = boardView.frame.size.height * 0.3
        let xSpacing = boardView.frame.size.width * 0.025
        let ySpacing = boardView.frame.size.height * 0.025
        
        var xPos: CGFloat, yPos: CGFloat = 0.0
        
        for y in 0..<3 {
            for x in 0..<3 {
                xPos = xSpacing + (CGFloat(x) * width) + (CGFloat(x) * xSpacing)
                yPos = ySpacing + (CGFloat(y) * height) + (CGFloat(y) * ySpacing)
                
                let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
                button.backgroundColor = UIColor.lightGray
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.heavy)
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                buttons.append(button)
                boardView.addSubview(button)
            }
        }
        
        nextStep()
    }
    
    private func updateButtonTitles() {
        for (index, button) in self.buttons.enumerated() {
            setValue(board[index], toButton: button)
        }
    }
    
    private func setValue(_ value: BoardValueType, toButton button: UIButton) {
        button.setTitle(value.rawValue, for: .normal)
        switch value {
        case .x:
            button.setTitleColor(.black, for: .normal)
        default:
            button.setTitleColor(.blue, for: .normal)
        }
    }

    // MARK: Actions

    @objc func buttonTapped(_ sender: UIButton) {
        guard isPlayersTurn else { return }
        
        let index = buttons.index(of: sender)!
        if board[index] == .Empty {
            board[index] = .x
        }
        
        isPlayersTurn = false
        nextStep()
    }
    
    @IBAction func newGameButtonTapped(_ sender: Any) {
        setupInitialState()
    }
    
    // MARK: Game play
    
    func nextStep() {
        updateGameStatus()
        if self.gameStatus.isOpen() {
            if !isPlayersTurn {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    let nextMove = BoardManager.nextBestMove(forBoard: self.board)
                    if nextMove != -1 {
                        self.board[nextMove] = .o
                        
                        self.isPlayersTurn = true
                        self.nextStep()
                    }
                })
            }
        } else {
            displayResult()
        }
    }
    
    func updateGameStatus() {
        self.gameStatus = BoardManager.status(forBoard: self.board)
    }
    
    func displayResult() {
        infoLabel.isHidden = false
        infoLabel.text = self.gameStatus.message()
        
        newGameButton.isHidden = false
        
        let winningValues = self.gameStatus.winningValues()!
        
        self.lineView.isHidden = false
        self.lineView.startPoint = self.buttons[winningValues.first!.indexInBoard].center
        self.lineView.endPoint = self.buttons[winningValues.last!.indexInBoard].center
        self.lineView.beginAnimation()
    }
}

