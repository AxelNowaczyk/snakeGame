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
        let width   = gameView.bounds.size.width / CGFloat(SettingsManager.boardWidth)
        let height  = gameView.bounds.size.height / CGFloat(SettingsManager.boardHeight)
        return CGSize(width: width, height: height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    fileprivate func createCells(){
        for width in 0..<SettingsManager.boardWidth {
            var col = [UIView]()
            for height in 0..<SettingsManager.boardHeight {
                let frame = CGRect(origin: CGPoint(x: CGFloat(width)*cellSize.width, y: CGFloat(height)*cellSize.height),size: cellSize)
                
                let cellView = UIView(frame: frame)

                col.append(cellView)
                gameView.addSubview(cellView)
            }
            cells.append(col)
        }
    }
    
    fileprivate func drawBoard(){
        for x in 0..<cells.count{
            for y in 0..<cells[x].count{
                cells[x][y].backgroundColor = .green
            }
        }
    }
    fileprivate func drawFood(){
        for i in 0..<snakeGame.foodCount{
            let food = snakeGame.getFood(i)
            cells[food.x][food.y].backgroundColor = .red
        }
    }
    fileprivate func drawSnake(){
        for i in 0..<snakeGame.snakeShapeCount{
            let snakePart = snakeGame.getSnakeShape(i)
            cells[snakePart.x][snakePart.y].backgroundColor = .black
        }
    }

    func oneLoop(){
        snakeGame.move()
        update()
        if snakeGame.snakeBitesHimself {
            timer.invalidate()
            var msg = "Game Over \n your result: \(SnakeGame.score)"
            if SnakeGame.score > SettingsManager.bestScore {
                msg+="\n This is the best Score EVER"
                SettingsManager.bestScore = SnakeGame.score
            }
            SnakeGame.score = 0
            let alert = UIAlertController(title: "", message: msg
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Menu",
                            style: UIAlertActionStyle.default,handler: { action in
                            let _ = self.navigationController?.popToRootViewController(animated: true) }))
            alert.addAction(UIAlertAction(title: "Play Again",
                            style: UIAlertActionStyle.default,handler: statrNewGame))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    func statrNewGame(_ alert: UIAlertAction!){
        snakeGame = SnakeGame()
        update()
        gameLoop()
    }
    func continueGame(_ alert: UIAlertAction!){
        gameLoop()
    }
    fileprivate func update(){
        drawBoard()
        drawSnake()
        drawFood()
    }
    fileprivate enum SwipeTypes: Int {
        case right  = 1
        case left   = 2
    }
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        guard let swipeType = SwipeTypes(rawValue: Int(sender.direction.rawValue)) else {
            print("Unknown swipe")
            return
        }
        
        switch swipeType {
        case .right:
            snakeGame.turn(Site.right)
        case .left:
            snakeGame.turn(Site.left)
        }
    }
    fileprivate var timer: Timer = Timer()
    fileprivate func gameLoop(){
        timer = Timer.scheduledTimer(timeInterval: 1.0/Double(SettingsManager.speed+1), target: self, selector: #selector(GameViewController.oneLoop), userInfo: nil, repeats: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createCells()
        update()
        gameLoop()
    }
    
    @IBAction func pauseGameTap(_ sender: AnyObject) {
        timer.invalidate()
        let alert = UIAlertController(title: "Pause", message: nil
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Menu",
            style: UIAlertActionStyle.default,handler: {
                _ in
                let _ = self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Continue",
            style: UIAlertActionStyle.default,handler: continueGame))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
