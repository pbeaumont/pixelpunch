//
//  GameScene.swift
//  PixelPunch
//
//  Created by Patrick Beaumont on 20/06/2016.
//  Copyright (c) 2016 Patrick Beaumont. All rights reserved.
//

import Darwin
import SpriteKit

struct Move {
    var angle:CGFloat = 0.0
    var duration:Double = 0.0
    var delay:Double = 0.0
    var enemy:Bool = false
}

class GameScene: SKScene {
    
    struct Constants{
        static let horizontalWeighting = 100
        static let verticalWeighting = 100
        static let movementSpeed = Float(550)
    }
    
    var firstLocation = CGPoint()
    var gravisIdleFrames : [SKTexture]!
    var sketch : Player!
    var sketchBlockFrames : [SKTexture]!
    var sketchHitFrames : [SKTexture]!
    var sketchIdleFrames : [SKTexture]!
    var sketchUppercutFrames : [SKTexture]!
    var sketchRollingThunderFrames : [SKTexture]!
    var sketchNormalPunchFrames : [SKTexture]!
    var enemies = [Enemy]()
    var moves = [Move]()
    var moveCount:Int = 0
    var arrow : SKSpriteNode!
    var spot : SKSpriteNode!
    var currentMove : Move!

    
    override func didMoveToView(view: SKView) {
        //Load the TextureAtlas for idle animation
        let sketchIdleAtlas : SKTextureAtlas = SKTextureAtlas(named: "sketchidle")
        
        //Load the animation frames from the TextureAtlas
        var walkFrames = [SKTexture]()
        let numImages : Int = sketchIdleAtlas.textureNames.count
        for i in 0..<numImages {
            let bearTextureName = "sketch\(i)"
            walkFrames.append(sketchIdleAtlas.textureNamed(bearTextureName))
        }
        sketchIdleFrames = walkFrames
        
        let sketchUppercutAtlas : SKTextureAtlas = SKTextureAtlas(named: "sketchuppercut");
        sketchUppercutFrames = [SKTexture]()
        let numUpperImages : Int = sketchUppercutAtlas.textureNames.count
        for i in 0..<numUpperImages {
            let textureName = "sketch\(i)"
            sketchUppercutFrames.append(sketchUppercutAtlas.textureNamed(textureName))
        }
        
        let sketchRollingThunderAtlas : SKTextureAtlas = SKTextureAtlas(named: "sketchrollingThunder")
        sketchRollingThunderFrames = [SKTexture]()
        let numThunderImages : Int = sketchRollingThunderAtlas.textureNames.count
        for i in 0..<numThunderImages {
            let textureName = "sketch\(i)"
            sketchRollingThunderFrames.append(sketchRollingThunderAtlas.textureNamed(textureName))
        }
        
        let sketchNormalPunchAtlas : SKTextureAtlas = SKTextureAtlas(named:"sketchnormalpunch")
        sketchNormalPunchFrames=[SKTexture]()
        let numNormalImages : Int = sketchNormalPunchAtlas.textureNames.count
        for i in 0..<numNormalImages {
            let textureName = "sketch\(i)"
            sketchNormalPunchFrames.append(sketchNormalPunchAtlas.textureNamed(textureName))
        }
        
        let sketchBlockAtlas : SKTextureAtlas = SKTextureAtlas(named:"sketchblock")
        sketchBlockFrames=[SKTexture]()
        let numBlockImages : Int = sketchBlockAtlas.textureNames.count
        for i in 0..<numBlockImages{
            let textureName="sketch\(i)"
            sketchBlockFrames.append(sketchBlockAtlas.textureNamed(textureName))
        }
        
        let sketchHitAtlas : SKTextureAtlas = SKTextureAtlas(named:"sketchhit")
        sketchHitFrames=[SKTexture]()
        let numHitImages : Int = sketchHitAtlas.textureNames.count
        for i in 0..<numHitImages{
            let textureName="sketch\(i)"
            sketchHitFrames.append(sketchHitAtlas.textureNamed(textureName))
        }
        
        let gravisIdleAtlas : SKTextureAtlas = SKTextureAtlas(named:"gravisidle")
        gravisIdleFrames=[SKTexture]()
        let numGravisIdle : Int = gravisIdleAtlas.textureNames.count
        for i in 0..<numGravisIdle{
            let textureName="gravis\(i)"
            gravisIdleFrames.append(gravisIdleAtlas.textureNamed(textureName))
        }
        
        sketch = Player(texture:sketchIdleFrames[0])
        sketch.blockFrames=sketchBlockFrames
        sketch.idleFrames=sketchIdleFrames
        addChild(sketch)
        sketch.position=CGPoint(x: 200, y: 300)
        sketch.idle()
        sketch.yScale=CGFloat(2.5);
        sketch.xScale=CGFloat(2.5);
        
        //create an enemy
        let enemy=Enemy(texture:gravisIdleFrames[0])
        enemy.idleFrames=gravisIdleFrames
        enemy.hitFrames=sketchHitFrames
        enemy.normalPunchFrames=sketchNormalPunchFrames
        enemy.xScale = -2.5;
        enemy.yScale=2.5;
        addChild(enemy)
        enemy.position=CGPoint(x: 500, y: 300)
        enemies.append(enemy)
        enemy.runAction(enemy.getIdle())
        
        //add music
        let music = SKAudioNode(fileNamed: "allYourBase.mp3")
        music.autoplayLooped=true
        music.positional=false
        addChild(music)
        
        let move1=Move(angle: CGFloat(M_PI_4), duration: 1.2, delay: 7.2, enemy: false)
        moves.append(move1)
        
        let move2=Move(angle: CGFloat(M_PI_2), duration: 1.2, delay: 0, enemy: false)
        moves.append(move2)
        
        let move3=Move(angle:CGFloat(M_PI),duration:1.2,delay:0, enemy: false)
        moves.append(move3)
        
        let move5=Move(angle:CGFloat(M_PI+M_PI_2+M_PI_4),duration:3,delay:0,enemy: false)
        moves.append(move5)
        
        let move6=Move(angle:CGFloat(M_PI),duration:0.75,delay:1,enemy:true)
        moves.append(move6)
        
        let move7=Move(angle:CGFloat(M_PI),duration:0.5,delay:1,enemy:true)
        moves.append(move7)
        
        let move8=Move(angle:CGFloat(M_PI),duration:0.5,delay:1,enemy:true)
        moves.append(move8)
        
        let move4=Move(angle:CGFloat(M_PI_4), duration:1.2,delay:0, enemy: false)
        moves.append(move4) 
        
        arrow=SKSpriteNode(imageNamed: "arrow")
        arrow.position=CGPoint(x:600,y:400)
        arrow.hidden=true
        arrow.zPosition=2;
        addChild(arrow)
        sketch.arrow=arrow;
        
        spot=SKSpriteNode(imageNamed:"spot")
        spot.hidden=true
        spot.zPosition=2;
        spot.xScale=0.125;
        spot.yScale=0.125;
        addChild(spot)
        
        performMove()
    }
    
    func performMove(){
        //check to see we have moves left
        if moveCount >= moves.count{
            print("finished moves list")
            return
        }
        
        currentMove=moves[moveCount];
        moveCount += 1
        if currentMove.enemy{
            //get the enemy to do an action
            enemies[0].performAttack(sketch,currentMove: currentMove,spot:spot,gameScene:self)
        }else{
            //just move the arrow around
            let rotateAction=SKAction.rotateToAngle(currentMove.angle, duration: currentMove.delay)
            let moveAction=SKAction.moveTo(enemies[0].position, duration: 0)
            let unhideAction=SKAction.unhide()
            let waitAction=SKAction.waitForDuration(currentMove.duration)
            let hideAction=SKAction.hide()
            arrow.runAction(SKAction.sequence([moveAction,rotateAction,unhideAction,waitAction,hideAction]), completion: {
                self.performMove()
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            self.firstLocation=location;
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*print("moved")
        print(touches.count)*/
    }
    
    func SDistanceBetweenPoints(first: CGPoint, second: CGPoint) -> Float {
        return hypotf(Float(second.x - first.x), Float(second.y - first.y));
    }
    
    func getNearest(location:CGPoint, nodes:[Enemy]) -> Enemy!{
        var nearest:Enemy!
        var nearestDistance:Float=Float(9999999);
        for node in nodes{
            let distance=SDistanceBetweenPoints(location, second: node.position);
            if distance<nearestDistance{
                nearest=node;
                nearestDistance=distance;
            }
        }
        return nearest
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //touches.count indicates how many fingers where on screen
        if touches.count > 0 {
            var lastLocation = CGPoint()
            for touch in touches{
                lastLocation=touch.locationInNode(self)
            }
            print(firstLocation)
            print(lastLocation)
            let firstLocationY=Int(firstLocation.y)
            let lastLocationY=Int(lastLocation.y)
            let firstLocationX=Int(firstLocation.x)
            let lastLocationX=Int(lastLocation.x)
            //get compass direction of swipe
            if lastLocationX > (firstLocationX+Constants.horizontalWeighting) {
                //we are heading east
                if lastLocationY < (firstLocationY-Constants.verticalWeighting) {
                    print("SOUTH EAST")
                    if(currentMove.angle==CGFloat(M_PI+M_PI_2+M_PI_4)){
                        //use starting point of stroke to locate enemy
                        let enemyToHit=getNearest(firstLocation,nodes: enemies)
                        if((enemyToHit) != nil){
                            sketch.performAttack(enemyToHit,attackToPerform: self.sketchRollingThunderFrames)
                        }
                    }
                }else if lastLocationY > (firstLocationY+Constants.verticalWeighting) {
                    print("NORTH EAST")
                    //does this match the currentMove
                    if(currentMove.angle==CGFloat(M_PI_4)){
                        //use starting point of stroke to locate enemy
                        let enemyToHit=getNearest(firstLocation,nodes: enemies)
                        if((enemyToHit) != nil){
                            sketch.performAttack(enemyToHit,attackToPerform: self.sketchUppercutFrames)
                        }
                    }
                }else{
                    print("EAST")
                }
            } else if lastLocationX < (firstLocationX-Constants.horizontalWeighting) {
                //we are heading west
                if lastLocationY < (firstLocationY-Constants.verticalWeighting) {
                    print("SOUTH WEST")
                }else if lastLocationY > (firstLocationY+Constants.verticalWeighting) {
                    print("NORTH WEST")
                }else{
                    print("WEST")
                    if(currentMove.angle==CGFloat(M_PI)){
                        let enemyToHit=getNearest(firstLocation,nodes: enemies)
                        if((enemyToHit) != nil){
                            sketch.performAttack(enemyToHit,attackToPerform: self.sketchUppercutFrames)
                        }
                    }
                }
            }else{
                //no horizontal movement, just check for vertical
                if lastLocationY < (firstLocationY-Constants.verticalWeighting) {
                    print("SOUTH")
                }else if lastLocationY > (firstLocationY+Constants.verticalWeighting) {
                    print("NORTH")
                    if(currentMove.angle==CGFloat(M_PI_2)){
                        let enemyToHit=getNearest(firstLocation,nodes: enemies)
                        if((enemyToHit) != nil){
                            sketch.performAttack(enemyToHit,attackToPerform: self.sketchUppercutFrames)
                        }
                    }
                }else{
                    print("TAP")
                    if(currentMove.enemy==true){
                        //initiate a block
                        spot.hidden=true
                    }else{
                        sketch.removeAllActions()
                        let distance=SDistanceBetweenPoints(sketch.position, second: lastLocation)
                        let duration=distance/Constants.movementSpeed;
                        sketch.runAction(SKAction.moveTo(lastLocation, duration: Double(duration)), completion: {
                            self.sketch.idle()
                        })
                    }
                }
            }
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
