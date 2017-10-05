//
//  GameScene.swift
//  ThatStick
//
//  Created by Dominic Ammann on 21.09.17.
//  Edited by Leon Helg
//  Copyright © 2017 YungDomi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate  {
    static var score = integer_t()
    static var highscore = integer_t()
    var gamepause = Bool()
    var pausee = Bool()
    var stick = SKSpriteNode()
    var w1r = SKSpriteNode()
    var w1l = SKSpriteNode()
    var w2r = SKSpriteNode()
    var w2l = SKSpriteNode()
    var w3r = SKSpriteNode()
    var w3l = SKSpriteNode()
    var w4r = SKSpriteNode()
    var w4l = SKSpriteNode()
    var scorelabels = SKLabelNode()
    var scorelabel = SKLabelNode()
    
    var scoreabstand = CGFloat()
    
    
    // Motion manager for accelerometer
    let motionManager = CMMotionManager()
    
    // Acceleration value from accelerometer
    var xAcceleration: CGFloat = 0.0
    
    var labelhighscore = SKLabelNode()
    var numberhighscore = SKLabelNode()
    
    
    
    var header = SKSpriteNode()
    //var scorebool = Bool()
    var links1 = Bool()
    var links2 = Bool()
    var links3 = Bool()
    var links4 = Bool()
    var space1 = CGFloat()
    var space2 = CGFloat()
    var space3 = CGFloat()
    var space4 = CGFloat()
    var firstgamec = Bool()
    var gyro = Bool()
    
    var randomNum1 = integer_t()
    var randomNum = integer_t()
    var buttonpause: SKSpriteNode! = nil
    
    var wallspace = CGFloat()
    var walldownspeed = CGFloat()
    var wallsidespeed = CGFloat()
    var bottomremoving = CGFloat()
    var topplacing = CGFloat()
    var figurypos = CGFloat()
    var figdelay = integer_t()
    var randmax = integer_t()
    var randmin = integer_t()
    var gyrosens = CGFloat()
    var controller = Bool()
    var modechanges = Bool()
    var scoresafe = integer_t()
    var changed = Bool()
    
    
    
    override func didMove(to view: SKView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        // CoreMotion
        // 1
        motionManager.accelerometerUpdateInterval = 0.001
        // 2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (CMAccelerometerData, NSError) in
            // 3
            let acceleration = CMAccelerometerData?.acceleration
            // 4
            self.xAcceleration = CGFloat((acceleration?.x)!)
            
            
        } )
        
        
        
        physicsWorld.contactDelegate = self
        w1r = self.childNode(withName: "w1r") as! SKSpriteNode
        w1l = self.childNode(withName: "w1l") as! SKSpriteNode
        w2r = self.childNode(withName: "w2r") as! SKSpriteNode
        w2l = self.childNode(withName: "w2l") as! SKSpriteNode
        w3r = self.childNode(withName: "w3r") as! SKSpriteNode 
        w3l = self.childNode(withName: "w3l") as! SKSpriteNode
        w4r = self.childNode(withName: "w4r") as! SKSpriteNode
        w4l = self.childNode(withName: "w4l") as! SKSpriteNode
        header = self.childNode(withName: "header") as! SKSpriteNode
        scorelabels = self.childNode(withName: "scorelabels") as! SKLabelNode
        scorelabel = self.childNode(withName: "scorelabel") as! SKLabelNode
        stick = self.childNode(withName: "stick") as! SKSpriteNode
        labelhighscore = self.childNode(withName: "labelhighscore") as! SKLabelNode
        numberhighscore = self.childNode(withName: "numberhighscore") as! SKLabelNode
        
        
        setup()
    }
    
    func setup(){
        //veränderbare Werte
        randmax = 696
        randmin = 200
        figdelay = 0
        walldownspeed = 5
        wallsidespeed = 1
        bottomremoving = -650
        topplacing = 640
        figurypos = -355
        //gyrosensor sensibilität
        gyrosens = 1000
        modechanges = false
        
        //nicht unter 320!!
        wallspace = 320
        
        
        //Highscore
        let gos = GameOverScene()
        GameScene.highscore = integer_t(gos.getHighScore())
        //nicht verändern
        scoreabstand = walldownspeed / 2
        controller = false
        scoresafe = -20
        
        
        //max 1000 min 895
        space1 = 895
        space2 = 895
        space3 = 895
        space4 = 895
        
        gyro = false
        
         changed = false
        links1 = false
       
        links2 = true
        links3 = false
        links4 = true
        GameScene.score = 0
        numberhighscore.text = String(gos.getHighScore())
        firstgamec = true
        w1l.zPosition = -1
        w1r.zPosition = -1
        w2l.zPosition = -1
        w2r.zPosition = -1
        w3l.zPosition = -1
        w3r.zPosition = -1
        w4l.zPosition = -1
        w4r.zPosition = -1
        header.zPosition = 0
        scorelabel.zPosition = 0
        scorelabels.zPosition = 0
        scorelabels.text = String(0)
        settop()
        
        
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w4r.position.x = CGFloat(randomNum1)
        w4l.position.x = w4r.position.x - space4
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w3r.position.x = CGFloat(randomNum1)
        w3l.position.x = w3r.position.x - space3
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w2r.position.x = CGFloat(randomNum1)
        w2l.position.x = w2r.position.x - space2
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w1r.position.x = CGFloat(randomNum1)
        w1l.position.x = w1r.position.x - space1
        // scorebool = true
        gamepause = false
    }
    func settop(){
        w1l.position.y = topplacing
        w1r.position.y = topplacing
        w2l.position.y = topplacing
        w2r.position.y = topplacing
        w3l.position.y = topplacing
        w3r.position.y = topplacing
        w4l.position.y = topplacing
        w4r.position.y = topplacing
    }
    override func didSimulatePhysics() {
        // 1
        // Set velocity based on x-axis acceleration
        
        if pausee {
            
        }else{
        }
            if gamepause{
                
            }else{
        if !gyro{
            if (xAcceleration != 0){
                xAcceleration = 0
            }
        }else{
            
            stick.physicsBody?.velocity = CGVector(dx: xAcceleration * gyrosens, dy: stick.physicsBody!.velocity.dy)
                }
        }
        
    }
    
    
    
    //Erstes Spiel: Dafür da, dass Balken von oben kommen und man nicht direkt ausweichen muss.
    func firstgame(){
        if (w4r.position.y >= bottomremoving){
            w1r.position.y = w1r.position.y - walldownspeed
            w1l.position.y = w1l.position.y - walldownspeed
            if w1r.position.y <= topplacing-wallspace{
                w2r.position.y = w2r.position.y - walldownspeed
                w2l.position.y = w2l.position.y - walldownspeed
            }
            if w2r.position.y <= topplacing-wallspace{
                w3r.position.y = w3r.position.y - walldownspeed
                w3l.position.y = w3l.position.y - walldownspeed
            }
            if w3r.position.y <= topplacing-wallspace{
                w4r.position.y = w4r.position.y - walldownspeed
                w4l.position.y = w4l.position.y - walldownspeed
            }
        }
        
        check()
        walls()
    }
    
    override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent?){
        if pausee {
            pausee = !pausee
        }else{
            if gamepause {
            }else{
                if (gyro == false){
                    for touch in touches{
                        let location = touch.location(in: self)
                        stick.run(SKAction.moveTo(x: location.x, duration: TimeInterval(figdelay)))
                    
                }
            }
            }
        }
    }
    
    @objc func doubleTapped() {
        pausee = !pausee
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Was there a seal involved in the collision ? */
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
          gamepause = true
        }
    }
    
    
    func check(){
        if w1r.position.y <= bottomremoving && w4r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
           
                w1r.position.y = (w4r.position.y + wallspace)
                w1l.position.y = (w4l.position.y + wallspace)
                firstgamec = false
                w1r.position.x = CGFloat(randomNum)
                w1l.position.x = w1r.position.x - space1
            
            
        }
        
        if w2r.position.y <= bottomremoving && w1r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
            
                w2r.position.y = (w1r.position.y + wallspace)
                w2l.position.y = (w1l.position.y + wallspace)
                w2r.position.x = CGFloat(randomNum)
                w2l.position.x = w2r.position.x - space2
            
            
          
        }
        
        if w3r.position.y <= bottomremoving && w2r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
            
                w3r.position.y = (w2r.position.y + wallspace)
                w3l.position.y = (w2l.position.y + wallspace)
                w3r.position.x = CGFloat(randomNum)
                w3l.position.x = w3r.position.x - space3
            
            
        
        }
        
        if w4r.position.y <= bottomremoving && w2r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
            if (!modechanges){
                w4r.position.y = (w3r.position.y + wallspace)
                w4l.position.y = (w3l.position.y + wallspace)
                w4r.position.x = CGFloat(randomNum)
                w4l.position.x = w4r.position.x - space4
            }
        }
     
        scorefunc()
    }
    
    
    func move(){
        
        w1r.position.y = w1r.position.y - walldownspeed
        w2r.position.y = w2r.position.y - walldownspeed
        w3r.position.y = w3r.position.y - walldownspeed
        w4r.position.y = w4r.position.y - walldownspeed
        w1l.position.y = w1l.position.y - walldownspeed
        w2l.position.y = w2l.position.y - walldownspeed
        w3l.position.y = w3l.position.y - walldownspeed
        w4l.position.y = w4l.position.y - walldownspeed
    }
    
    func walls(){
        if w1r.position.x <= CGFloat(randmin){
            links1 = true
        }else if w1r.position.x >= CGFloat(randmax-1){
            links1 = false
        }
        if w2r.position.x <= CGFloat(randmin){
            links2 = true
        }else if w2r.position.x >= CGFloat(randmax-1){
            links2 = false
        }
        if w3r.position.x <= CGFloat(randmin){
            links3 = true
        }else if w3r.position.x >= CGFloat(randmax-1){
            links3 = false
        }
        if w4r.position.x <= CGFloat(randmin){
            links4 = true
        }else if w4r.position.x >= CGFloat(randmax-1){
            links4 = false
        }
        if links1{
            w1r.position.x = w1r.position.x + wallsidespeed
            w1l.position.x = w1l.position.x + wallsidespeed
        }else{
            w1r.position.x = w1r.position.x - wallsidespeed
            w1l.position.x = w1l.position.x - wallsidespeed
        }
        if links2{
            w2r.position.x = w2r.position.x + wallsidespeed
            w2l.position.x = w2l.position.x + wallsidespeed
        }else{
            w2r.position.x = w2r.position.x - wallsidespeed
            w2l.position.x = w2l.position.x - wallsidespeed
        }
        if links3{
            w3r.position.x = w3r.position.x + wallsidespeed
            w3l.position.x = w3l.position.x + wallsidespeed
        }else{
            w3r.position.x = w3r.position.x - wallsidespeed
            w3l.position.x = w3l.position.x - wallsidespeed
        }
        if links4{
            w4r.position.x = w4r.position.x + wallsidespeed
            w4l.position.x = w4l.position.x + wallsidespeed
        }else{
            w4r.position.x = w4r.position.x - wallsidespeed
            w4l.position.x = w4l.position.x - wallsidespeed
        }
    }
    func scorefunc(){
        if (w1r.position.y - figurypos <= scoreabstand && w1r.position.y - figurypos >= -scoreabstand) || (w2r.position.y - figurypos <= scoreabstand && w2r.position.y - figurypos >= -scoreabstand) || (w3r.position.y - figurypos <= scoreabstand && w3r.position.y - figurypos >= -scoreabstand) || (w4r.position.y - figurypos <= scoreabstand && w4r.position.y - figurypos >= -scoreabstand) {
            GameScene.score += 1
            scorelabels.text = String(GameScene.score)
            if GameScene.score >= GameScene.highscore {
                GameScene.highscore = GameScene.score
                numberhighscore.text = String(GameScene.highscore)
            }
        }
    }
    func modechange_placing(){
        
        
        randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w1r.position.x = CGFloat(randomNum)
        w1l.position.x = w1r.position.x - space1
        randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w2r.position.x = CGFloat(randomNum)
        w2l.position.x = w2r.position.x - space2
        randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w3r.position.x = CGFloat(randomNum)
        w3l.position.x = w3r.position.x - space3
        randomNum = integer_t(Int(arc4random_uniform(UInt32(randmax) - UInt32(randmin)) + UInt32(randmin)))
        w4r.position.x = CGFloat(randomNum)
        w4l.position.x = w4r.position.x - space4
        
        w1r.position.y = topplacing
        w1l.position.y = topplacing
        w2r.position.y = w1r.position.y + wallspace
        w2l.position.y = w1r.position.y + wallspace
        w3r.position.y = w2r.position.y + wallspace
        w3l.position.y = w2r.position.y + wallspace
        w4r.position.y = w3r.position.y + wallspace
        w4l.position.y = w3r.position.y + wallspace
        
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if pausee{
        }else {
            if gamepause {
                if let scene = GameOverScene(fileNamed: "GameOverScene") {
                    scene.scaleMode = .aspectFill
                    view?.presentScene(scene)
                }
            }else{
                if firstgamec{
                firstgame()
                }else{
                    if (!modechanges && GameScene.score % 15 == 0) {
                        modechanges = true
                        scoresafe = GameScene.score
                    }
                    if (modechanges && GameScene.score == scoresafe + 10){
                        scoresafe = -20
                        modechanges = false
                        changed = true
                     
                    }
                    
                    if (modechanges) {
                        if (w1r.position.y <= bottomremoving && w2r.position.y <= bottomremoving && w3r.position.y <= bottomremoving && w4r.position.y <= bottomremoving) {
                            
                            gyro = true
                            scorefunc()
                            randmin = 300
                            
                            walldownspeed = 5
                            wallspace = 1000
                            space1 = 1000
                            space2 = 1000
                            space3 = 1000
                            space4 = 1000
                            modechange_placing()
                        }else{
                            if (gyro){
                                move()
                                check()
                        
                                walls()
                            }else{
                            move()
                            
                            scorefunc()
                            walls()
                            }
                        }
                    } else {
                          xAcceleration = 0
                        if (changed){
                            
                            if (w1r.position.y <= bottomremoving && w2r.position.y <= bottomremoving && w3r.position.y <= bottomremoving && w4r.position.y <= bottomremoving) {
                                
                                randmin = 200
                                wallspace = 320
                                space1 = 895
                                space2 = 895
                                space3 = 895
                                space4 = 895
                                modechange_placing()
                                changed = false
                                gyro = false
                                xAcceleration = 0
                                
                            }else{
                                move()
                                scorefunc()
                                walls()
                            }
                            
                        }else{
                        move()
                        check()
                       walls()
                        }
                        }
                    }
                }
            }
        }
    }


