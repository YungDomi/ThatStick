//
//  GameOverScene.swift
//  ThatStick
//
//  Created by Leon Helg on 04.10.17.
//  Copyright © 2017 YungDomi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit


class GameOverScene: SKScene {
    var labelscore = SKLabelNode()
    var numberscore = SKLabelNode()
    var tapplay = SKLabelNode()
    var timer = Timer()
    var kleiner = Bool()
    
    

    override func didMove(to view: SKView) {
        tapplay = self.childNode(withName: "tapplay") as! SKLabelNode
        tapplay.fontSize = 55
        scheduledTimerWithTimeInterval()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        labelscore = self.childNode(withName: "labelscore") as! SKLabelNode
        numberscore = self.childNode(withName: "numberscore") as! SKLabelNode
        
        setup()
        score()
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        
        if tapplay.fontSize <= 45 {
            kleiner = true
        }
        if tapplay.fontSize >= 65 {
            kleiner = false
        }
        if (kleiner){
            tapplay.fontSize = tapplay.fontSize + 1
        }else{
            tapplay.fontSize = tapplay.fontSize - 1
        }
    }
    
    func setup(){
        labelscore.zPosition = 0
        numberscore.zPosition = 0
        numberscore.text = String(0)
    }
    
    func score(){
        numberscore.text = String(describing: GameScene.score)
    }
    
    @objc func doubleTapped() {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene)
        }
    }
    
}
