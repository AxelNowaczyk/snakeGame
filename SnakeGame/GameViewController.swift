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
    
    var cells = [UIView]()
    
    var cellSize: CGSize{
        let width   = gameView.bounds.size.width / CGFloat(Settings.widthOfBoard)
        let height  = gameView.bounds.size.height / CGFloat(Settings.heightOfBoard)
        return CGSize(width: width, height: height)
    }
    private func createCells(){
        for width in 0..<Settings.widthOfBoard{
            for height in 0..<Settings.heightOfBoard{
                let frame = CGRect(origin: CGPoint(x: CGFloat(width)*cellSize.width, y: CGFloat(height)*cellSize.height),size: cellSize)
                
                let cellView = UIView(frame: frame)
                cellView.backgroundColor = UIColor.greenColor()
                //                cellView.
                
                gameView.addSubview(cellView)
                cells.append(cellView)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createCells()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}