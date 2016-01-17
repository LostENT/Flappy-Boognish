//
//  GameScene.swift
//  Flappy Boognish
//
//  Created by Nicholas Dauchot on 1/15/16.
//  Copyright (c) 2016 blackhat. All rights reserved.
//

import SpriteKit


struct PhysicsCatagory {
    
    static let Boognish : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
    static let LeftWall : UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var boognish = SKSpriteNode()
    var background = SKSpriteNode()
    var ground = SKSpriteNode()
    var leftWall = SKSpriteNode()
    var rightWall = SKNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var scoreNodeTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    var ScoreMoveAndRemove = SKAction()
    var score = Int()
    
    
    let scoreLbl = SKLabelNode()
   
    
    
    var died = Bool()
    var guavaVisible = Bool()
    var gameStared = Bool()
    var restartBTN = SKSpriteNode()
   
    
    let pipeGap = 150.0
    
    
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died=false
        gameStared = true
        score = 0
        createScene()
    }
    
    func createScene(){
        
        
        /* Setup your scene here */
        
        //score Label
        
        scoreLbl.position = CGPoint (x: self.frame.width / 2 , y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        self.addChild(scoreLbl)
        scoreLbl.zPosition = -1
        
        // Background
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPointMake(self.size.width/2, self.size.height/2)
        addChild(background)
        background.zPosition = -11
        
        // Repeat Background Image Forever
        
        
        //loop background image infinitely
        
        func moveForeverAction() {
            let moveNode = SKAction.moveByX(0, y: background.size.height * 2.0 , duration: NSTimeInterval(0.01 * background.size.height * 2.0))
            let resetPosition = SKAction.moveByX(0, y:  background.size.height * 2.0, duration: 0)
            let moveNodeForever = SKAction.repeatActionForever(SKAction.sequence([moveNode, resetPosition]))
            background.runAction(moveNodeForever)
        }
        
        
        //Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        
        //Boognish
        var BoognishTexture = SKTexture(imageNamed:"boog")
        BoognishTexture.filteringMode = SKTextureFilteringMode.Nearest
        
        boognish = SKSpriteNode(texture: BoognishTexture)
        boognish.setScale(0.5)
        boognish.position = CGPoint(x: self.frame.size.width * 0.50, y: self.frame.size.height * 0.6)
        
        boognish.physicsBody = SKPhysicsBody(circleOfRadius: boognish.size.height / 2)
        boognish.physicsBody?.categoryBitMask = PhysicsCatagory.Boognish
        boognish.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Wall
        boognish.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        boognish.physicsBody!.dynamic = true
        boognish.physicsBody!.allowsRotation = false
        
        self.addChild(boognish)
        
        //Ground
        
        self.physicsWorld.contactDelegate = self
        
        ground = SKSpriteNode (imageNamed: "ground")
        ground.setScale(2.0)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCatagory.Boognish
        ground.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.dynamic = false
        
        ground.zPosition = 3
        
        self.addChild(ground)
        
        //Wall
        leftWall = SKSpriteNode (imageNamed: "wall2")
        leftWall.setScale(5.0)
        leftWall.position = CGPoint(x: 0, y: 0)
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: leftWall.size)
        leftWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        leftWall.physicsBody?.collisionBitMask = PhysicsCatagory.Boognish
        leftWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        leftWall.physicsBody?.affectedByGravity = false
        leftWall.physicsBody?.dynamic = false
        
        leftWall.zPosition = 50
        
        
        
        
        
        //Pipes
        
        //Create the Pipes
        
        pipeUpTexture = SKTexture(imageNamed: "PipeUp")
        pipeDownTexture = SKTexture(imageNamed: "PipeDown")
        scoreNodeTexture = SKTexture(imageNamed: "guava")
        
        
        
        // movement of pipes
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        
        
        // movement of guavas
        let scoreToMove = CGFloat(self.frame.size.width + 2.0 * scoreNodeTexture.size().width)
        let moveScore = SKAction.moveByX(-distanceToMove, y: 4.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removeScore = SKAction.removeFromParent()
        
        
        ScoreMoveAndRemove = SKAction.sequence([moveScore,removeScore])
        
        PipesMoveAndRemove = SKAction.sequence([movePipes,removePipes])
        
        //Spawn Pipes
        
        let spawn =  SKAction.runBlock({() in self.spawnPipes()})
        let delay = SKAction.waitForDuration(NSTimeInterval(2.0))
        let spawnThenDelay = SKAction .sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        self.runAction(spawnThenDelayForever)
        
    }
    
    override func didMoveToView(view: SKView) {
        
createScene()
        
    }
    
    func createBTN(){
        
        restartBTN = SKSpriteNode(color: SKColor.blueColor(), size: CGSize(width: 200, height: 100))
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        self.addChild(restartBTN)
        
    }
    func spawnPipes(){
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        
        pipePair.zPosition = -10
        
        let height = UInt32(self.frame.size.height / 4)
        let y = arc4random() % height + height
        
        let pipeDown = SKSpriteNode(texture: pipeDownTexture)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPointMake(0.0, CGFloat(y) + pipeDown.size.height + CGFloat(pipeGap))
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOfSize:pipeDown.size)
        pipeDown.physicsBody!.dynamic = false
        pipeDown.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        pipeDown.physicsBody?.collisionBitMask = 1
        pipeDown.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeUpTexture)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPointMake(0.0, CGFloat(y))
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOfSize: pipeUp.size)
        pipeUp.physicsBody!.dynamic = false
        pipeUp.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        pipeUp.physicsBody?.collisionBitMask = 1
        pipeUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        pipePair.addChild(pipeUp)
        
        
        pipePair.runAction(PipesMoveAndRemove)
        
        
        self.addChild(pipePair)
        
        let scoreNode =  SKSpriteNode(texture: scoreNodeTexture)
        
        scoreNode.position = CGPointMake(0.0, CGFloat(y) + scoreNode.size.height + CGFloat(pipeGap))
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 1
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        
        scoreNode.runAction(ScoreMoveAndRemove)
        pipePair.addChild(scoreNode)
        
    }
    

    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        
        if firstBody.categoryBitMask == PhysicsCatagory.Score &&  secondBody.categoryBitMask == PhysicsCatagory.Boognish || firstBody.categoryBitMask == PhysicsCatagory.Boognish &&  secondBody.categoryBitMask == PhysicsCatagory.Score{
            
            score++
            scoreLbl.text = "\(score)"

          
            
        }
        
        if firstBody.categoryBitMask == PhysicsCatagory.Boognish && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Boognish {
            
            died = true
            
            createBTN()
            
        }
    }

        
        
    
       override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            boognish.physicsBody?.velocity = CGVectorMake(0, 0)
            boognish.physicsBody?.applyImpulse(CGVectorMake(0,25))
            
            if died == true {
                boognish.physicsBody?.velocity = CGVectorMake(0, 0)
                boognish.physicsBody?.applyImpulse(CGVectorMake(0,0))
            }
           
    
        }
        for touch in touches {
            let location = touch.locationInNode(self)
            
            
            if died == true {
                
                if restartBTN.containsPoint(location){
                restartScene()
                }
                
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
