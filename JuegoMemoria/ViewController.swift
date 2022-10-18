

import UIKit

class ViewController: UIViewController {

    var loops = 0
    var pressCounter = 0
    var loopDone = false
    
    let level1 = 0.8
    let level2 = 0.6
    let level3 = 0.4
    
    let colorList: [UIColor] = [UIColor.red, UIColor.green, UIColor.purple, UIColor.orange, UIColor.white, UIColor.blue]
    
    var actualSequence: [UIColor] = []
    var sequencePressed: [UIColor] = []

    @IBOutlet weak var redB: UIButton!
    @IBOutlet weak var greenB: UIButton!
    @IBOutlet weak var purpleB: UIButton!
    @IBOutlet weak var orangeB: UIButton!
    @IBOutlet weak var whiteB: UIButton!
    @IBOutlet weak var blueB: UIButton!
    
    var Buttons: [UIButton] = []
    
    @IBOutlet weak var RItem: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Buttons += [redB, greenB, purpleB, orangeB, whiteB, blueB]
        
        // Prohibit pressing buttons until the user presses RItem
        enableButtons(v: false)
    }

    @IBAction func RText(_ sender: UIButton) {
        // Fill the actual sequence with the random colors established previously
        for _ in 1...colorList.count {
            actualSequence.append(self.colorList[Int.random(in: 0...self.colorList.count - 1)])
        }
        countDown(level: level1, loops: self.loops) // loops: 3 (+1)
        // Show colors 1 by 1 letting the user to select the correct colors before the next secuence goes on
    }
    
    func countDown(level: Double, loops: Int) {
        var colorsController = 0
        sequencePressed.removeAll()
        // We cast the Float level to TimeInterval
        // There is a countdown which goes faster when the level of the game is higher than the last one
        // colorsController is realted to the number of colors that have appeared
        Timer.scheduledTimer(withTimeInterval: TimeInterval(level), repeats: true) { timer in
            
            self.RItem.backgroundColor = self.actualSequence[colorsController] // Paint RItem with the current element color
            // Each 0.8 secs the color is going to be the next of the array
            
            print(self.RItem.backgroundColor!)

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
                print("La secuencia no es igual")
                break
            }
        }
        
        // If all the secuence is right pass to the next secuence of colors
        print("Secuencia actual correcta")
        if loops < 5 {
            self.loops += 1
            pressCounter = 0
            countDown(level: level1, loops: self.loops)
        } else {
            print("Nivel 1 superado")
            enableButtons(v: false)
        }
        
    }
    
    func finalCheck() {
        if pressCounter == loops {
            compareSequences()
        } else {
            pressCounter += 1
        }
    }
}

