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
    static var bestScore       = -1
    static var difficultyLvl   = 0 // range <0;5>
    static let heightOfBoard   = 40
    static let widthOfBoard    = 20
    static let foodAddingTime  = 20
    public enum Saveable: String{
        case Speed = "speed"
        case BestScore = "bestScore"
        case DiffLvl = "difficultyLvl"
    }
    static func save(what: Saveable){
        let ud = NSUserDefaults.standardUserDefaults()
        switch what {
        case .Speed:
            ud.setValue("\(Settings.speed)", forKey: Saveable.Speed.rawValue)
        case .BestScore:
            ud.setValue("\(Settings.bestScore)", forKey: Saveable.BestScore.rawValue)
        case .DiffLvl:
            ud.setValue("\(Settings.difficultyLvl)", forKey: Saveable.DiffLvl.rawValue)
        }
    }
    static func load(){
        let ud = NSUserDefaults.standardUserDefaults()

        if let speed = ud.stringForKey(Saveable.Speed.rawValue){
            Settings.speed = Int(speed)!
        }
        if let bestScore = ud.stringForKey(Saveable.BestScore.rawValue){
            Settings.bestScore = Int(bestScore)!
        }
        if let diffLvl = ud.stringForKey(Saveable.DiffLvl.rawValue){
            Settings.difficultyLvl = Int(diffLvl)!
        }
    }
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
class Square: Equatable{
    let x:Int
    let y:Int
    init(x:Int,y:Int){
        self.x = x
        self.y = y
    }
}
func ==(lhs: Square,rhs: Square) -> Bool{
    if lhs.x == rhs.x && lhs.y == rhs.y{
        return true
    }
    return false
}
class Snake{
    var dirOfMovement = Direction.North
    var shape = [Square]()
    init(){
        shape.append(Square(x: Settings.widthOfBoard/2,y: Settings.heightOfBoard/2-1))
        shape.append(Square(x: Settings.widthOfBoard/2,y: Settings.heightOfBoard/2))
        shape.append(Square(x: Settings.widthOfBoard/2,y: Settings.heightOfBoard/2+1))
    }
    var bitesHimself: Bool{
        for shp in 0..<shape.count{
            for shp2 in (shp+1)..<shape.count{
                if shape[shp].x == shape[shp2].x && shape[shp].y == shape[shp2].y {
                    return true
                }
            }
        }
        return false
    }
    func move(collision: Bool, inout foodOnBoard: FoodOnBoard){
        let first = shape.first!
        var newElement: Square
        switch dirOfMovement {
        case .North:
            newElement = Square(x: first.x,y: (first.y-1).mod(Settings.heightOfBoard))
        case .South:
            newElement = Square(x: first.x,y: (first.y+1).mod(Settings.heightOfBoard))
        case .West:
            newElement = Square(x: (first.x-1).mod(Settings.widthOfBoard),y: first.y)
        case .East:
            newElement = Square(x: (first.x+1).mod(Settings.widthOfBoard),y: first.y)
        }
        if !collision {
            shape.removeLast()
        } else {
            for index in 0..<foodOnBoard.food.count{
                if foodOnBoard.food[index].x == shape[0].x && foodOnBoard.food[index].y == shape[0].y{
                    foodOnBoard.food.removeAtIndex(index)
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
    func hasBodyOn(square:Square) -> Bool {
        return shape.contains(square)
    }
}
class FoodOnBoard{
    var food = [Square]()
    private var moveCounter = 0
    func addFood(snake: Snake){
        if moveCounter >= Settings.foodAddingTime {
            moveCounter = 0
            addFoodToArr(snake)
        }
        moveCounter += 1
    }
    private func addFoodToArr(snake: Snake){
        var possition: Square
        repeat{
            possition = Square(x: Int(arc4random_uniform(UInt32(Settings.widthOfBoard))),
                               y: Int(arc4random_uniform(UInt32(Settings.heightOfBoard))))

        } while snake.hasBodyOn(possition)
        food.append(possition)
    }
    private func detectCollisions(snake: Snake) -> Bool{
        for index in 0..<food.count{
            if food[index].x == snake.shape[0].x && food[index].y == snake.shape[0].y{
                SnakeGame.score += 1
                return true
            }
        }
        return false
    }
}
class SnakeGame {
    static var score = 0
    
    private var snake = Snake()
    private var foodOnBoard = FoodOnBoard()
    var snakeBitesHimself: Bool{
        return snake.bitesHimself
    }
    var foodCount: Int{
        return foodOnBoard.food.count
    }
    var snakeShapeCount: Int{
        return snake.shape.count
    }
    func getFood(index: Int) -> Square{
        return foodOnBoard.food[index]
    }
    func getSnakeShape(index: Int) -> Square{
        return snake.shape[index]
    }
    func move(){
        foodOnBoard.addFood(snake)
        snake.move(foodOnBoard.detectCollisions(snake), foodOnBoard: &foodOnBoard)
    }
    func turn(site: Site){
        snake.turn(site)
    }
}






