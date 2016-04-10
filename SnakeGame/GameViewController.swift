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
    var snakeGame   = SnakeGame()
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
    private func drawBoard(){
        for x in 0..<cells.count{
            for y in 0..<cells[x].count{
                cells[x][y].backgroundColor = UIColor.greenColor()
            }
        }
    }
    private func drawFood(){
        for i in 0..<snakeGame.foodCount{
            let food = snakeGame.getFood(i)
            cells[food.x][food.y].backgroundColor = UIColor.redColor()
        }
    }
    private func drawSnake(){
        for i in 0..<snakeGame.snakeShapeCount{
            let snakePart = snakeGame.getSnakeShape(i)
            cells[snakePart.x][snakePart.y].backgroundColor = UIColor.blackColor()
        }
    }
    private struct Segues{
        static let menu = "goMenu"
    }
    func oneLoop(){
        snakeGame.move()
        update()
        if snakeGame.snakeBitesHimself{
            timer.invalidate()
            var msg = "Game Over \n your result: \(SnakeGame.score)"
            if SnakeGame.score > Settings.bestScore{
                msg+="\n This is the best Score EVER"
                Settings.bestScore = SnakeGame.score
                Settings.save(Settings.Saveable.BestScore)
            }
            let alert = UIAlertController(title: "", message: msg
                , preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Menu",
                            style: UIAlertActionStyle.Default,handler: { action in
                            self.performSegueWithIdentifier(Segues.menu, sender: self) }))
            alert.addAction(UIAlertAction(title: "Play Again",
                            style: UIAlertActionStyle.Default,handler: statrNewGame))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func statrNewGame(alert: UIAlertAction!){
        snakeGame = SnakeGame()
        update()
        gameLoop()
    }
    func continueGame(alert: UIAlertAction!){
        gameLoop()
    }
    private func update(){
        drawBoard()
        drawSnake()
        drawFood()
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
    @IBAction func pauseGameTap(sender: AnyObject) {
        timer.invalidate()
        let alert = UIAlertController(title: "Pause", message: nil
            , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Menu",
            style: UIAlertActionStyle.Default,handler: { action in
                self.performSegueWithIdentifier(Segues.menu, sender: self) }))
        alert.addAction(UIAlertAction(title: "Continue",
            style: UIAlertActionStyle.Default,handler: continueGame))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}