//
//  Enemy.swift
//  PixelPunch
//
//  Created by Patrick Beaumont on 02/07/2016.
//  Copyright © 2016 Patrick Beaumont. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy:SKSpriteNode{
    
    var hitFrames : [SKTexture] = []
    var idleFrames : [SKTexture] = []
    var normalPunchFrames : [SKTexture] = []
    
    func getIdle() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(idleFrames, timePerFrame: 0.15, resize: true, restore: true))
    }
    
    func performAttack(player:Player, currentMove:Move, spot:SKSpriteNode, gameScene:GameScene){
        //we want the enemy to move to the player and perform an attack
        let target=player.position
        //convert target to a coordinate we need to stand before launching uppercut
        var moveToTarget:CGPoint
        if player.position.x > target.x{
            moveToTarget=CGPoint(x:target.x-120,y:target.y)
        }else{
            moveToTarget=CGPoint(x:target.x+120,y:target.y)
        }

        if(self.position.x > moveToTarget.x){
            self.xScale=CGFloat(-2);
        }else{
            self.xScale=2;
        }
        
        spot.hidden=false
        spot.position=player.position
        
        //run to target then trigger animation
        let action0=SKAction.moveTo(moveToTarget, duration: currentMove.duration)
        self.runAction(action0,completion: {
            //do we need to turn around?
            if(self.position.x > target.x){
                self.xScale=CGFloat(-2);
            }else{
                self.xScale=2;
            }
            //launch uppercut animation
            let animation=SKAction.animateWithTextures(self.normalPunchFrames, timePerFrame: 0.1, resize: true, restore: false)
            self.runAction(animation)
            //trigger fall back movement for sketch
            player.block()
            //trigger movement sequence for uppercut
            let action1=SKAction.moveBy(CGVectorMake(CGFloat(40)*self.xScale, CGFloat(0)), duration: 0.8)
            self.runAction(action1,completion:{
                let action3=self.getIdle()
                gameScene.performMove()
                self.runAction(action3)
            })
            
        })
    }
    
    func respondToDamage(){
        self.removeAllActions()
        let action0=SKAction.moveBy(CGVectorMake(CGFloat(-1)*self.xScale, CGFloat(0)), duration: 0.3)
        let action1=SKAction.moveBy(CGVectorMake(CGFloat(-40)*self.xScale, CGFloat(10)), duration: 0.4)
        let action2=SKAction.moveBy(CGVectorMake(CGFloat(-10)*self.xScale,CGFloat(-10)), duration: 0.25)
        let actions=[action0,action1,action2]
        let sequence = SKAction.sequence(actions)
        self.runAction(sequence)
        let hitAction=SKAction.animateWithTextures(hitFrames, timePerFrame: 0.2)
        let hitAction2=SKAction.waitForDuration(1)
        let sequence2=SKAction.sequence([hitAction,hitAction2])
        self.runAction(sequence2,completion: {
            self.runAction(self.getIdle())
        })
    }
}