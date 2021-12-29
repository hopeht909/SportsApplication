//
//  SportTableViewController.swift
//  SportsApplication
//
//  Created by admin on 25/05/1443 AH.
//

import UIKit
import CoreData

class SportTableViewController: UITableViewController, imageDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    
    @IBOutlet weak var addButton: UIButton!
    var sport: [Sport] = []
    var selectedSport: Sport?
    var imagefromCell: SportCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSports()
    }
    
    // MARK: - CoreData
    
    func fetchSports() {
        do {
            sport = try context.fetch(Sport.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source And Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sport.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SportCell", for: indexPath) as! SportCell
        let item = sport[indexPath.row]
        
        cell.lblSportName.text = item.name
        cell.passData(imageData: item.image)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playersVC = storyboard?.instantiateViewController(withIdentifier: "PlayerTableViewController") as! PlayerTableViewController
        playersVC.sport = sport[indexPath.row]
        
        self.navigationController?.pushViewController(playersVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Sport", message: "Edit Sport", preferredStyle: .alert)
        let sport = sport[indexPath.row]
        
        alert.addTextField(configurationHandler: nil)
        let textField = alert.textFields![0]
        textField.placeholder = "Sport Name"
        textField.text = sport.name
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            sport.name = textField.text
            self.saveContext()
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = sport[indexPath.row]
        context.delete(item)
        fetchSports()
        saveContext()
        
    }
    
    // MARK: - Alert
    
    @IBAction func addSportAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Sport", message: "Add a new Sport", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let textField = alert.textFields![0]
        textField.placeholder = "Sport Name"
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {_ in
            
            let sport = Sport(context: self.context)
            sport.name = textField.text
            self.saveContext()
            self.fetchSports()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setImage(with sportCell: SportCell){
        let sportIndexPath = tableView.indexPath(for: sportCell)?.row ?? 0
            selectedSport = sport[sportIndexPath]
             importPicture()
    }
    
    //MARK: - Import Picture
    func importPicture() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}
//MARK: - Picker Extension
extension SportTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            selectedSport?.image = image.pngData()
            
             saveContext()
            self.tableView.reloadData()
        }
        imagefromCell?.addButton.setTitle("Change Phtot", for: .normal)
            picker.dismiss(animated: true, completion: nil)
        
    }
}
