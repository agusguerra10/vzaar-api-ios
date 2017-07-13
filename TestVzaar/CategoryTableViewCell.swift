//
//  VzaarCategoryTableViewCell.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 25/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate {
    func deleteCategory(categoryId: Int)
    func updateCategory(categoryId: Int, currentTitleText: String)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var categoryIdLabel: UILabel!
    
    var delegate: CategoryTableViewCellDelegate?
    var categoryId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpdateButton(){
        updateButton.isHidden = false
        updateButton.addTarget(self, action: #selector(updateAction), for: UIControlEvents.touchUpInside)
    }
    
    func setDeleteButton(){
        deleteButton.isHidden = false
        deleteButton.addTarget(self, action: #selector(deleteAction), for: UIControlEvents.touchUpInside)
    }
    
    func updateAction(sender: UIButton){
        guard let categoryId = categoryId, let text = categoryLabel.text else { return }
        delegate?.updateCategory(categoryId: categoryId, currentTitleText: text)
    }
    
    func deleteAction(sender: UIButton){
        guard let categoryId = categoryId else { return }
        delegate?.deleteCategory(categoryId: categoryId)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
