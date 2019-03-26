//
//  ViewController.swift
//  Aliens
//
//  Created by Oleksandr Bardashevskyi on 3/18/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController {
    
    var planetSize: CGFloat = 80
    var count = 0
    var scoreLabel = UILabel()
    var scoreCount = 0
    var myTimer = Timer()
    var timerLabel = UILabel()
    var time = 0
    
    var context: NSManagedObjectContext!
    
    var arrayOfSpaceShips: [String] = {
        var array = [String]()
        for _ in 0..<100 {
            let randomShip = arc4random_uniform(2) % 2
            if randomShip == 0 {
                array.append("ufoBlue")
            } else {
                array.append("ufoYellow")
            }
        }
        return array
    }()
    var bluePlanet: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "blue")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var yellowPlanet: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "yellow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var imageForAnimate: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var firstImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var secondImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.7
        return imageView
    }()
    var thirdImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0.4
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                fatalError("appdelegate error")
        }
        context = appDelegate.persistentContainer.viewContext
        
        //MARK: - set background view
        let imageView = UIImageView()
        imageView.image = UIImage(named: "space")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        //MARK: - Add gesture
        let oneTapGesture = UITapGestureRecognizer(target: self, action: #selector(oneTapFunc))
        oneTapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(oneTapGesture)
        
        myTimer = Timer.scheduledTimer(timeInterval: 1,
                                       target: self,
                                       selector: #selector(timerAction),
                                       userInfo: nil,
                                       repeats: true)
        
        addLabels()
        addSpaceShips()
        addConstraintsForPlanets()
        imageForAnimate.frame = CGRect(x: 0, y: 0, width: planetSize, height: planetSize)
        imageForAnimate.center = self.view.center
        self.view.addSubview(imageForAnimate)
    }
    
    @objc func timerAction() {
        
        if time < 60 {
            time += 1
            timerLabel.text = "Time: \(60 - time)"
        } else {
            timerLabel.text = "Time is over"
            myTimer.invalidate()
            alert()
        }
        
        
    }
    
    //MARK: AddLabels
    func addLabels() {
        scoreLabel.frame = CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.maxY - 100, width: 110, height: 50)
        scoreLabel.text = "Score: \(scoreCount)"
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        timerLabel.frame = scoreLabel.frame
        timerLabel.center = CGPoint(x: self.view.center.x, y: self.view.bounds.minY + 100)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        timerLabel.text = "Time: 60"
        
        self.view.addSubview(scoreLabel)
        self.view.addSubview(timerLabel)
        
    }
    
    //MARK: - PanGestureRecognizer
    @objc func oneTapFunc(tap: UITapGestureRecognizer) {
        let tapLocation = tap.location(in: self.view)
        if count >= arrayOfSpaceShips.count - 3 {
            arrayOfSpaceShips += arrayOfSpaceShips
        }
        //MARK: - BluePlanet
        if tapLocation.x < self.view.bounds.minX + planetSize + 30 && tapLocation.y > self.view.bounds.maxY - planetSize - 30 {
            gameLogic(ufoColor: "ufoBlue", center: self.bluePlanet.center)
        }
        //MARK: - YellowPlanet
        if tapLocation.x > self.view.bounds.maxX - planetSize - 30 && tapLocation.y > self.view.bounds.maxY - planetSize - 30 {
            gameLogic(ufoColor: "ufoYellow", center: self.yellowPlanet.center)
        }
        
        self.view.bringSubviewToFront(yellowPlanet)
        self.view.bringSubviewToFront(bluePlanet)
        scoreLabel.text = "Score: \(scoreCount)"
    }
    
    //MARK: - GameLogic How to change planet
    func gameLogic(ufoColor: String, center: CGPoint) {
        imageForAnimate.layer.removeAllAnimations()
        if arrayOfSpaceShips[count] == ufoColor {
            imageForAnimate.image = UIImage(named: arrayOfSpaceShips[count])
            imageForAnimate.frame = CGRect(x:  self.view.center.x - planetSize/2,
                                           y: self.view.center.y - planetSize/2,
                                           width: planetSize,
                                           height: planetSize)
            count += 1
            firstImageView.image = UIImage(named: arrayOfSpaceShips[count])
            self.view.bringSubviewToFront(firstImageView)
            secondImageView.image = UIImage(named: arrayOfSpaceShips[count + 1])
            thirdImageView.image = UIImage(named: arrayOfSpaceShips[count + 2])
            
            UIView.animate(withDuration: 0.3, animations: {
                self.imageForAnimate.center = center
                self.imageForAnimate.frame = CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10)
                self.view.layer.removeAllAnimations()
            }) { (isFinished) in
                //                self.imageForAnimate.frame = CGRect(x:  self.view.center.x - self.planetSize/2,
                //                                                    y: self.view.center.y - self.planetSize/2,
                //                                                    width: self.planetSize,
                //                                                    height: self.planetSize)
                //                self.imageForAnimate?.removeFromSuperview()
                //                self.imageForAnimate?.image = nil
                //                self.imageForAnimate = nil
            }
            scoreCount += 1
        } else {
            scoreCount -= 1
        }
    }
    
    func addSpaceShips() {
        
        firstImageView.image = UIImage(named: arrayOfSpaceShips[0])
        firstImageView.frame = CGRect(x: 0, y: 0, width: planetSize, height: planetSize)
        firstImageView.center = self.view.center
        self.view.addSubview(firstImageView)
        secondImageView.image = UIImage(named: arrayOfSpaceShips[1])
        secondImageView.frame = CGRect(x: 0, y: 0, width: planetSize - 15, height: planetSize - 15)
        secondImageView.center = CGPoint(x: firstImageView.center.x, y: firstImageView.center.y - 70)
        self.view.addSubview(secondImageView)
        thirdImageView.image = UIImage(named: arrayOfSpaceShips[1])
        thirdImageView.frame = CGRect(x: 0, y: 0, width: planetSize - 30, height: planetSize - 30)
        thirdImageView.center = CGPoint(x: firstImageView.center.x, y: secondImageView.center.y - 60)
        self.view.addSubview(thirdImageView)
    }
    
    //MARK: ConstraintsForPlanets
    func addConstraintsForPlanets() {
        
        self.view.addSubview(bluePlanet)
        self.view.addSubview(yellowPlanet)
        
        bluePlanet.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        bluePlanet.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        bluePlanet.widthAnchor.constraint(equalToConstant: planetSize).isActive = true
        bluePlanet.heightAnchor.constraint(equalToConstant: planetSize).isActive = true
        
        yellowPlanet.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        yellowPlanet.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        yellowPlanet.widthAnchor.constraint(equalToConstant: planetSize).isActive = true
        yellowPlanet.heightAnchor.constraint(equalToConstant: planetSize).isActive = true
    }
    
    //MARK: - AlertHighScore
    func alert() {
        let alertController = UIAlertController(title: "Enter your name:", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let text = alertController.textFields?.first?.text
            self.addScore(name: (text?.isEmpty)! ? "New Player" : text!, score: Int16(self.scoreCount))
            let vc = ScoreTableViewController()
            let root = UINavigationController(rootViewController: vc)
            self.present(root, animated: true, completion: nil)
        }
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Add Data in to core data
    func addScore(name: String, score: Int16) {
        let highScore = NewPlayer(context: context)
        highScore.name = name
        highScore.score = score
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error)
        }
    }
}

