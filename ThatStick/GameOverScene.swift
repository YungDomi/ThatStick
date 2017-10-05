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
    //var labelscore = SKLabelNode()
    var numberscore = SKLabelNode()
    var labelhighscore = SKLabelNode()
    var numberhighscore = SKLabelNode()
    
    var savehighscore = UserDefaults().integer(forKey: "HIGHSCORE")
    
    var newhighscore = SKLabelNode()
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
        
        //Zeigt Scores, Higscore und wenn ein neuer Highscore geknackt wurde
        //labelscore = self.childNode(withName: "labelscore") as! SKLabelNode
        numberscore = self.childNode(withName: "numberscore") as! SKLabelNode
        labelhighscore = self.childNode(withName: "labelhighscore") as! SKLabelNode
        numberhighscore = self.childNode(withName: "numberhighscore") as! SKLabelNode
        newhighscore = self.childNode(withName: "newhighscore") as! SKLabelNode
        
        setup()
        score()
        
    }
    
    //Timer um die Schriftgrösse zu verändern
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateCounting(){
        
        if tapplay.fontSize <= 50 {
            kleiner = true
        }
        if tapplay.fontSize >= 60 {
            kleiner = false
        }
        if (kleiner){
            tapplay.fontSize = tapplay.fontSize + 1
        }else{
            tapplay.fontSize = tapplay.fontSize - 1
        }
    }
    
    
    func setup(){
        //labelscore.zPosition = 0
        numberscore.zPosition = 0
        numberscore.text = String(0)
        
        labelhighscore.zPosition = 0
        numberhighscore.zPosition = 0
        numberhighscore.text = String(getHighScore())
        newhighscore.zPosition = 0
        newhighscore.isHidden = true
    }
    
    
    func score(){
        numberscore.text = String(describing: GameScene.score)
        numberhighscore.text = String(describing: GameScene.highscore)
        
        if (GameScene.score == GameScene.highscore) {
            labelhighscore.isHidden = true
            numberhighscore.isHidden = true
            newhighscore.isHidden = false
            saveHighScore()
        }
    }
    
    func getHighScore() -> Int {
        return UserDefaults().integer(forKey: "HIGHSCORE")
    }
    
    
    func saveHighScore(){
        UserDefaults().set(Int(GameScene.highscore), forKey: "HIGHSCORE")
        UserDefaults().synchronize()
    }
    
    
    @objc func doubleTapped() {
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene)
        }
    }
    
}
