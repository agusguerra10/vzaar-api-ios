//
//  PlaylistTableViewCell.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 26/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

protocol PlaylistTableViewCellDelegate {
    func deletePlaylist(playlistId: Int)
    func updatePlaylist(playlistId: Int, currentTitleText: String)
}

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: PlaylistTableViewCellDelegate?
    var playlistId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDeleteButton(){
        deleteButton.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
    }
    
    func setUpdateButton(){
        updateButton.addTarget(self, action: #selector(updateAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func deleteAction(sender: UIButton){
        guard let playlistId = playlistId else { return }
        delegate?.deletePlaylist(playlistId: playlistId)
    }

    @objc func updateAction(sender: UIButton){
        guard let playlistId = playlistId , let text = playlistLabel.text else { return }
        delegate?.updatePlaylist(playlistId: playlistId, currentTitleText: text)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
