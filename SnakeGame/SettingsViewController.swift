//
//  SettingsViewController.swift
//  SnakeGame
//
//  Created by Axel Nowaczyk on 08.04.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var bestScoreLabel: UILabel!
    @IBOutlet var diffLvlSlider: UISlider!
    @IBOutlet var speedSlider: UISlider!
    let scale: Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestScoreLabel.text = "\(Settings.bestScore)"
        diffLvlSlider.value = Float(Settings.difficultyLvl)/scale
        speedSlider.value   = Float(Settings.speed)/(scale*2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private struct SliderTags{
        static let diffLvl  = 0
        static let speed    = 1
    }
    
    @IBAction func useSlider(sender: UISlider) {
        switch sender.tag {
        case SliderTags.diffLvl:
            Settings.difficultyLvl  = Int(round(sender.value*scale))
            Settings.save(Settings.Saveable.DiffLvl)
        case SliderTags.speed:
            Settings.speed          = Int(round(sender.value*scale*2))
            Settings.save(Settings.Saveable.Speed)
        default: break
        }
    }
}