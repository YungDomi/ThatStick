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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        for _ in touches{
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
        }
    }
}
