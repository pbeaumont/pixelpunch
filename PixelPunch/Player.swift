//
//  Player.swift
//  PixelPunch
//
//  Created by Patrick Beaumont on 28/07/2016.
//  Copyright © 2016 Patrick Beaumont. All rights reserved.
//

import Foundation
//
//  Enemy.swift
//  PixelPunch
//
//  Created by Patrick Beaumont on 02/07/2016.
//  Copyright © 2016 Patrick Beaumont. All rights reserved.
//

import Foundation
import SpriteKit

class Player:SKSpriteNode{
    struct Constants{
        static let movementSpeed = Float(550)
    }
    
    var blockFrames : [SKTexture] = []
    var hitFrames : [SKTexture] = []
    var idleFrames : [SKTexture] = []
    var arrow : SKSpriteNode!
    
    func block(){
        self.runAction(SKAction.animateWithTextures(self.blockFrames, timePerFrame: 0.2))
        let saction0=SKAction.moveBy(CGVectorMake(CGFloat(-1)*self.xScale, CGFloat(0)), duration: 0.3)
        let saction1=SKAction.moveBy(CGVectorMake(CGFloat(-40)*self.xScale, CGFloat(10)), duration: 0.4)
        let saction2=SKAction.moveBy(CGVectorMake(CGFloat(-10)*self.xScale,CGFloat(-10)), duration: 0.25)
        let sactions=[saction0,saction1,saction2]
        let sequence = SKAction.sequence(sactions)
        self.runAction(sequence)
    }
    
    func getIdle() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(idleFrames, timePerFrame: 0.15, resize: true, restore: true))
    }
    
    func idle() {
        self.runAction( getIdle(), withKey:"sketchMovement")
    }
    
    func performAttack(enemy:Enemy, attackToPerform:[SKTexture]) {
        arrow.hidden=true
        let target=enemy.position
        //convert target to a coordinate we need to stand before launching uppercut
        var moveToTarget:CGPoint
        if self.position.x > target.x{
            moveToTarget=CGPoint(x:target.x+120,y:target.y)
        }else{
            moveToTarget=CGPoint(x:target.x-120,y:target.y)
        }
        
        if(self.position.x > moveToTarget.x){
            self.xScale=CGFloat(-2);
        }else{
            self.xScale=2;
        }
        
        //calculate what the correct duration is
        let distance=SDistanceBetweenPoints(self.position, second: moveToTarget)
        let duration=distance/Constants.movementSpeed;
        
        //run to target then trigger animation
        let action0=SKAction.moveTo(moveToTarget, duration: Double(duration))
        self.runAction(action0,completion: {
            //do we need to turn around?
            if(self.position.x > target.x){
                self.xScale=CGFloat(-2);
            }else{
                self.xScale=2;
            }
            //launch attack animation
            let animation=SKAction.animateWithTextures(attackToPerform, timePerFrame: 0.1, resize: true, restore: false)
            enemy.respondToDamage()
            self.runAction(animation)
            //trigger movement sequence for uppercut
            let action1=SKAction.moveBy(CGVectorMake(CGFloat(40)*self.xScale, CGFloat(0)), duration: 0.8)
            self.runAction(action1,completion:{
                let action3=self.getIdle()
                self.runAction(action3)
            })
            
        })
    }
    
    func SDistanceBetweenPoints(first: CGPoint, second: CGPoint) -> Float {
        return hypotf(Float(second.x - first.x), Float(second.y - first.y));
    }
}