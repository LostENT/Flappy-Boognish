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
    static let Guava : UInt32 = 0x1 << 4
    static let Pepper: UInt32 = 0x1 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var boognish = SKSpriteNode()
    var background = SKSpriteNode()
    var ground = SKSpriteNode()
    var leftWall = SKSpriteNode()
    var rightWall = SKNode()
    var pipeUpTexture = SKTexture()
    var pipeDownTexture = SKTexture()
    var guavaNodeTexture = SKTexture()
    var pepperNodeTexture = SKTexture()
    var PipesMoveAndRemove = SKAction()
    var GuavaMoveAndRemove = SKAction()
    var PepperMoveAndRemove = SKAction()
    var score = Int()
    var highScore = Int()
    var savedScore = Int()

    var scoreIncreased = Bool()
    var guavaVisible = Bool()
    
    let scoreLbl = SKLabelNode()
    let highScoreLbl = SKLabelNode()
    
    
    var died = Bool()
    var gameStared = Bool()
    
    var restartBTN = SKSpriteNode()
    var stallion = SKSpriteNode()
    var weasel = SKSpriteNode()
    var roach = SKSpriteNode()
    var boognishRising = SKSpriteNode()
   
    
    let pipeGap = 170.0
    
    
    //What happens when the score increases
    
    func scoreDidIncrease() {
        
        score++
        scoreLbl.text = "\(score)"
        scoreIncreased = true
        
        
    }
    
    

    
    //What happens when the game starts
    
    func createScene(){
        
        
        /* Setup your scene here */
        
      
        //score Label
        
        scoreLbl.position = CGPoint (x: self.frame.width / 2 , y: self.frame.height / 3 + self.frame.height / 2)
        scoreLbl.text = "\(score)"
        scoreLbl.fontColor = UIColor.brownColor()
        self.addChild(scoreLbl)
        scoreLbl.fontSize = 100
        scoreLbl.zPosition = -10
       
        //high score label
        NSUserDefaults.standardUserDefaults().setInteger(highScore, forKey: "Highscore")
        highScoreLbl.position = CGPoint (x: self.frame.width / 1.65 , y: self.frame.height / 20 + self.frame.height / 5)
        highScoreLbl.text = "high score \(highScore)"
        self.addChild(highScoreLbl)
        highScoreLbl.fontColor = UIColor.brownColor()
        highScoreLbl.fontSize = 30
        highScoreLbl.zPosition = 5
        
        highScoreLbl.zPosition = 10
        
        
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
        
        // BACKGROUND SPRITES
        
        func callBackground(){

        
        var stallionTexture = SKTexture(imageNamed: "stallion")
        var weaselTexture = SKTexture(imageNamed: "weasel")
        var boognishRisingTexture = SKTexture(imageNamed: "boognishRising")
        var roachTexture = SKTexture(imageNamed: "cockroach")
        
            
            
             // Sprites called
         
            if highScore > 20 {
                roach = SKSpriteNode (texture: roachTexture)
                roach.position = CGPoint(x: self.frame.size.width / 1.85, y: self.frame.size.height / 1.96 )
                roach.zPosition = -2
                roach.alpha = 0.65
                roach.setScale(0.60)
                
                addChild(roach)
                
            }
           
            if highScore > 40 {
                    weasel = SKSpriteNode (texture: weaselTexture)
                    weasel.position = CGPoint(x: self.frame.size.width / 1.67, y: self.frame.size.height / 2.5)
                    weasel.zPosition = -2
                    weasel.alpha = 0.2
                    weasel.setScale(0.45)
                
                    addChild(weasel)
                
            }
            if highScore > 60 {
                
                stallion = SKSpriteNode (texture: stallionTexture)
                stallion.position = CGPoint(x: self.frame.size.width * 0.398, y: self.frame.size.height * 0.45)
                stallion.zPosition = -1
                stallion.alpha = 0.15
                
                
                addChild(stallion)
            }
           
            
            if highScore > 80 {
                boognishRising = SKSpriteNode (texture: boognishRisingTexture)
                boognishRising.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 1.25)
                boognishRising.zPosition = -2
                boognishRising.alpha = 0.2
                boognishRising.setScale(0.70)
                
                addChild(boognishRising)
                
            }
            
        }
            
            
            
        
        
        callBackground()
        
       
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
        boognish.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Guava
        boognish.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Pepper
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
        
        /*Wall
        leftWall = SKSpriteNode (imageNamed: "wall2")
        leftWall.setScale(2.0)
        leftWall.position = CGPointMake(self.size.width, self.size.height)
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOfSize: leftWall.size)
        leftWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        leftWall.physicsBody?.collisionBitMask = PhysicsCatagory.Boognish
        leftWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        leftWall.physicsBody?.affectedByGravity = false
        leftWall.physicsBody?.dynamic = false
        
        leftWall.zPosition = 20
        self.addChild(leftWall)
        */
        
        
        //Pipes
        
        //Create the Pipes
        
        pipeUpTexture = SKTexture(imageNamed: "PipeUp")
        pipeDownTexture = SKTexture(imageNamed: "PipeDown")
        
        //Create the Guava
        guavaNodeTexture = SKTexture(imageNamed: "guava")
        pepperNodeTexture = SKTexture(imageNamed: "pepper")
        
        
        
        // movement of pipes
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeUpTexture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        
        
        // movement of guavas
        let guavaToMove = CGFloat(self.frame.size.width + 2.0  * guavaNodeTexture.size().width)
        let moveGuava = SKAction.moveByX(-guavaToMove, y: self.frame.size.width, duration: NSTimeInterval(0.01 * guavaToMove))
        let removeGuava = SKAction.removeFromParent()
        
        // movement of peppers
        let pepperToMove = CGFloat(self.frame.size.width + 2.0  * pepperNodeTexture.size().width)
        let movePepper = SKAction.moveByX(-pepperToMove, y: self.frame.size.height / -1, duration: NSTimeInterval(0.01 * pepperToMove))
        let removePepper = SKAction.removeFromParent()
        
        GuavaMoveAndRemove = SKAction.sequence([moveGuava,removeGuava])
        
        PepperMoveAndRemove = SKAction.sequence([movePepper,removePepper])
        
        PipesMoveAndRemove = SKAction.sequence([movePipes,removePipes])
        
        //Spawn Pipes
        
        let spawnP =  SKAction.runBlock({() in self.spawnPipes()})
        let spawnG =  SKAction.runBlock({() in self.spawnGuava()})
        let spawnPep =  SKAction.runBlock({() in self.spawnPepper()})
        
        let delayP = SKAction.waitForDuration(NSTimeInterval(2.0))
        let delayG = SKAction.waitForDuration(NSTimeInterval(4.0))
        let delayPep = SKAction.waitForDuration(NSTimeInterval(4.0))
        
        let spawnPThenDelay = SKAction .sequence([spawnP,delayP])
        let spawnPThenDelayForever = SKAction.repeatActionForever(spawnPThenDelay)
        
        
        let spawnGThenDelay = SKAction .sequence([spawnG,delayG])
        let spawnGThenDelayForever = SKAction.repeatActionForever(spawnGThenDelay)
        
        let spawnPepThenDelay = SKAction .sequence([spawnPep,delayPep])
        let spawnPepThenDelayForever = SKAction.repeatActionForever(spawnPepThenDelay)
        
        self.runAction(spawnPThenDelayForever)
        self.runAction(spawnGThenDelayForever)
        self.runAction(spawnPepThenDelayForever)
        
    }
    
    override func didMoveToView(view: SKView) {
        
createScene()
        
    }
    

    
    //What happens when Boognish and Guava collide
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        
        if firstBody.categoryBitMask == PhysicsCatagory.Guava &&  secondBody.categoryBitMask == PhysicsCatagory.Boognish || firstBody.categoryBitMask == PhysicsCatagory.Boognish &&  secondBody.categoryBitMask == PhysicsCatagory.Guava{
            
            scoreDidIncrease()
            
            scoreIncreased = true
            
            
        }
        
        if firstBody.categoryBitMask == PhysicsCatagory.Boognish && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Boognish {
            
            died = true
            
            createBTN()
            
        }
    }
    func spawnPepper(){
        
        //The way the Guava spawn and move
        
        let pepperNode = SKNode()
        
        let pepper = SKSpriteNode(texture: pepperNodeTexture)
        
        pepper.setScale(0.30)
        pepper.position = CGPointMake (self.size.width + 160, self.size.height * 1.20)
        pepper.alpha = 0.75
        pepper.physicsBody = SKPhysicsBody(rectangleOfSize: pepper.size)
        pepper.physicsBody?.affectedByGravity = false
        pepper.physicsBody?.dynamic = true
        pepper.physicsBody?.categoryBitMask = PhysicsCatagory.Guava
        pepper.physicsBody?.collisionBitMask = 1
        pepper.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        
        pepper.zPosition = 0
        
        pepperNode.addChild(pepper)
        
        
        pepper.runAction(PepperMoveAndRemove)
        
        self.addChild(pepperNode)
        
        
        if scoreIncreased == true {
            
            
        }
        
        
        
        //the way the guava collide
        
    }

    
    func spawnGuava(){
        
        //The way the Guava spawn and move
        
        let guavaNode = SKNode()
        
        let guava = SKSpriteNode(texture: guavaNodeTexture)
    
        guava.setScale(0.75)
        guava.position = CGPointMake (self.size.width - 40, self.size.height * 0.05)
        guava.physicsBody = SKPhysicsBody(rectangleOfSize: guava.size)
        guava.physicsBody?.affectedByGravity = false
        guava.physicsBody?.dynamic = true
        guava.alpha = 0.75
        guava.physicsBody?.categoryBitMask = PhysicsCatagory.Guava
        guava.physicsBody?.collisionBitMask = 1
        guava.physicsBody?.contactTestBitMask = PhysicsCatagory.Boognish
        
        guava.zPosition = 0
        
        guavaNode.addChild(guava)
        
        
        guava.runAction(GuavaMoveAndRemove)
        
        self.addChild(guavaNode)
        
       
        if scoreIncreased == true {
            
            
        }
        
        
        
        //the way the guava collide
        
    }
    


    func spawnPipes(){
        
        //the way the Pipes spawn and move
        
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + pipeUpTexture.size().width * 2, 0)
        
        pipePair.zPosition = 1
        
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
        
    }
        
    
    
    func createBTN(){
        
        //The restart button
        
        restartBTN = SKSpriteNode(imageNamed: "restart")
        restartBTN.setScale(0.25)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        self.addChild(restartBTN)
        
    }
    
            


        
        
    
     override  func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            
            boognish.physicsBody?.velocity = CGVectorMake(0, 0)
            boognish.physicsBody?.applyImpulse(CGVectorMake(0,25))
            
            if died == true {
                boognish.physicsBody?.velocity = CGVectorMake(0, 0)
                boognish.physicsBody?.applyImpulse(CGVectorMake(0,0))
                
                if score > highScore {
                highScore = score
                }
                else{
                    highScore == highScore
                    
                }
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
    //What happens when the game is restarted
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died=false
        gameStared = true
        score = 0
        highScoreLbl.text = "high score \(highScore)"
        createScene()
        
        
    }

}