//
//  SnakeGame.swift
//  SnakeGame
//
//  Created by Axel Nowaczyk on 07.04.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import Foundation

public struct Settings{
    static var speed           = 4 // range <0;10>
    static var bestScore       = 0
    static var difficultyLvl   = 1 // range <0;5>
    static let heightOfBoard   = 40
    static let widthOfBoard    = 20
    static let foodAddingTime  = 20
}
public enum Direction: Int{
    case North
    case West
    case South
    case East

    static var count: Int { return Direction.East.hashValue + 1}
}
private extension Int{
    func mod(modNumber: Int) -> Int{
        return (self+modNumber)%modNumber
    }
}
public enum Site{
    case Right
    case Left
}

class SnakeGame {
    private var moveCounter = 0
    var shape = [(Int,Int)]()
    var food = [(Int,Int)]()
    var dirOfMovement = Direction.North
    var score = 0
    init(){
        shape.append((Settings.widthOfBoard/2,Settings.heightOfBoard/2-1))
        shape.append((Settings.widthOfBoard/2,Settings.heightOfBoard/2))
        shape.append((Settings.widthOfBoard/2,Settings.heightOfBoard/2+1))
    }
    var snakeBitesHimself: Bool{
        for shp in 0..<shape.count{
            for shp2 in (shp+1)..<shape.count{
                if shape[shp].0 == shape[shp2].0 && shape[shp].1 == shape[shp2].1 {
                    return true
                }
            }
        }
        return false
    }
    func move(){
        addFood()
        moveSnake(detectCollisions())
    }
    private func moveSnake(collision: Bool){
        let first = shape.first!
        var newElement: (Int,Int)
        switch dirOfMovement {
        case .North:
            newElement.0 = first.0
            newElement.1 = (first.1-1).mod(Settings.heightOfBoard)
        case .South:
            newElement.0 = first.0
            newElement.1 = (first.1+1).mod(Settings.heightOfBoard)
        case .West:
            newElement.0 = (first.0-1).mod(Settings.widthOfBoard)
            newElement.1 = first.1
        case .East:
            newElement.0 = (first.0+1).mod(Settings.widthOfBoard)
            newElement.1 = first.1
        }
        if !collision {
            shape.removeLast()
        } else {
            for index in 0..<food.count{
                if food[index].0 == shape[0].0 && food[index].1 == shape[0].1{
                    food.removeAtIndex(index)
                    break
                }
            }
        }
        shape.insert(newElement, atIndex: 0)
    }
    func turn(site: Site){
        switch site {
        case Site.Right:
            dirOfMovement = Direction(rawValue: (dirOfMovement.hashValue-1).mod(Direction.count))!
        case Site.Left:
            dirOfMovement = Direction(rawValue: (dirOfMovement.hashValue+1).mod(Direction.count))!
        }
    }
    private func addFood(){
        if moveCounter >= Settings.foodAddingTime {
            moveCounter = 0
            addFoodToArr()
        }
        moveCounter += 1
    }
    private func addFoodToArr(){
        var possition: (Int,Int)
        repeat{
            possition.0 = Int(arc4random_uniform(UInt32(Settings.widthOfBoard)))
            possition.1 = Int(arc4random_uniform(UInt32(Settings.heightOfBoard)))
        } while shapeContains(possition)
        food.append(possition)
    }
    /*
        because tuple is not equatable and i want to compare tuples (Int,Int)
     */
    private func shapeContains(possition: (Int,Int)) -> Bool {
        for index in shape{
            if index.0 == possition.0 && index.1 == possition.1{
                return true
            }
        }
        return false
    }
    private func detectCollisions() -> Bool{
        for index in 0..<food.count{
            if food[index].0 == shape[0].0 && food[index].1 == shape[0].1{
                score += 1
                return true
            }
        }
        return false
    }// think about adding 2 classes with food and snake
}






