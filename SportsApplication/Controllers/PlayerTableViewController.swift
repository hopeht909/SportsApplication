//
//  PlayerTableViewController.swift
//  SportsApplication
//
//  Created by admin on 25/05/1443 AH.
//

import UIKit
import CoreData

class PlayerTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext

    var sport: Sport!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sport.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addPlayer))
    }
    
    // MARK: - Table view data source And Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sport.players?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        
        let item = sport.players?[indexPath.row] as! Player
        
        if let name = item.name, let age = item.age, let height = item.height{
            cell.textLabel?.text = "\(name) - Age:\(age), Height: \(height)"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let player = sport.players?[indexPath.row] as! Player
        let alert = UIAlertController(title: "Edit Player", message: "Edit Player", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        
        let tfPlayerName = alert.textFields![0]
        tfPlayerName.text = player.name
        let tfPlayerAge = alert.textFields![1]
        tfPlayerAge.text = player.age
        let tfPlayerHeight = alert.textFields![2]
        tfPlayerHeight.text = player.height
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            
            player.name = tfPlayerName.text
            player.age = tfPlayerAge.text
            player.height = tfPlayerHeight.text
            
            self.saveContext()
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let player = sport.players?[indexPath.row] as! Player
        sport.removeFromPlayers(player)
        saveContext()
        tableView.reloadData()
    }
    
    
   //MARK: - Add Player
    @objc func addPlayer() {
        let alert = UIAlertController(title: "New Player", message: "Add a new Player", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        
        let tfPlayerName = alert.textFields![0]
        tfPlayerName.placeholder = "Enter Name"
        let tfPlayerAge = alert.textFields![1]
        tfPlayerAge.placeholder = "Enter Age"
        let tfPlayerHeight = alert.textFields![2]
        tfPlayerHeight.placeholder = "Enter Height"
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            if let sport = self.sport{

                let player = Player(context: self.context)
            player.name = tfPlayerName.text
            player.age = tfPlayerAge.text
            player.height = tfPlayerHeight.text
                sport.addToPlayers(player)
            }
            self.saveContext()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}


