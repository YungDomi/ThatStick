//
//  StartScene.swift
//  ThatStick
//
//  Created by Leon Helg on 03.10.17.
//  Copyright © 2017 YungDomi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var tapplay = SKLabelNode()
    var timer = Timer()
    var kleiner = Bool()
    
    //Konstruktor
    override func didMove(to view: SKView) {
        tapplay = self.childNode(withName: "tapplay") as! SKLabelNode
        tapplay.fontSize = 70
        scheduledTimerWithTimeInterval()
    }
    
    //Timer für die Schriftgrössenveränderung
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    //Animiert die "Tap top Play" Schrift
    @objc func updateCounting(){
        if tapplay.fontSize <= 65 {
            kleiner = true
        }
        if tapplay.fontSize >= 75 {
            kleiner = false
        }
        if (kleiner){
            tapplay.fontSize = tapplay.fontSize + 1
        }else{
            tapplay.fontSize = tapplay.fontSize - 1
        }
    }
    
    //Startet das Spiel bei einem Tipp auf den Screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches{
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
        }
    }  
}

