//
//  GameScene.swift
//  WordGame
//
//  Created by Fatih Özen on 2.04.2023.
//

import SpriteKit
import GameplayKit
import CoreData

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var skorLabel: SKLabelNode = SKLabelNode()
    var wordLabel: SKLabelNode = SKLabelNode()
    
    var viewController: UIViewController?
    
    var createBlockTimer: Timer?
    var fallingTimer: Timer?
    var threeRowsTimer: Timer?
    
    var block: SKSpriteNode?
    var myShape: SKShapeNode?
    
    var created = false
    var deleted = false
    var index = 0
    var threeCounter = 0
    var falled = false
    var time = 6
    var mistakeCounter = 0
    var currentScore = 0
    var goToResult = true
    var silent = 0
    //var iceBox = 0
    
    var blocks = [SKSpriteNode]()
    var checkBlocks = [SKSpriteNode]()
    var contactBloks = [SKSpriteNode]()
    
    var silents = ["B","C","Ç","D","F","G","Ğ","H","J","K","L","M","N","P","R","S","Ş","T","V","Y","Z"]
    var vowels = ["A","E","I","İ","O","Ö","U","Ü"]
    var xCoordinates: [Double] = [110.928,188.0,263.700,339.500,415.0,491.0,567.0,642.166]
    
    var point: [String: Int] = ["A": 1, "B": 3, "C": 4, "Ç": 4, "D": 3, "E": 1, "F": 7, "G": 5, "Ğ": 8, "H": 5, "I": 2, "İ": 1, "J": 10, "K": 1, "L":1, "M":2, "N": 1, "O": 2, "Ö": 7, "P": 5, "R": 1, "S": 2, "Ş": 4, "T": 1, "U": 2, "Ü": 3, "V": 7, "Y": 3, "Z": 4]
    // 39 ekle
    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self
        
        let pause: SKShapeNode = SKShapeNode(rect: CGRect(x: 110, y: -140, width: 70, height: 70), cornerRadius: 20)
        pause.fillColor = .yellow
        pause.zPosition = 3
        addChild(pause)
        
        if let tempKarakter = self.childNode(withName: "skorLabel") as? SKLabelNode {
            skorLabel = tempKarakter
        }
        
        if let tempKarakter = self.childNode(withName: "wordLabel") as? SKLabelNode {
            wordLabel = tempKarakter
        }
     
        fallingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(falling), userInfo: nil, repeats: true)
        
        threeRowsTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(threeRows), userInfo: nil, repeats: true)
    }
    
    func startCreating() {
        createBlockTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time), target: self, selector: #selector(randomCreate), userInfo: nil, repeats: true)
    }
    
    @objc func randomCreate() {
        if mistakeCounter >= 3 {
            mistakeRow()
            mistakeCounter = 0
        } else {
            createBlockWithArray()
        }
        created = true
        deleted = false
    }
    
    @objc func falling() {
        
        if falled {
            blockFalling()
        } else {
            threeFalling()
        }
    }
    
    func blockFalling() {
        let downMove: SKAction = SKAction.moveBy(x: 0, y: -65, duration: 1)
        
        if created {
            let setBlocks = Set(blocks)
            let setContacts = Set(contactBloks)
            
            let setDiff = setBlocks.subtracting(setContacts)
            
            let arrayDiff = Array(setDiff)

            for block in arrayDiff {
                block.run(downMove)
            }
        }
    }
    func mistakeRow() {
        for x in xCoordinates {
            blockApper(coordinate: x)
        }
    }
    
    @objc func threeFalling() {

        let downMove: SKAction = SKAction.moveBy(x: 0, y: -65, duration: 1)
        
        for sprite in blocks {
            sprite.run(downMove)
        }
    }
    
    @objc func threeRows() {
        
        if threeCounter < 3 {
            threeCounter += 1
            for x in xCoordinates {
                blockApper(coordinate: x)
            }
        } else {
            threeRowsTimer!.invalidate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                self.startCreating()
            }
        }
    }
    
    func createBlockWithArray() {
        
        let randomCoordinate = Int.random(in: 0 ..< xCoordinates.count)
        
        blockApper(coordinate: randomCoordinate)
    }
    
    func blockApper(coordinate: any Numeric) {
        let randomSilents = Int.random(in: 0 ..< silents.count)
        let randomVowels = Int.random(in: 0 ..< vowels.count)
        
        let randomArr = [1,1,1,1,1,0,0,0,0,0].shuffled()
        let randomIndex = Int.random(in: 0 ..< randomArr.count)
        let selectedItem = randomArr[randomIndex]
        // random elemanın gelme oranı için oluşturuldu bu kısım
        myShape = SKShapeNode(rect: CGRect(x:0, y:0, width: 70, height: 75))
        
        if let myShape = myShape {
            myShape.strokeColor = .red
            
//            if iceBox == 5 {
//                myShape.fillColor = .systemBlue
//                iceBox = 0
//            } else {
//                myShape.fillColor = .green
//                iceBox += 1
//            }
           
            myShape.lineWidth = 5
            myShape.lineCap = .round
            
            let texture = view?.texture(from: myShape)
            
            block = SKSpriteNode(texture: texture)
            if let block = block {
                block.size = CGSize(width: 70, height: 75)
                
                let label = SKLabelNode(fontNamed: "Arial")
                
//                if iceBox == 0 {
//                    label.color = .blue
//                } else {
//                    label.color = .green
//                }
                
                if selectedItem == 1 && silent < 3{
                    label.text = silents[randomSilents]
                    silent += 1
                } else {
                    label.text = vowels[randomVowels]
                    silent = 0
                }
                //burada sesli sessiz dengesi kurdum
                label.fontColor = .black
                label.verticalAlignmentMode = .center
                label.zPosition = 1
                
                let fontDescriptor = UIFontDescriptor(fontAttributes: [.family: "Helvetica Neue", .name: "HelveticaNeue-Bold"])
                let boldFont = UIFont(descriptor: fontDescriptor, size: 30)
                label.fontName = boldFont.fontName
                
                let physicsBody = SKPhysicsBody(rectangleOf: block.size)
                physicsBody.isDynamic = true
                physicsBody.affectedByGravity = false
                physicsBody.allowsRotation = false
                physicsBody.contactTestBitMask = 1
                
                block.physicsBody = physicsBody
                
                if let coordinate = coordinate as? Int {
                    block.position = CGPoint(x: xCoordinates[coordinate], y: -220)
                }
                
                if let coordinate = coordinate as? Double {
                    block.position = CGPoint(x: coordinate, y: -220)
                }
                
                
                block.addChild(label)
                blocks.append(block)
                addChild(block)
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
    // puan hesaplama
    func calculatePoint(label: String) {
        let puanstr = skorLabel.text!.split(separator: ": ")
        let text = label
        
        if var puan = Int(puanstr[1]) {
            
            let str = text.split(separator: "")
            
            for char in str {
                
                puan += point[String(char)] ?? 0
            }
            self.currentScore = puan
            self.conditionTime(puan)
            skorLabel.text = "SKOR: \(puan)"
        }
    }
    
    func conditionTime(_ puan: Int) {
        if puan >= 100 && puan < 200 {
            time = 5
            createBlockTimer?.invalidate()
            startCreating()
        }else if puan >= 200 && puan < 300 {
            time = 4
            createBlockTimer?.invalidate()
            startCreating()
        }else if puan >= 300 && puan < 400 {
            time = 3
            createBlockTimer?.invalidate()
            startCreating()
        }else if puan >= 400 {
            time = 2
            createBlockTimer?.invalidate()
            startCreating()
        }
    }
    
    
    private func getWordsWithText(word: String) -> Bool{
        
        if let path = Bundle.main.path(forResource: "kelimeler", ofType: "txt") {
            
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                return data.contains(word.toLowerCasedTurkish())
            } catch {
                print(error)
                return false
            }
        }
        return false
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
        
        let spriteb = contact.bodyB.node as! SKSpriteNode
        let spritea = contact.bodyA.node as! SKSpriteNode

        if !contactBloks.contains(spriteb) {
            contactBloks.append(spriteb)
        }
        if !contactBloks.contains(spritea) {
            contactBloks.append(spritea)
        }
        
        if falled {
        
            if !deleted {

                    if  contactBloks[contactBloks.count - 1].position.y > -270 && goToResult {
                        //print("oyun bitti \(contactBloks[contactBloks.count - 1].position.y)")
                        self.fallingTimer?.invalidate()
                        self.createBlockTimer?.invalidate()
                        self.threeRowsTimer?.invalidate()
                        
                        goToResult = false
                        
                        let d = UserDefaults.standard
                        d.set(currentScore, forKey: "currentScore")
                        
                        viewController?.performSegue(withIdentifier: "toResultVC", sender: nil)
                        
                        return
                    }

            }
            
        } else if contact.bodyA.node?.name == "bottomSprite" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.falled = true
            }
        }
    
    }
    
    func deleteClicked() {
        if checkBlocks.count > 0 {
            for sprite in checkBlocks {
                let label = sprite.children[0] as! SKLabelNode
                doubleClicked(sprite: sprite, label: label)
                let newBoxLabel = label.text?.replacingOccurrences(of: " ", with: "")
                label.text = newBoxLabel
            }
            checkBlocks.removeAll()
            wordLabel.text = ""
        }
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
                            print("ikinci tıklama")
                            removeChar(character: label.text!.first!)
                            // ikinci tıklamada karakter labeldan siliniyor
                            
                            let newBoxLabel = label.text?.replacingOccurrences(of: " ", with: "")
                            label.text = newBoxLabel
                            
                            if let index = checkBlocks.firstIndex(of: sprite) {
                                checkBlocks.remove(at: index)
                            }
                          
                            doubleClicked(sprite: sprite, label: label)// tasarım
                            
                        }
//                            else if label.color == .blue {
//                            print("buz")
//                        }
                        else {
                            print("ilk tıklama normal")
                            wordLabel.text! += (label.text ?? "") + " "
                            
                            label.text = (label.text ?? "") + " "
                            
                            clicked(sprite: sprite, label: label)// tasarım
                            checkBlocks.append(sprite)
                        }
                        
                        // blocklar için geçerli diğer spritelar giremez
                        
                    }
                    
                    if sprite.name == "check" && checkBlocks.count > 3 { // && checkBlocks.count > 3
                        // burada kelime kontrolü yapılacak
                        let text = wordLabel.text!.replacingOccurrences(of: " ", with: "")
                        
                        if getWordsWithText(word: text) {
                            
                            if blocks.count > 0{
                                for sprite in checkBlocks {
                                    sprite.removeFromParent()
                                    checkBlocks.removeAll()
                                }
                                
                                calculatePoint(label: wordLabel.text!)
                                
                                wordLabel.text = ""
                                deleted = true
                                var i = contactBloks.count - 1
                                while i > 0 {
                                    contactBloks[i].physicsBody?.affectedByGravity = true
                                    i -= 1

                                }
                            }
                        } else {
                            deleteClicked()
                            mistakeCounter += 1
                        }
                        
                    }
                    
                    if sprite.name == "delete" {
                        
                        deleteClicked()
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
