//
//  SnakeGame.swift
//  SnakeGame
//
//  Created by Axel Nowaczyk on 07.04.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import Foundation


public enum Direction: Int{
    case north
    case west
    case south
    case east

    static var count: Int { return Direction.east.hashValue + 1}
}
private extension Int{
    func mod(_ modNumber: Int) -> Int{
        return (self+modNumber)%modNumber
    }
}
public enum Site{
    case right
    case left
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
    var dirOfMovement = Direction.north
    var shape = [Square]()
    init(){
        for height in (SettingsManager.boardHeight/2-1)...(SettingsManager.boardHeight/2+1){
            shape.append(Square(x: SettingsManager.boardWidth/2,y: height))
        }
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
    func move(_ collision: Bool, foodOnBoard: inout FoodOnBoard){
        let first = shape.first!
        var newElement: Square
        switch dirOfMovement {
        case .north:
            newElement = Square(x: first.x,y: (first.y-1).mod(SettingsManager.boardHeight))
        case .south:
            newElement = Square(x: first.x,y: (first.y+1).mod(SettingsManager.boardHeight))
        case .west:
            newElement = Square(x: (first.x-1).mod(SettingsManager.boardWidth),y: first.y)
        case .east:
            newElement = Square(x: (first.x+1).mod(SettingsManager.boardWidth),y: first.y)
        }
        if !collision {
            shape.removeLast()
        } else {
            for index in 0..<foodOnBoard.food.count{
                if foodOnBoard.food[index].x == shape[0].x && foodOnBoard.food[index].y == shape[0].y{
                    foodOnBoard.food.remove(at: index)
                    break
                }
            }
        }
        shape.insert(newElement, at: 0)
    }
    func turn(_ site: Site){
        switch site {
        case Site.right:
            dirOfMovement = Direction(rawValue: (dirOfMovement.hashValue-1).mod(Direction.count))!
        case Site.left:
            dirOfMovement = Direction(rawValue: (dirOfMovement.hashValue+1).mod(Direction.count))!
        }
    }
    func hasBodyOn(_ square:Square) -> Bool {
        return shape.contains(square)
    }
}
class FoodOnBoard{
    var food = [Square]()
    fileprivate var moveCounter = 0
    func addFood(_ snake: Snake){
        if moveCounter >= SettingsManager.foodTime {
            moveCounter = 0
            addFoodToArr(snake)
        }
        moveCounter += 1
    }
    fileprivate func addFoodToArr(_ snake: Snake){
        var possition: Square
        repeat{
            possition = Square(x: Int(arc4random_uniform(UInt32(SettingsManager.boardWidth))),
                               y: Int(arc4random_uniform(UInt32(SettingsManager.boardHeight))))

        } while snake.hasBodyOn(possition)
        food.append(possition)
    }
    fileprivate func detectCollisions(_ snake: Snake) -> Bool{
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
    
    fileprivate var snake = Snake()
    fileprivate var foodOnBoard = FoodOnBoard()
    var snakeBitesHimself: Bool{
        return snake.bitesHimself
    }
    var foodCount: Int{
        return foodOnBoard.food.count
    }
    var snakeShapeCount: Int{
        return snake.shape.count
    }
    func getFood(_ index: Int) -> Square{
        return foodOnBoard.food[index]
    }
    func getSnakeShape(_ index: Int) -> Square{
        return snake.shape[index]
    }
    func move(){
        foodOnBoard.addFood(snake)
        snake.move(foodOnBoard.detectCollisions(snake), foodOnBoard: &foodOnBoard)
    }
    func turn(_ site: Site){
        snake.turn(site)
    }
}






