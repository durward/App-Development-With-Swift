//
//  ViewController.swift
//  Light
//
//  Created by Durward Benham III on 12/23/17.
//  Copyright © 2017 Durward Benham. All rights reserved.
//

import UIKit
import AVFoundation

// Experimenting with type extensions to allow for casting from Bool -> Float
extension Float {
    init(_ bool:Bool) {
        self = bool ? 1.0 : 0.0
    }
}

class ViewController: UIViewController {
    
    var lightOn = true
    
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBAction func buttonPressed(_ sender: Any) {
        lightOn = !lightOn
        update(newVal: Float(lightOn))
    }
    
    @IBAction func onSlide(_ sender: UISlider) {
        update(newVal: sender.value)
    }
    
    // Updates the screen brightness, background color, and torch level
    func update(newVal: Float) {
        //breaking out the update into smaller, more manageable/editable functions
        updateBrightness(newVal)
        updateColor(newVal)
        updateTorchLevel(newVal)
    }
    
    func updateBrightness(_ newVal: Float) {
        brightnessSlider.value = newVal
        UIScreen.main.brightness = newVal == 0.0 ? 0.001 : CGFloat(newVal)
    }
    
    func updateColor(_ newVal: Float) {
        view.backgroundColor = newVal == 0.0 ? .black : .white
    }
    
    func updateTorchLevel(_ newVal:Float) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                let val = newVal
                if val == 0.0 {
                    device.torchMode = .off
                }
                else {
                    try device.setTorchModeOn(level: newVal)
                    lightOn = true
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update(newVal: Float(lightOn))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

