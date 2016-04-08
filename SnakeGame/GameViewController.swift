//
//  ViewController.swift
//  SnakeGame
//
//  Created by Axel Nowaczyk on 07.04.2016.
//  Copyright © 2016 Axel Nowaczyk. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameView: UIView!
    let snakeGame   = SnakeGame()
    var cells       = [[UIView]]()
    
    var cellSize: CGSize{
        let width   = gameView.bounds.size.width / CGFloat(Settings.widthOfBoard)
        let height  = gameView.bounds.size.height / CGFloat(Settings.heightOfBoard)
        return CGSize(width: width, height: height)
    }
    private func createCells(){
        for width in 0..<Settings.widthOfBoard{
            var col = [UIView]()
            for height in 0..<Settings.heightOfBoard{
                let frame = CGRect(origin: CGPoint(x: CGFloat(width)*cellSize.width, y: CGFloat(height)*cellSize.height),size: cellSize)
                
                let cellView = UIView(frame: frame)

                col.append(cellView)
                gameView.addSubview(cellView)
            }
            cells.append(col)
        }
    }
    private func colorBoard(){
        for x in 0..<cells.count{
            for y in 0..<cells[x].count{
                cells[x][y].backgroundColor = UIColor.greenColor()
            }
        }
    }
    private func colorFood(){
        for i in snakeGame.food{
            cells[i.0][i.1].backgroundColor = UIColor.redColor()
        }
    }
    private func colorSnake(){
        for i in snakeGame.shape{
            cells[i.0][i.1].backgroundColor = UIColor.blackColor()
        }
    }

    func oneLoop(){
        snakeGame.move()
        update()
        if snakeGame.snakeBitesHimself{
            timer.invalidate()
        }
    }
    private func update(){
        colorBoard()
        colorSnake()
        colorFood()
    }
    private struct SwipeGestures{
        static let right    = 1
        static let left     = 2
    }
    @IBAction func swipeGesture(sender: UISwipeGestureRecognizer) {
        switch Int(sender.direction.rawValue) {
        case SwipeGestures.right:
            snakeGame.turn(Site.Right)
        case SwipeGestures.left:
            snakeGame.turn(Site.Left)
        default: break
        }
    }
    private var timer: NSTimer = NSTimer()
    private func gameLoop(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0/Double(Settings.speed+1), target: self, selector: #selector(GameViewController.oneLoop), userInfo: nil, repeats: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createCells()
        update()
        gameLoop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}