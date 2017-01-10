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
        
        bestScoreLabel.text = "\(SettingsManager.bestScore)"
        diffLvlSlider.value = Float(SettingsManager.difficultyLvl)/scale
        speedSlider.value   = Float(SettingsManager.speed)/(scale*2)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    fileprivate struct SliderTags{
        static let diffLvl  = 0
        static let speed    = 1
    }
    
    @IBAction func useSlider(_ sender: UISlider) {
        switch sender.tag {
        case SliderTags.diffLvl:
            SettingsManager.difficultyLvl  = Int(round(sender.value*scale))
        case SliderTags.speed:
            SettingsManager.speed          = Int(round(sender.value*scale*2))
        default: break
        }
    }
}
