//
//  MainViewController.swift
//  Aliens
//
//  Created by Oleksandr Bardashevskyi on 3/18/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let startButton = UIButton()
    let leaderBoardButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView()
        imageView.image = UIImage(named: "space")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        startButtonCreate()
        leaderBoardButtonCreate()
    }
    
    //MARK: - StartButton & leaderBoardButton Create
    func startButtonCreate() {
        startButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        startButton.center = self.view.center
        startButton.setTitle("StarT", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 5
        startButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        startButton.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        startButton.layer.shadowOpacity = 5
        startButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
        
        self.view.addSubview(startButton)
    }
    func leaderBoardButtonCreate() {
        leaderBoardButton.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        leaderBoardButton.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.maxY - 100)
        leaderBoardButton.setTitle("Leader Board", for: .normal)
        leaderBoardButton.setTitleColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), for: .normal)
        leaderBoardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        leaderBoardButton.layer.borderWidth = 2
        leaderBoardButton.layer.borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        leaderBoardButton.layer.cornerRadius = 5
        leaderBoardButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        leaderBoardButton.layer.shadowColor = UIColor.white.cgColor
        leaderBoardButton.layer.shadowOpacity = 1
        leaderBoardButton.addTarget(self, action: #selector(leaderBoardButtonAction), for: .touchUpInside)
        
        self.view.addSubview(leaderBoardButton)
    }
    
    //MARK: - Actions
    @objc func startButtonAction() {
        let vc = GameViewController()
        present(vc, animated: true, completion: nil)
    }
    @objc func leaderBoardButtonAction() {
        let vc = ScoreTableViewController()
        let root = UINavigationController(rootViewController: vc.initWhithMainController(isMain: true))
        present(root, animated: true, completion: nil)
    }
    

}
