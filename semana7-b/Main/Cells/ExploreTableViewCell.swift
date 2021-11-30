//
//  ExploreTableViewCell.swift
//  semana7-b
//
//  Created by Linder Hassinger on 6/10/21.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCountRating: UILabel!
    @IBOutlet weak var explorImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Esta funcion es como un viewDidLoad
        explorImage.layer.cornerRadius = 15
        explorImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
