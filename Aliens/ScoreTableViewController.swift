//
//  MainTableViewController.swift
//  Aliens
//
//  Created by Oleksandr Bardashevskyi on 3/18/19.
//  Copyright © 2019 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit
import CoreData

class ScoreTableViewController: UITableViewController {
    
    var arrayOfPlayers = [NewPlayer]()
    var context: NSManagedObjectContext!
    var isMainViewController = false
    var lastPlayer: NewPlayer?
    
    //MARK: - Init for dismiss
    func initWhithMainController(isMain: Bool) -> ScoreTableViewController {
        isMainViewController = isMain
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "space")
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.view.bounds
        self.tableView.backgroundView = imageView
        self.title = "Leaders👑👑👑"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        
        arrayOfPlayers = getData()
        
        self.tableView.reloadData()
    }
    //MARK: - doneAction
    @objc func doneAction() {
        if isMainViewController == true {
            dismiss(animated: true, completion: nil)
        } else {
            present(MainViewController(), animated: true, completion: nil)
        }
    }
    
    //MARK: - Get CoreData Data
    func getData() -> [NewPlayer] {
        var array = [NewPlayer]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                fatalError("appdelegate error")
        }
        context = appDelegate.persistentContainer.viewContext
        do {
            array = try context.fetch(NewPlayer.fetchRequest())
        } catch let error as NSError {
            print("Could not load data: \(error)")
        }
        lastPlayer = array.last
        return array.sorted{$0.score > $1.score}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPlayers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        let player = arrayOfPlayers[indexPath.row]
        cell?.textLabel?.textColor = .white
        cell?.detailTextLabel?.textColor = .white
        if player == lastPlayer {
            UIView.transition(with: (cell?.textLabel)!, duration: 2, options: [.transitionCrossDissolve], animations: {
                cell?.textLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }, completion: nil)
        }
        
        cell?.textLabel?.text = player.name
        cell?.backgroundColor = nil
        cell?.detailTextLabel?.text = String(player.score)
        
        return cell!
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
