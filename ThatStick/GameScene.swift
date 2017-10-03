//
//  GameScene.swift
//  ThatStick
//
//  Created by Dominic Ammann on 21.09.17.
//  Copyright © 2017 YungDomi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    var gamepause = Bool()
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
    var score = integer_t()
    var header = SKSpriteNode()
    var scorebool = Bool()
    var links1 = Bool()
    var links2 = Bool()
    var links3 = Bool()
    var links4 = Bool()
    var space1 = CGFloat()
    var space2 = CGFloat()
    var space3 = CGFloat()
    var space4 = CGFloat()
    var firstgamec = Bool()

    override func didMove(to view: SKView) {
        
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
        
       setup()
        
    }
    func setup(){
        space1 = 895
        space2 = 895
        space3 = 895
        space4 = 895
        links1 = true
        links2 = true
        links3 = true
        links4 = true
        score = 0
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
        w1l.position.y = 640
        w1r.position.y = 640
        w2l.position.y = 640
        w2r.position.y = 640
        w3l.position.y = 640
        w3r.position.y = 640
        w4l.position.y = 640
        w4r.position.y = 640
        
        w4l.position.x = -400
        w4r.position.x = w4l.position.x + space4
        w3l.position.x = -255
        w3r.position.x = w3l.position.x + space3
        w2l.position.x = -695
        w2r.position.x = w2l.position.x + space2
        w1l.position.x = -450
        w1r.position.x = w1l.position.x + space1
        scorebool = true
        gamepause = false
    }
    func firstgame(){
        if (w4r.position.y >= -640){
            w4r.position.y = w4r.position.y - 5
            w4l.position.y = w4l.position.y - 5
            if w4r.position.y <= 320{
                w3r.position.y = w3r.position.y - 5
                w3l.position.y = w3l.position.y - 5
            }
            if w3r.position.y <= 320{
                w2r.position.y = w2r.position.y - 5
                w2l.position.y = w2l.position.y - 5
            }
            if w2r.position.y <= 320{
                w1r.position.y = w1r.position.y - 5
                w1l.position.y = w1l.position.y - 5
            }

        }else{
            firstgamec = false
        }
        check()
    }
    
   
    
 
    override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent?){
        if gamepause {
            
            
        }else{
           
        for touch in touches{
                let location = touch.location(in: self)
                stick.run(SKAction.moveTo(x: location.x, duration: 0))
            }
        }
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
        if w1r.position.y <= -650 {
            w1r.position.y = 640
            w1l.position.y = 640
            scorebool = true
            firstgamec = false
            
            
            
        }
        if w2r.position.y <= -650 {
            w2r.position.y = 640
            w2l.position.y = 640
            scorebool = true
        }
        if w3r.position.y <= -650 {
            w3r.position.y = 640
            w3l.position.y = 640
            scorebool = true
        }
        if w4r.position.y <= -650 {
            w4r.position.y = 640
            w4l.position.y = 640
            scorebool = true
        }
        
        if w1r.position.y <= -430 || w2r.position.y <= -430 || w3r.position.y <= -430 || w4r.position.y <= -430 {
            if scorebool {
                score += 1
                scorelabels.text = String(score)
            }
            scorebool = false
       
        }
        
        
        
    }
    func move(){
        w1r.position.y = w1r.position.y - 5
        w2r.position.y = w2r.position.y - 5
        w3r.position.y = w3r.position.y - 5
        w4r.position.y = w4r.position.y - 5
        w1l.position.y = w1l.position.y - 5
        w2l.position.y = w2l.position.y - 5
        w3l.position.y = w3l.position.y - 5
        w4l.position.y = w4l.position.y - 5
    }
    
    func walls(){
        if w1r.position.x <= 200{
            links1 = true
        }else if w1r.position.x >= 695{
            links1 = false
        }
        if w2r.position.x <= 200{
            links2 = true
        }else if w2r.position.x >= 695{
            links2 = false
        }
        if w3r.position.x <= 200{
            links3 = true
        }else if w3r.position.x >= 695{
            links3 = false
        }
        if w4r.position.x <= 200{
            links4 = true
        }else if w4r.position.x >= 695{
            links4 = false
        }
        if links1{
            w1r.position.x = w1r.position.x + 1
            w1l.position.x = w1l.position.x + 1
        }else if !links1{
            w1r.position.x = w1r.position.x - 1
            w1l.position.x = w1l.position.x - 1
        }
        if links2{
            w2r.position.x = w2r.position.x + 1
            w2l.position.x = w2l.position.x + 1
        }else if !links2{
            w2r.position.x = w2r.position.x - 1
            w2l.position.x = w2l.position.x - 1
        }
        if links3{
            w3r.position.x = w3r.position.x + 1
            w3l.position.x = w3l.position.x + 1
        }else if !links1{
            w3r.position.x = w3r.position.x - 1
            w3l.position.x = w3l.position.x - 1
        }
        if links4{
            w4r.position.x = w4r.position.x + 1
            w4l.position.x = w4l.position.x + 1
        }else if !links4{
            w4r.position.x = w4r.position.x - 1
            w4l.position.x = w4l.position.x - 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
         if gamepause {
       
        }else{
        if firstgamec{
           firstgame()
        }else{
                walls()
                move()
                check()
            }
        }
    }
        
        
        
    }

