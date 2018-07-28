//
//  GameScene.swift
//  schoolhouseSkateboarder
//
//  Created by Allison on 7/19/18.
//  Copyright © 2018 Allison. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let skater: UInt32 = 0x1 << 0
    static let brick: UInt32 = 0x1 << 1
    static let gem: UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //enum for ypos spawn points for bricks
    enum BrickLevel: CGFloat {
        case low = 0.0
        case high = 100.0
    }
    
    //states of game
    enum GameState {
        case notRunning
        case running
    }
    
    //array of bricks
    var bricks = [SKSpriteNode]()
    var gems = [SKSpriteNode]()
    var brickSize = CGSize.zero
    
    var brickLevel = BrickLevel.low
    
    var gameState = GameState.notRunning
    
    var scrollSpeed: CGFloat = 5.0
    let startingScrollSpeed: CGFloat = 5.0
    
    let gravitySpeed: CGFloat = 1.5
    
    var score: Int = 0
    var highScore: Int = 0
    var lastScoreUpdateTime: TimeInterval = 0.0
    
    var lastUpdateTime: TimeInterval?
    
    let skater = Skater(imageNamed: "skater")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -6.0)
        
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        let xMid = frame.midX
        let yMid = frame.midY
        background.position = CGPoint(x: xMid, y: yMid)
        addChild(background)
        
        setupLabels()
        
        //set up skater and add her to scene
        skater.setupPhysicsBody()
        addChild(skater)
        
        //add tap gesture recognizer
        let tapMethod = #selector(GameScene.handleTap(tapGesture:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapMethod)
        view.addGestureRecognizer(tapGesture)
        
        //add menu overlay
        let menuBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        let menuLayer = MenuLayer(color: menuBackgroundColor, size: frame.size)
        menuLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        menuLayer.position = CGPoint(x: 0.0, y: 0.0)
        menuLayer.zPosition = 30
        menuLayer.name = "menuLayer"
        menuLayer.display(message: "tap to play", score: nil)
        addChild(menuLayer)
    }
    func resetSkater() {
        //set starting position, zpos, and miny
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
        
        skater.zRotation = 0.0
        skater.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        skater.physicsBody?.angularVelocity = 0.0
    }
    func setupLabels() {
        //label for score in upper left
        let scoreTextLabel: SKLabelNode = SKLabelNode(text: "score")
        scoreTextLabel.position = CGPoint(x: 14.0, y: frame.size.height - 20.0)
        scoreTextLabel.horizontalAlignmentMode = .left
        scoreTextLabel.fontName = "Courier-Bold"
        scoreTextLabel.fontSize = 14.0
        scoreTextLabel.zPosition = 20
        addChild(scoreTextLabel)
        //label for actual score
        let scoreLabel: SKLabelNode = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: 14.0, y: frame.size.height - 40.0)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Courier-Bold"
        scoreLabel.fontSize = 18.0
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = 20
        addChild(scoreLabel)
        //label for high score
        let highScoreTextLabel: SKLabelNode = SKLabelNode(text: "high score")
        highScoreTextLabel.position = CGPoint(x: frame.size.width - 14.0,
                                              y: frame.size.height - 20.0)
        highScoreTextLabel.horizontalAlignmentMode = .right
        highScoreTextLabel.fontName = "Courier-Bold"
        highScoreTextLabel.fontSize = 14.0
        highScoreTextLabel.zPosition = 20
        addChild(highScoreTextLabel)
        //label for the actual high score itself yeah
        let highScoreLabel: SKLabelNode = SKLabelNode(text: "0")
        highScoreLabel.position = CGPoint(x: frame.size.width - 14.0,
                                          y: frame.size.height - 40.0)
        highScoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.fontName = "Courier-Bold"
        highScoreLabel.fontSize = 18.0
        highScoreLabel.name = "highScoreLabel"
        highScoreLabel.zPosition = 20
        addChild(highScoreLabel)
    }
    func updateScoreLabelText() {
        if let scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode {
            scoreLabel.text = String(format: "%04d", score)
        }
    }
    func updateHighScoreLabelText() {
        if let highScoreLabel = childNode(withName: "highScoreLabel") as? SKLabelNode {
            highScoreLabel.text = String(format: "%04d", highScore)
        }
    }
    func startGame() {
        //reset to starting conditions
        gameState = .running
        resetSkater()
        score = 0
        scrollSpeed = startingScrollSpeed
        brickLevel = .low
        lastUpdateTime = nil
        
        for brick in bricks {
            brick.removeFromParent()
        }
        
        bricks.removeAll(keepingCapacity: true)
        
        for gem in gems {
            removeGem(gem)
        }
    }
    func gameOver() {
        gameState = .notRunning
        if score > highScore {
            highScore = score
            updateHighScoreLabelText()
        }
        //show "game over" menu overlay
        let menuBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        let menuLayer = MenuLayer(color: menuBackgroundColor, size: frame.size)
        menuLayer.anchorPoint = CGPoint.zero
        menuLayer.position = CGPoint.zero
        menuLayer.zPosition = 30
        menuLayer.name = "menuLayer"
        menuLayer.display(message: "game over!", score: score)
        addChild(menuLayer)
    }
    func spawnBrick(atPosition position: CGPoint) -> SKSpriteNode {
        //create brick and add it to scene
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
      
        brickSize = brick.size     //update brickSize
        bricks.append(brick)       //add to array
        
        //brick's physics body
        let center = brick.centerRect.origin
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size, center: center)
        brick.physicsBody?.affectedByGravity = false
        
        brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
        brick.physicsBody?.collisionBitMask = 0
        
        return brick               //return brick to caller
    }
    func spawnGem(atPosition position: CGPoint) {
        //create and add to scene
        let gem = SKSpriteNode(imageNamed: "gem")
        gem.position = position
        gem.zPosition = 9
        addChild(gem)
        
        gem.physicsBody = SKPhysicsBody(rectangleOf: gem.size, center: gem.centerRect.origin)
        gem.physicsBody?.categoryBitMask = PhysicsCategory.gem
        gem.physicsBody?.affectedByGravity = false
        gems.append(gem)
    }
    func removeGem(_ gem: SKSpriteNode) {
        gem.removeFromParent()
        
        if let gemIndex = gems.index(of: gem) {
            gems.remove(at: gemIndex)
        }
    }
    func updateBricks(withScrollAmount currentScrollAmount: CGFloat) {
        //keep track of greatest xpos of current bricks
        var farthestRightBrickX: CGFloat = 0.0
        
        for brick in bricks {
            let newX = brick.position.x - currentScrollAmount
            
            if newX < -brickSize.width { //if brick is off screen, remove
                brick.removeFromParent()
                if let brickIndex = bricks.index(of: brick) {
                    bricks.remove(at: brickIndex)
                }
            } else {
                //update positions
                brick.position = CGPoint(x: newX, y: brick.position.y)
                
                if brick.position.x > farthestRightBrickX {
                    farthestRightBrickX = brick.position.x
                }
                
            }
        }
        //keep screen full of bricks
        while farthestRightBrickX < frame.width {
            var brickX = farthestRightBrickX + brickSize.width + 1.0
            let brickY = (brickSize.height / 2.0) + brickLevel.rawValue
            
            //leave a gap sometimes
            let randomNumber = arc4random_uniform(99)
            if randomNumber < 2 && score > 10 {
                //2% chance will leave gap after player has reached score of 10
                let gap = 20.0 * scrollSpeed
                brickX += gap
                
                //add gem
                let randomGemYAmount = CGFloat(arc4random_uniform(150))
                let newGemY = brickY + skater.size.height + randomGemYAmount
                let newGemX = brickX - gap / 2.0
                
                spawnGem(atPosition: CGPoint(x: newGemX, y: newGemY))
            }
            else if randomNumber < 4 && score > 20 {
                //2% chance that brick Y level will change after player reached score of 20
                if brickLevel == .high {
                    brickLevel = .low
                }
                else if brickLevel == .low {
                    brickLevel = .high
                }
            }
            //spawn new brick
            let newBrick = spawnBrick(atPosition: CGPoint(x: brickX, y: brickY))
            farthestRightBrickX = newBrick.position.x
        }
    }
    func updateGems(withScrollAmount currentScrollAmount: CGFloat) {
        for gem in gems {
            //update positions
            let thisGemX = gem.position.x - currentScrollAmount
            gem.position = CGPoint(x: thisGemX, y: gem.position.y)
            //removing gems
            if gem.position.x < 0.0{
                removeGem(gem)
            }
        }
    }
    func updateSkater() {
        if let velocityY = skater.physicsBody?.velocity.dy {
            if velocityY < -100.0 || velocityY > 100.0 {
                skater.isOnGround = false
            }
        }
        //check if game should end
        let isOffScreen = skater.position.y < 0.0 || skater.position.x < 0.0
        
        let maxRotation = CGFloat(GLKMathDegreesToRadians(85.0))
        let isTippedOver = skater.zRotation > maxRotation || skater.zRotation < -maxRotation
        
        if isOffScreen || isTippedOver {
            gameOver()
        }
    }
    func updateScore(withCurrentTime currentTime: TimeInterval) {
        let elapsedTime = currentTime - lastScoreUpdateTime
        
        if elapsedTime > 1.0 {
            score += Int(scrollSpeed)
            lastScoreUpdateTime = currentTime
            updateScoreLabelText()
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if gameState != .running {
            return
        }
        
        scrollSpeed += 0.01
        
        //determine elapsed time since last update
        var elapsedTime: TimeInterval = 0.0
        
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }
        lastUpdateTime = currentTime
        
        let expectedElapsedTime: TimeInterval = 1.0/60.0
        
        //calculate how far things should move
        let scrollAdjustment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjustment
        
        updateBricks(withScrollAmount: currentScrollAmount)
        updateSkater()
        updateGems(withScrollAmount: currentScrollAmount)
        updateScore(withCurrentTime: currentTime)
    }
    func handleTap(tapGesture: UITapGestureRecognizer) {
        //make skater jump
        if gameState == .running {
            skater.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 260.0))
            run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
        } else {
            //if game is not running
            if let menuLayer: SKSpriteNode = childNode(withName: "menuLayer") as? SKSpriteNode {
                menuLayer.removeFromParent()
            }
            startGame()
        }
    }
    // MARK:- SKPhysicsContactDelegate Methods
    func didBegin(_ contact: SKPhysicsContact) {
        //check if contact is between skater and brick
        if contact.bodyA.categoryBitMask == PhysicsCategory.skater && contact.bodyB.categoryBitMask == PhysicsCategory.brick {
            
            if let velocityY = skater.physicsBody?.velocity.dy {
                if !skater.isOnGround && velocityY < 100.0 {
                    skater.createSparks()
                }
            }
            skater.isOnGround = true
        }
        else if contact.bodyA.categoryBitMask == PhysicsCategory.skater &&
            contact.bodyB.categoryBitMask == PhysicsCategory.gem {
            //remove
            if let gem = contact.bodyB.node as? SKSpriteNode {
                removeGem(gem)
                
                score += 50
                updateScoreLabelText()
                
                run(SKAction.playSoundFileNamed("gem.wav", waitForCompletion: false))
            }
        }
    }
    
}
