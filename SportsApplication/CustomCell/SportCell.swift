//
//  SportCell.swift
//  SportsApplication
//
//  Created by admin on 25/05/1443 AH.
//

import UIKit
protocol imageDelegate: AnyObject{
    func setImage(with sportCell: SportCell)
}

class SportCell: UITableViewCell {

    var delegate: imageDelegate?
    
    @IBOutlet weak var lblSportName: UILabel!
    @IBOutlet weak var sportImage: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func passData(imageData :Data?){
           if let imageData = imageData {
               sportImage.image = UIImage(data: imageData)
           }
       }

    @IBAction func addImageAction(_ sender: UIButton) {
        delegate?.setImage(with: self)
        print("Clicked")
    }
}

