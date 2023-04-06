//
//  GameScene.swift
//  WordGame
//
//  Created by Fatih Özen on 2.04.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var delete: SKSpriteNode = SKSpriteNode()
    var check: SKSpriteNode = SKSpriteNode()
    
    var skorLabel: SKLabelNode = SKLabelNode()
    var wordLabel: SKLabelNode = SKLabelNode()
    
    var viewController: UIViewController?
    
    var createBlockTimer: Timer?
    var fallingTimer: Timer?
    
    var block: SKSpriteNode?
    var myShape: SKShapeNode?
    
    var block2: SKSpriteNode?
    var myShape2: SKShapeNode?
    
    var blockTMP: SKSpriteNode?
    var block2TMP: SKSpriteNode?
    
    var created = false
    var counter = 0
    var contact = false
    var deleted = false
    var newBlockCreated = false
    var control = 0
    
    var blocks = [SKSpriteNode]()
    var checkBlocks = [SKSpriteNode]()
    
    var alphabet = ["A","B","C","Ç","D","E","F","G","Ğ","H","I","İ","J","K","L","M","N","O","Ö","P","R","S","Ş","T","U","Ü","V","Y","Z"]
    var xCoordinates: [Double] = [110.928,187.0,261.700,337.500,411.0,487.600,563.500,642.166]
    // 39 ekle
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let pause: SKShapeNode = SKShapeNode(rect: CGRect(x: 110, y: -140, width: 70, height: 70), cornerRadius: 20)
        pause.fillColor = .yellow
        pause.zPosition = 3
        addChild(pause)
        
        if let tempKarakter = self.childNode(withName: "delete") as? SKSpriteNode {
            delete = tempKarakter
        }
        
        if let tempKarakter = self.childNode(withName: "check") as? SKSpriteNode {
            check = tempKarakter
        }
        
        if let tempKarakter = self.childNode(withName: "skorLabel") as? SKLabelNode {
            skorLabel = tempKarakter
        }
        
        if let tempKarakter = self.childNode(withName: "wordLabel") as? SKLabelNode {
            wordLabel = tempKarakter
        }
    
       
        fallingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(falling), userInfo: nil, repeats: true)
    
        
        createBlockTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(randomCreate), userInfo: nil, repeats: true)
    }
    
    @objc func randomCreate() {
    
        let randomCoordinate = Int.random(in: 0 ..< xCoordinates.count)
        let randomAlphabet = Int.random(in: 0 ..< alphabet.count)
        
        newBlockCreated = true
        created = true
        deleted = false
        
        if counter == 0 {
            counter = 1
            //control = 0
            
            myShape = SKShapeNode(rect: CGRect(x:0, y:0, width: 70, height: 75))
            
            if let myShape = myShape {
                myShape.strokeColor = .red
                myShape.fillColor = .green
                myShape.lineWidth = 5
                myShape.lineCap = .round
                
                let texture = view?.texture(from: myShape)
                
                block = SKSpriteNode(texture: texture)
                if let block = block {
                    block.size = CGSize(width: 70, height: 75)
                        
                    let label = SKLabelNode(fontNamed: "Arial")
                        
                    label.text = alphabet[randomAlphabet]
                    label.fontColor = .black
                    label.verticalAlignmentMode = .center
                    label.zPosition = 1
                    
                    let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Helvetica Neue", .name: "HelveticaNeue-Bold"])
                    let boldFont = UIFont(descriptor: fontDescriptor, size: 30)
                    label.fontName = boldFont.fontName
                        
                    let physicsBody = SKPhysicsBody(rectangleOf: block.size)
                    physicsBody.isDynamic = true // Kare hareket edebilir
                    physicsBody.affectedByGravity = false
                    physicsBody.contactTestBitMask = 1
                    
                    block.physicsBody = physicsBody
                    block.position = CGPoint(x: xCoordinates[4], y: -220)
                    
                    block.addChild(label)
                    blockTMP = block
                    addChild(block)
                    return
                }
            }
        }else{
            counter = 0
            
            myShape2 = SKShapeNode(rect: CGRect(x:0, y:0, width: 70, height: 75))
            
            if let myShape = myShape2 {
                myShape.strokeColor = .red
                myShape.fillColor = .green
                myShape.lineWidth = 5
                myShape.lineCap = .round
                
                let texture = view?.texture(from: myShape)
                
                block2 = SKSpriteNode(texture: texture)
                
                if let block2 = block2 {
                    block2.size = CGSize(width: 70, height: 75)
                        
                    let label = SKLabelNode(fontNamed: "Arial")
                        
                    label.text = alphabet[randomAlphabet]
                    label.fontColor = .black
                    label.verticalAlignmentMode = .center
                    label.zPosition = 1
                    
                    let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Helvetica Neue", .name: "HelveticaNeue-Bold"])
                    let boldFont = UIFont(descriptor: fontDescriptor, size: 30)
                    label.fontName = boldFont.fontName
                        
                    let physicsBody = SKPhysicsBody(rectangleOf: block2.size)
                    physicsBody.isDynamic = true // Kare hareket edebilir
                    physicsBody.affectedByGravity = false
                    physicsBody.contactTestBitMask = 1
                    
                    block2.physicsBody = physicsBody
                    block2.position = CGPoint(x: xCoordinates[5], y: -220)
                    
                    block2.addChild(label)
                    block2TMP = block2
                    addChild(block2)
                    return
                }
            }
        }
    }
    
    @objc func falling() {
        let downMove: SKAction = SKAction.moveBy(x: 0, y: -65, duration: 1)
        
        if (created) {
            if let block = block {
                block.run(downMove)
            }
            if let block2 = block2 {
                block2.run(downMove)
            }
            
        }
            
    }
    
    func removeChar(character: Character) {
        
        let char: Character = character // öreneğin a geldi
        var str = wordLabel.text!.split(separator: "")
        
        var index = str.count - 1
        while (index > -1) {
            
            let check = String(str[index]).first!
            
            if check == char {
                let a = str.index(str.startIndex, offsetBy: index)
                str.remove(at: a)
                
                break
            }
            index = index - 1
        }
        
        let newLabel = str.joined()
        
        wordLabel.text = newLabel
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
       
    }
    
    // çarpışma kontrolü
    func didBegin(_ contact: SKPhysicsContact) {
        //deleted = false
        
        
        
        
        
        
        if !deleted {
            if !newBlockCreated {
                control = 1
            }
            
            if counter == control {
                blocks.append(blockTMP!)
                print("block 1 çarptı")
                
                if (blockTMP?.position.y)! > -300 {
                    print("oyun bitti \(String(describing: blockTMP?.position.y))")
                    DispatchQueue.main.async {
                        self.fallingTimer?.invalidate()
                        self.createBlockTimer?.invalidate()
                    }
                    //viewController?.performSegue(withIdentifier: "toResultVC", sender: nil)
                    return
                }
                if !deleted {
                    block = nil
                }
                if !newBlockCreated {
                    counter = 1
                }
            }else {
                blocks.append(block2TMP!)
                print("block 2 çarptı")
                
                if (block2TMP?.position.y)! > -300 {
                    print("oyun bitti \(String(describing: block2TMP?.position.y))")
                    DispatchQueue.main.async {
                        self.fallingTimer?.invalidate()
                        self.createBlockTimer?.invalidate()
                    }
                    //viewController?.performSegue(withIdentifier: "toResultVC", sender: nil)
                    return
                }
                if !deleted {
                    block2 = nil
                }
                if !newBlockCreated {
                    counter = 0
                }
            }
        }
        newBlockCreated = false
    }
    
    func clicked(sprite: SKSpriteNode, label: SKLabelNode) {
        
        let clickShape = SKShapeNode(rect: CGRect(x:0, y:0, width: 70, height: 75))
        clickShape.strokeColor = .green
        clickShape.fillColor = .red
        clickShape.lineWidth = 5
        clickShape.lineCap = .round
        label.fontColor = .white
        
        let texture = view?.texture(from: clickShape)
        
        sprite.texture = texture
    }
    
    func doubleClicked(sprite: SKSpriteNode, label: SKLabelNode) {
        
        let clickShape = SKShapeNode(rect: CGRect(x:0, y:0, width: 70, height: 75))
        clickShape.strokeColor = .red
        clickShape.fillColor = .green
        clickShape.lineWidth = 5
        clickShape.lineCap = .round
        label.fontColor = .black
        
        let texture = view?.texture(from: clickShape)
        
        sprite.texture = texture
    }
    
    // tıklama kontrolü
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = atPoint(location)

                if let sprite = touchedNode as? SKSpriteNode {
                                        
                    if sprite.children.count > 0  {
                        
                        let label = sprite.children[0] as! SKLabelNode
                        
                        if label.text!.contains(" ") {
                            
                            removeChar(character: label.text!.first!)
                            // ikinci tıklamada karakter labeldan siliniyor
                            
                            let newBoxLabel = label.text?.replacingOccurrences(of: " ", with: "")
                            label.text = newBoxLabel
                            
                            doubleClicked(sprite: sprite, label: label)// tasarım
                            
                        }else {
                            
                            wordLabel.text! += (label.text ?? "") + " "
                            
                            label.text = (label.text ?? "") + " "
                            
                            clicked(sprite: sprite, label: label)// tasarım
                            checkBlocks.append(sprite)
                        }
                        
                        // blocklar için geçerli diğer spritelar giremez
                        
                    }
                    
                    if sprite.name == "check" {
                        // burada kelime kontrolü yapılacak
                        if checkBlocks.count > 0 {
                            for sprite in checkBlocks {
                                sprite.removeFromParent()
                                checkBlocks.removeAll()
                            }
                            
                            wordLabel.text = ""
                            deleted = true
                            for block in blocks {
                                block.physicsBody?.affectedByGravity = true

                            }
                        }
                        
                    }
                    
                    if sprite.name == "delete" {
                        
                        if checkBlocks.count > 0 {
                            for sprite in checkBlocks {
                                let label = sprite.children[0] as! SKLabelNode
                                doubleClicked(sprite: sprite, label: label)
                            }
                            wordLabel.text = ""
                        }
                    }
                   
                }
            }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
