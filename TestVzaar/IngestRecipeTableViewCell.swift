//
//  VzaarIngestRecipeTableViewCell.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

protocol IngestRecipeTableViewCellDelegate {
    func deleteIngestRecipe(ingestRecipeId: Int)
    func updateIngestRecipe(ingestRecipeId: Int, currentIngestRecipeText: String)
}

class IngestRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var ingestRecipeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    var ingestRecipeId: Int?
    var delegate: IngestRecipeTableViewCellDelegate?
    
    func setDeleteButton(){
        deleteButton.addTarget(self, action: #selector(deleteAction), for: UIControlEvents.touchUpInside)
    }
    
    func setUpdateButton(){
        updateButton.addTarget(self, action: #selector(updateAction), for: UIControlEvents.touchUpInside)
    }
    
    func deleteAction(sender: UIButton){
        guard let ingestRecipeId = ingestRecipeId else { return }
        delegate?.deleteIngestRecipe(ingestRecipeId: ingestRecipeId)
    }
    
    func updateAction(sender: UIButton){
        guard let ingestRecipeId = ingestRecipeId, let text = ingestRecipeLabel.text else { return }
        delegate?.updateIngestRecipe(ingestRecipeId: ingestRecipeId, currentIngestRecipeText: text)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
