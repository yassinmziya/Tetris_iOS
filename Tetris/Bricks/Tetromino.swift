//
//  TTetromino.swift
//  Tetris
//
//  Created by Yassin Mziya on 5/25/20.
//  Copyright © 2020 Yassin Mziya. All rights reserved.
//

import UIKit

var TETROMINO_SQUARE_HEIGHT: CGFloat {
    return UIScreen.main.bounds.width/10
}

class Tetromino: UIView {
    
    let tetrominoShape: TetrominoShape
    
    init(origin: CGPoint, tetrominoShape: TetrominoShape) {
        self.tetrominoShape = tetrominoShape
        let frame = CGRect(x: origin.x, y: origin.y, width: tetrominoShape.size.width, height: tetrominoShape.size.height)
        super.init(frame: frame)
        
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawTetromino(rect)
    }
    
    private func drawTetromino(_ rect: CGRect) {
        let path = UIBezierPath()
        for (y, row) in tetrominoShape.matrix.enumerated() {
            for (x, col) in row.enumerated() {
                if col == 1 {
                    let strokeStart = CGPoint(x: rect.minX + TETROMINO_SQUARE_HEIGHT * CGFloat(x), y: rect.minY + (TETROMINO_SQUARE_HEIGHT * 0.5) + TETROMINO_SQUARE_HEIGHT * CGFloat(y))
                    let strokeEnd = CGPoint(x: strokeStart.x + TETROMINO_SQUARE_HEIGHT, y: strokeStart.y)
                    path.move(to: strokeStart)
                    path.addLine(to: strokeEnd)
                }
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = TETROMINO_SQUARE_HEIGHT
        shapeLayer.borderColor = UIColor.blue.cgColor
        shapeLayer.borderWidth = 1
        
        layer.addSublayer(shapeLayer)
    }
    
    func rotate() {
        transform = transform.rotated(by: CGFloat.pi * 0.5)
        snapToGrid()
    }
    
    func snapToGrid() {
        frame.origin.x -= (frame.origin.x.truncatingRemainder(dividingBy: TETROMINO_SQUARE_HEIGHT))
        frame.origin.y -= (frame.origin.y.truncatingRemainder(dividingBy: TETROMINO_SQUARE_HEIGHT))
    }
    
    enum TetrominoShape {
        case tShaped, lShaped, square, straigt, skew
        
        var size: CGSize {
            switch  self {
            case .tShaped, .skew:
                return CGSize(width: 3 * TETROMINO_SQUARE_HEIGHT, height: 2 * TETROMINO_SQUARE_HEIGHT)
            case .lShaped:
                return CGSize(width: 2 * TETROMINO_SQUARE_HEIGHT, height: 4 * TETROMINO_SQUARE_HEIGHT)
            case .square:
                return CGSize(width: 2 * TETROMINO_SQUARE_HEIGHT, height: 2 * TETROMINO_SQUARE_HEIGHT)
            case .straigt:
                return CGSize(width: 4 * TETROMINO_SQUARE_HEIGHT, height: 1 * TETROMINO_SQUARE_HEIGHT)
            }
        }
        
        var matrix: [[Int]] {
            switch self {
            case .lShaped:
                return [[1,0],
                        [1,0],
                        [1,0],
                        [1,1]]
            case.square:
                return [[1,1],
                        [1,1]]
            case .skew:
                return [[0,1,1],
                        [1,1,0]]
            case .tShaped:
                return [[1,1,1],
                        [0,1,0]]
            case .straigt:
                return [[1,1,1,1]]
            }
        }
    }
    
}
