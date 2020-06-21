//
//  ViewController.swift
//  Tetris
//
//  Created by Yassin Mziya on 5/25/20.
//  Copyright © 2020 Yassin Mziya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tetromino = Tetromino(origin: .zero, tetrominoShape: .tShaped) {
        didSet {
            view.addSubview(tetromino)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        view.addSubview(tetromino)
        installGestureRecognizers()
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.tetromino.frame.maxY <= self.view.frame.maxY - 3 * TETROMINO_SQUARE_HEIGHT {
                self.tetromino.frame.origin.y += TETROMINO_SQUARE_HEIGHT
            } else {
                let shapes: [Tetromino.TetrominoShape] = [.skew,.lShaped,.square,.straigt,.tShaped]
                self.tetromino = Tetromino(origin: .zero, tetrominoShape: shapes.randomElement()!)
            }
        }
    }
    
    func installGestureRecognizers() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle(tapGesture:))))
        view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(handle(swipeGetsure:))))
    }
    
    @objc private func handle(tapGesture: UITapGestureRecognizer) {
        let location = tapGesture.location(in: view)
        if location.x < view.frame.midX {
            tetromino.frame.origin.x = max(0, tetromino.frame.origin.x - TETROMINO_SQUARE_HEIGHT)
        } else {
            tetromino.frame.origin.x = min(view.frame.maxX - tetromino.frame.width, tetromino.frame.origin.x + TETROMINO_SQUARE_HEIGHT)
        }
    }
    
    @objc func handle(swipeGetsure: UISwipeGestureRecognizer) {
        guard [.right, .down].contains(swipeGetsure.direction) else { return }
        tetromino.rotate()
    }

}

