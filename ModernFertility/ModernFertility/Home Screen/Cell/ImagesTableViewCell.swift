//
//  ImagesTableViewCell.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    // MARK: - Cell Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
