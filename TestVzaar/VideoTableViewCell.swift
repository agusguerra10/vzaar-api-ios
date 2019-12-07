//
//  VzaarVideoTableViewCell.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 24/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

protocol VideoTableViewCellDelegate {
    func deleteVideo(videoId: Int)
    func updateVideo(videoId: Int, currentTitleText: String)
    func addPosterButtonAction(videoId: Int)
    func subtitlesButtonAction(videoId: Int)
}

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var deleteVideoButton: UIButton!
    @IBOutlet weak var updateVideoButton: UIButton!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var subtitlesButton: UIButton!
    
    var delegate: VideoTableViewCellDelegate?
    
    var videoId: Int?

    func setVideoStateLabel(state: String?){
        guard let state = state else { return }
        stateLabel.text = state
        
        if state == "ready"{
            stateLabel.textColor = UIColor.green
        }else{
            stateLabel.textColor = UIColor.red
        }
    }
    
    func setImage(withUrl urlString: String?){
        videoImageView.image = nil
        guard let urlString = urlString else { return }
        
        let dataTask = URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.videoImageView.image = UIImage(data: data!)
            })
            
        })
        dataTask.resume()
    }
    
    func setDeleteButton(){
        deleteVideoButton.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func deleteAction(sender: UIButton){
        guard let videoId = videoId else { return }
        delegate?.deleteVideo(videoId: videoId)
    }
    
    func setUpdateButton(){
        updateVideoButton.addTarget(self, action: #selector(updateAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func updateAction(sender: UIButton){
        guard let videoId = videoId, let text = titleLabel.text else { return }
        delegate?.updateVideo(videoId: videoId, currentTitleText: text)
    }
    
    func setPosterButton(){
        addPosterButton.addTarget(self, action: #selector(addPosterAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func addPosterAction(sender: UIButton){
        guard let videoId = videoId else { return }
        delegate?.addPosterButtonAction(videoId: videoId)
    }
    
    func setSubtitlesButton(){
        subtitlesButton.addTarget(self, action: #selector(subtitlesAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func subtitlesAction(sender: UIButton){
        guard let videoId = videoId else { return }
        delegate?.subtitlesButtonAction(videoId: videoId)
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
