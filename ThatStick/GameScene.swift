//
//  GameScene.swift
//  ThatStick
//
//  Created by Dominic Ammann on 21.09.17.
//  Edited by Leon Helg & Dominic Ammann
//  Copyright © 2017 YungDomi. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate  {
    //Global
    static var score = integer_t()
    static var highscore = integer_t()

    //Grafische Objekte
    var stick = SKSpriteNode()
    var w1r = SKSpriteNode()
    var w1l = SKSpriteNode()
    var w2r = SKSpriteNode()
    var w2l = SKSpriteNode()
    var w3r = SKSpriteNode()
    var w3l = SKSpriteNode()
    var w4r = SKSpriteNode()
    var w4l = SKSpriteNode()
    var header = SKSpriteNode()
    var numberscore = SKLabelNode()
    var labelscore = SKLabelNode()
    var labelhighscore = SKLabelNode()
    var numberhighscore = SKLabelNode()
    
    //Variablen für Gyrosensor
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    //Booleans
    var links1 = Bool()
    var links2 = Bool()
    var links3 = Bool()
    var links4 = Bool()
    var modechanges = Bool()
    var changed = Bool()
    var firstgamec = Bool()
    var gyro = Bool()
    var controller = Bool()
    var game_over = Bool()
    var game_paused = Bool()
    var gyroAUS = Bool()
    
    //Floats
    var space1 = CGFloat()
    var space2 = CGFloat()
    var space3 = CGFloat()
    var space4 = CGFloat()
    var wallbottomupspace = CGFloat()
    var wallleftrightspace = CGFloat()
    var walldownspeed = CGFloat()
    var wallsidespeed = CGFloat()
    var bottomremoving = CGFloat()
    var topplacing = CGFloat()
    var figurypos = CGFloat()
    var gyrosens = CGFloat()
    var scoreabstand = CGFloat()
    
    //Integers
    var figdelay = integer_t()
    var borderMax = integer_t()
    var borderMin = integer_t()
    var scoresafe = integer_t()
    var randomNum1 = integer_t()
    var randomNum = integer_t()
    
    
    //Konstruktor
    override func didMove(to view: SKView) {
        //Prüft ob ein Doppelklick gemacht wird (um anschliessend das game zu pausieren)
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        //Handelt die Gyrosensor Steuerung
        motionManager.accelerometerUpdateInterval = 0.001
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (CMAccelerometerData, NSError) in
            let acceleration = CMAccelerometerData?.acceleration
            self.xAcceleration = CGFloat((acceleration?.x)!)
        } )
        
        //initialisiert alle Grafischen Objekte
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
        numberscore = self.childNode(withName: "numberscore") as! SKLabelNode
        labelscore = self.childNode(withName: "labelscore") as! SKLabelNode
        stick = self.childNode(withName: "stick") as! SKSpriteNode
        labelhighscore = self.childNode(withName: "labelhighscore") as! SKLabelNode
        numberhighscore = self.childNode(withName: "numberhighscore") as! SKLabelNode
        
        if let scene = self.scene {
            scene.backgroundColor = SKColor.black
        }
        setup()
    }
    
    //Wird beim Programmstart aufgerufen und setzt Standardwerte. Hier können Werte angepasst werden.
    func setup(){
        //VERÄNDERBARE WERTE//
        //Minimal und Maximalzahlen damit die Wände ihre "Öffnungen" nicht ausserhalb des Screens haben wenn sie Random generiert werden.
        borderMax = 696
        borderMin = 200
        
        //Geschwindigkeit der Wände:     3: einfach (5: normal 10: expert 15: asian
        walldownspeed = 5
        wallsidespeed = 1
        
        //Y-Koordinate ab welchem Punkt die Wände gelöscht und wieder gespawnt werden
        bottomremoving = -650
        topplacing = 640
        
        //Höhe der Figur auf dem Screen
        figurypos = -355
        
        //gyrosensor sensibilität
        gyrosens = 1000
        
        //nicht unter 320!!
        wallbottomupspace = 420
        
        //Verzögerung (nicht empfohlen)
        figdelay = 0
        
        //max 1000 min 895
        wallleftrightspace = 930
        
        //Highscore auf Gerät speichern
        let gos = GameOverScene()
        GameScene.highscore = integer_t(gos.getHighScore())
        
        //Deaktiviert den Gyro Modus
        gyroAUS = true
        
        //NICHT VERÄNDERBARE WERTE//
        scoresafe = -20
        controller = false
        gyro = false
        changed = false
        modechanges = false
        firstgamec = true
        game_over = false
        
        //Holt den Highscore beim Aufstarten auf dem Speicher des Endgeräts
        GameScene.score = 0
        numberhighscore.text = String(gos.getHighScore())
        
        //Auslagerung einiger Definitionen der grafischen Objekte
        setTiefe()
        setLeftRight()
        setSpaces(abstand: wallleftrightspace)
        settop()
        randomPlacer()
    }
    
    //Sorgt dafür dass die Wände zufällig auf der X-Achse (jedoch im Screen) gespawnt werden.
    func randomPlacer(){
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w4r.position.x = CGFloat(randomNum1)
        w4l.position.x = w4r.position.x - space4
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w3r.position.x = CGFloat(randomNum1)
        w3l.position.x = w3r.position.x - space3
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w2r.position.x = CGFloat(randomNum1)
        w2l.position.x = w2r.position.x - space2
        randomNum1 = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w1r.position.x = CGFloat(randomNum1)
        w1l.position.x = w1r.position.x - space1
    }
    
    //Setzt alle Wände nach oben (wird im Setup aufgerufen)
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
    
    //Setzt die Abstände zwischen den Wänden (wird in der Main Funktion, sowie im Setup aufgerufen
    func setSpaces(abstand: CGFloat) {
        space1 = abstand
        space2 = abstand
        space3 = abstand
        space4 = abstand
    }
    
    //Standardwerte in welche (linksrechts) Richtung die Wände sich bewegen
    func setLeftRight(){
        links1 = false
        links2 = true
        links3 = false
        links4 = true
    }
    
    //Definiert die Tiefe (vorne/hinten btw nah/fern) der Objekte
    func setTiefe(){
        w1l.zPosition = -1
        w1r.zPosition = -1
        w2l.zPosition = -1
        w2r.zPosition = -1
        w3l.zPosition = -1
        w3r.zPosition = -1
        w4l.zPosition = -1
        w4r.zPosition = -1
        header.zPosition = 0
        labelscore.zPosition = 0
        numberscore.zPosition = 0
        numberscore.text = String(0)
    }
    
    //Erstes Spiel: Dafür da, dass Balken von oben kommen und man nicht direkt ausweichen muss.
    func firstgame(){
        if (w4r.position.y >= bottomremoving){
            w1r.position.y = w1r.position.y - walldownspeed
            w1l.position.y = w1l.position.y - walldownspeed
            if w1r.position.y <= topplacing-wallbottomupspace{
                w2r.position.y = w2r.position.y - walldownspeed
                w2l.position.y = w2l.position.y - walldownspeed
            }
            if w2r.position.y <= topplacing-wallbottomupspace{
                w3r.position.y = w3r.position.y - walldownspeed
                w3l.position.y = w3l.position.y - walldownspeed
            }
            if w3r.position.y <= topplacing-wallbottomupspace{
                w4r.position.y = w4r.position.y - walldownspeed
                w4l.position.y = w4l.position.y - walldownspeed
            }
        }
        check()
        walls()
    }
    
    //Gyro Steuerung
    override func didSimulatePhysics() {
        if game_paused {
            //do nothing
        }else{
        }
        if game_over{
            //do nothing
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
    
    //Touch Steuerung
    override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent?){
        if game_paused {
            //Im Pausemenu kann man durch Bewegung des Sticks direkt weiterspielen.
            game_paused = !game_paused
        }else{
            if game_over {
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
    
    //Pausiert das Spiel bei einem Doppeltipp
    @objc func doubleTapped() {
        game_paused = !game_paused
    }
    
    //Ruft ein Gameover bei einer Kolission hervor
    func didBegin(_ contact: SKPhysicsContact) {
        //Bestimmt die zu checkenden Elemente
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            game_over = true
        }
    }
    
    /*
     "Check"t ob eine Wand bereits unten angekommen ist (bottomremoving) und ob die vorherige Wand bereits zurückgesetzt wurde (topplacing). Wenn ja, setzt es die entsprechende Wand im definiertem Y-Abstand (wallbottumupspace) und setzt die X-Koordinate Random
     */
    func check(){
        if w1r.position.y <= bottomremoving && w4r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
            w1r.position.y = (w4r.position.y + wallbottomupspace)
            w1l.position.y = (w4l.position.y + wallbottomupspace)
            firstgamec = false
            w1r.position.x = CGFloat(randomNum)
            w1l.position.x = w1r.position.x - space1
        }
        
        if w2r.position.y <= bottomremoving && w1r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
            w2r.position.y = (w1r.position.y + wallbottomupspace)
            w2l.position.y = (w1l.position.y + wallbottomupspace)
            w2r.position.x = CGFloat(randomNum)
            w2l.position.x = w2r.position.x - space2
        }
        
        if w3r.position.y <= bottomremoving && w2r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
            w3r.position.y = (w2r.position.y + wallbottomupspace)
            w3l.position.y = (w2l.position.y + wallbottomupspace)
            w3r.position.x = CGFloat(randomNum)
            w3l.position.x = w3r.position.x - space3
        }
        
        if w4r.position.y <= bottomremoving && w2r.position.y <= topplacing{
            randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
            if (!modechanges){
                w4r.position.y = (w3r.position.y + wallbottomupspace)
                w4l.position.y = (w3l.position.y + wallbottomupspace)
                w4r.position.x = CGFloat(randomNum)
                w4l.position.x = w4r.position.x - space4
            }
        }
        scorefunc()
    }
    
    //Bewegt die Wände in selbst definierbaren Temo nach unten.
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
    
    //Bewegt die Wände seitwärts
    func walls(){
        if w1r.position.x <= CGFloat(borderMin){
            links1 = true
        }else if w1r.position.x >= CGFloat(borderMax-1){
            links1 = false
        }
        if w2r.position.x <= CGFloat(borderMin){
            links2 = true
        }else if w2r.position.x >= CGFloat(borderMax-1){
            links2 = false
        }
        if w3r.position.x <= CGFloat(borderMin){
            links3 = true
        }else if w3r.position.x >= CGFloat(borderMax-1){
            links3 = false
        }
        if w4r.position.x <= CGFloat(borderMin){
            links4 = true
        }else if w4r.position.x >= CGFloat(borderMax-1){
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
    
    //Aktualisiert den Score und allenfalls den Highscore
    func scorefunc(){
        scoreabstand = walldownspeed / 2
        if (w1r.position.y - figurypos <= scoreabstand && w1r.position.y - figurypos >= -scoreabstand) || (w2r.position.y - figurypos <= scoreabstand && w2r.position.y - figurypos >= -scoreabstand) || (w3r.position.y - figurypos <= scoreabstand && w3r.position.y - figurypos >= -scoreabstand) || (w4r.position.y - figurypos <= scoreabstand && w4r.position.y - figurypos >= -scoreabstand) {
            GameScene.score += 1
            numberscore.text = String(GameScene.score)
            if GameScene.score >= GameScene.highscore {
                GameScene.highscore = GameScene.score
                numberhighscore.text = String(GameScene.highscore)
            }
        }
    }
    
    /*
     Sorgt dafür, dass alle Wände neu von oben kommen (Vewendet bei einem Wechsel der Steuerung)
     Wurde übersichthalber und für spätere allfällige Verwendungen in zwei verschiedene Methoden ausgelagert
     */
    func modechange_placing(){
        modechange_placing_Breite()
        modechange_placing_Hoehe()
    }
    
    //Setzt die Wände an einer zufälligen X-Position die im Screen liegt
    func modechange_placing_Breite(){
        randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w1r.position.x = CGFloat(randomNum)
        w1l.position.x = w1r.position.x - space1
        randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w2r.position.x = CGFloat(randomNum)
        w2l.position.x = w2r.position.x - space2
        randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w3r.position.x = CGFloat(randomNum)
        w3l.position.x = w3r.position.x - space3
        randomNum = integer_t(Int(arc4random_uniform(UInt32(borderMax) - UInt32(borderMin)) + UInt32(borderMin)))
        w4r.position.x = CGFloat(randomNum)
        w4l.position.x = w4r.position.x - space4
    }
    
    //Setzt die Wände im richtigen Höhen-Abstand zueinander
    func modechange_placing_Hoehe(){
        w1r.position.y = topplacing
        w1l.position.y = topplacing
        w2r.position.y = w1r.position.y + wallbottomupspace
        w2l.position.y = w1r.position.y + wallbottomupspace
        w3r.position.y = w2r.position.y + wallbottomupspace
        w3l.position.y = w2r.position.y + wallbottomupspace
        w4r.position.y = w3r.position.y + wallbottomupspace
        w4l.position.y = w3r.position.y + wallbottomupspace
    }
    
    /*
     Main Funktion. Wird bei jedem Frame aufgerufen.
     Regelt die verschiedenen "Levels" und Arten der Steuerungen
     Sehr komplizierte Methode; Übergänge zwischen den Steuerungs-Arten müssen mit sehr vielen Abfregen korrekt in die Wege geleitet werden.
     Hat für obig beschriebenen Prozess auch sehr viele Sub-Methoden.
     */
    override func update(_ currentTime: TimeInterval) {
        if game_paused{
        }else {
            if game_over {
                if let scene = GameOverScene(fileNamed: "GameOverScene") {
                    scene.scaleMode = .aspectFill
                    view?.presentScene(scene)
                }
            }else{
                if firstgamec{
                    firstgame()
                }else{
                    if (!modechanges && !gyroAUS && GameScene.score % 15 == 0 && GameScene.score % 30 != 0) {
                        modechanges = true
                        scoresafe = GameScene.score
                    }
                    if (modechanges && GameScene.score == scoresafe + 14){
                        scoresafe = -20
                        modechanges = false
                        changed = true
                    }
                    if (modechanges) {
                        if (w1r.position.y <= bottomremoving && w2r.position.y <= bottomremoving && w3r.position.y <= bottomremoving && w4r.position.y <= bottomremoving) {
                            gyro = true
                            scene?.backgroundColor = SKColor.darkGray
                            scorefunc()
                            borderMin = 300
                            walldownspeed = 11
                            wallbottomupspace = 1000
                            wallleftrightspace = 1000
                            setSpaces(abstand: wallleftrightspace)
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
                                borderMin = 200
                                walldownspeed = 10
                                wallbottomupspace = 320
                                wallleftrightspace = 940
                                setSpaces(abstand: wallleftrightspace)
                                modechange_placing()
                                changed = false
                                gyro = false
                                scene?.backgroundColor = SKColor.black
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
