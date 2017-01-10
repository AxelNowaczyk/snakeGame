//
//  SettingsManager.swift
//  SnakeGame
//
//  Created by Axel Nowaczyk on 10/01/2017.
//  Copyright © 2017 Axel Nowaczyk. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {
    
    static let shared = SettingsManager()
    
    public var _speed           = 4 // range <0;10>
    public var _bestScore       = 0
    public var _difficultyLvl   = 0 // range <0;5>
    
    public let heightOfBoard   = 40
    public let widthOfBoard    = 20
    public let foodAddingTime  = 20
    
    public static var speed: Int {
        get {
            return self.shared._speed
        }
        set {
            self.shared._speed = newValue
            self.shared.saveValue(for: .speed)
        }
    }
    
    public static var bestScore: Int {
        get {
            return self.shared._bestScore
        }
        set {
            self.shared._bestScore = newValue
            self.shared.saveValue(for: .bestScore)
        }
    }
    
    public static var difficultyLvl: Int {
        get {
            return self.shared._difficultyLvl
        }
        set {
            self.shared._difficultyLvl = newValue
            self.shared.saveValue(for: .diffLvl)
        }
    }
    
    public static var boardHeight: Int {
        return self.shared.heightOfBoard
    }
    
    public static var boardWidth: Int {
        return self.shared.widthOfBoard
    }
    
    public static var foodTime: Int {
        return self.shared.foodAddingTime
    }
    
    override init() {
        super.init()
        
        self.loadSettings()
    }
    
    private enum SettingTypes: String{
        case speed = "speed"
        case bestScore = "bestScore"
        case diffLvl = "difficultyLvl"
        
        static let allValues: [SettingTypes] = [
        .speed,
        .bestScore,
        .diffLvl]
    }
    
    private func loadSettings() {
        for setting in SettingTypes.allValues {
            loadValue(for: setting)
        }
    }
    
    private func loadValue(for setting: SettingTypes) {
        let value = UserDefaults.standard.integer(forKey: setting.rawValue)
        
        switch setting {
        case .speed:
            self._speed = value
        case .bestScore:
            self._bestScore = value
        case .diffLvl:
            self._difficultyLvl = value
        }
        
    }

    private func saveSettings() {
        for setting in SettingTypes.allValues {
            saveValue(for: setting)
        }
    }
    
    private func saveValue(for setting: SettingTypes) {
        var value: Int?
        
        switch setting {
        case .speed:
            value = self._speed
        case .bestScore:
            value = self._bestScore
        case .diffLvl:
            value = self._difficultyLvl
        }
        if let value = value {
            UserDefaults.standard.setValue(value, forKey: setting.rawValue)
        } else {
            print("couldn't save result")
        }
        
    }
    
}




