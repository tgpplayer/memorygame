

import UIKit

class ViewController: UIViewController {

    var loops = 0
    var numberOfColor = ""
    var pressCounter = 0
    var loopDone = false
    var gameOver = false
    
    var level = 0.9
    
    let colorList: [UIColor] = [UIColor.red, UIColor.green, UIColor.purple, UIColor.orange, UIColor.white, UIColor.blue]
    
    var actualSequence: [UIColor] = []
    var sequencePressed: [UIColor] = []

    @IBOutlet weak var redB: UIButton!
    @IBOutlet weak var greenB: UIButton!
    @IBOutlet weak var purpleB: UIButton!
    @IBOutlet weak var orangeB: UIButton!
    @IBOutlet weak var whiteB: UIButton!
    @IBOutlet weak var blueB: UIButton!
    
    @IBOutlet weak var RColorText: UIButton!
    @IBOutlet weak var howToPlay: UIButton!
    
    var Buttons: [UIButton] = []
    
    @IBOutlet weak var RItem: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Buttons += [redB, greenB, purpleB, orangeB, whiteB, blueB]
        
        // Prohibit pressing buttons until the user presses RItem
        enableButtons(v: false)
    }

    @IBAction func RText(_ sender: UIButton) {
        // Fill the actual sequence with the random elements from the array of colors
        makeNewSequence()
        RColorText.tintColor = UIColor.black
        howToPlay.isEnabled = false
        startSequence(level: level, loops: self.loops)
        // Show colors 1 by 1 letting the user to select the correct colors before the next secuence goes on
        RColorText.isUserInteractionEnabled = false
        
    }
    
    func startSequence(level: Double, loops: Int) {
        var colorsController = 0
        sequencePressed.removeAll()
        print("Speed: " + String(level))
        // We cast the Float level to TimeInterval
        // When the user rises up in level, the sequence is a new one and goes faster
        Timer.scheduledTimer(withTimeInterval: TimeInterval(level), repeats: true) { timer in
            
            self.RItem.backgroundColor = self.actualSequence[colorsController] // Paint RItem with the current element color
            
            self.numberOfColor = String(colorsController + 1) + ". "
            
            // Change the text correspondant to the actual color
            switch self.RItem.backgroundColor {
            case UIColor.red:
                self.RColorText.setTitle(self.numberOfColor + "RED", for: .normal)
            case UIColor.green:
                self.RColorText.setTitle(self.numberOfColor + "GREEN", for: .normal)
            case UIColor.purple:
                self.RColorText.setTitle(self.numberOfColor + "PURPLE", for: .normal)
            case UIColor.orange:
                self.RColorText.setTitle(self.numberOfColor + "ORANGE", for: .normal)
            case UIColor.white:
                self.RColorText.setTitle(self.numberOfColor + "WHITE", for: .normal)
            case UIColor.blue:
                self.RColorText.setTitle(self.numberOfColor + "BLUE", for: .normal)
            default: break
            }
            
            print(self.RItem.backgroundColor!)

            // More colors are going to be shown if the user sequence is the right one, so that if it is right, then are going to appear 2 colors. Now if the 2 colors shown coincide with the next user sequence, 3 colors are going to be shown next, and so on.
            
            if colorsController == self.loops {
                self.loopDone = true
            } else {
                self.loopDone = false
            }
            
            // If the loop has been done, the RItem turns black to indicate that the loop has been done
            if self.loopDone {
                print("Loop done")
                Timer.scheduledTimer(withTimeInterval: TimeInterval(level), repeats: true) { timer2 in
                    self.RItem.backgroundColor = UIColor.black
                    self.enableButtons(v: true)
                    timer2.invalidate()
                }
                timer.invalidate()
            }
            colorsController += 1
        }
    }
    
    // Each time a button is pressed, a new element is added to another list to later compare the lists and warn the user if he/she is right
    
    @IBAction func redPressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.red)
        finalCheck()
    }
    @IBAction func greenPressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.green)
        finalCheck()
    }
    
    @IBAction func purplePressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.purple)
        finalCheck()
    }
    @IBAction func orangePressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.orange)
        finalCheck()
    }
    @IBAction func whitePressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.white)
        finalCheck()
    }
    @IBAction func bluePressed(_ sender: UIButton) {
        sequencePressed.append(UIColor.blue)
        finalCheck()
    }
    
    
    func enableButtons (v: Bool) {
        for i in Buttons {
            i.isEnabled = v
        }
    }
    
    func compareSequences() {
        for i in 0...self.loops {
            if sequencePressed[i] != actualSequence[i] {
                // The secuence is erroneous and it warns the user
                print("The sequence is not the same")
                RItem.backgroundColor = UIColor.black
                RColorText.setTitle("WRONG! YOU LOSE", for: .normal)
                RColorText.tintColor =  UIColor.white
                enableButtons(v: false)
                gameOver = true
                break
            }
        }
        
        if gameOver == false {
            // If all the secuence is right pass to the next secuence of colors
            print("The actual sequence is correct")
            if loops < 5 {
                self.loops += 1
                pressCounter = 0
                startSequence(level: level, loops: self.loops)
            } else {
                print("Level complete")
                enableButtons(v: false)
                makeNewSequence()
                loops = 0
                pressCounter = 0
                level -= 0.2
                if level >= 0.4 {
                    startSequence(level: level, loops: loops)
                } else {
                    RItem.backgroundColor = UIColor.black
                    RColorText.setTitle("YOU WIN", for: .normal)
                    RColorText.tintColor =  UIColor.white
                    enableButtons(v: false)
                    gameOver = true
                }
            }
        }
        
        if gameOver == true {
            restartGame()
        }
    }
    
    // When the number of pulsations are the same as the number of colors shown, a comparison is done to see if the actual sequence is the same as the pressed sequence. If the number of pulsations are not the same, sum 1 to a counter until it is the same and then compare
    func finalCheck() {
        if pressCounter == loops {
            compareSequences()
        } else {
            pressCounter += 1
        }
    }
    
    func makeNewSequence() {
        // The actual sequence refers to the array of colors done randomly that the user has to press in the correct order
        actualSequence.removeAll()
        for _ in 1...colorList.count {
            actualSequence.append(self.colorList[Int.random(in: 0...self.colorList.count - 1)])
        }
    }
    
    func restartGame() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            self.RColorText.setTitle("READY? PRESS HERE", for: .normal)
            self.loops = 0
            self.pressCounter = 0
            self.level = 0.9
            self.howToPlay.isEnabled = true
            self.RColorText.isUserInteractionEnabled = true
            timer.invalidate()
        }
        self.gameOver = false
    }
}

