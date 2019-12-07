//
//  LoadingView.swift
//  TestVzaar
//
//  Created by Andreas Bagias on 24/05/2017.
//  Copyright © 2017 Andreas Bagias. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    var loadingIndicatorView: UIActivityIndicatorView!
    var blurView: UIView!
    var effectView: UIVisualEffectView!
    
    var percentageLabel: UILabel!
    var cancelButton: UIButton!
    var whiteView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.blurView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.blurView.alpha = 0.6
        self.blurView.backgroundColor = UIColor.white
        self.addSubview(self.blurView)
        
        whiteView = UIView(frame: CGRect(x: 0, y: frame.size.height/2-60, width: frame.size.width, height: 120))
        whiteView.backgroundColor = UIColor.white
        whiteView.isHidden = true
        addSubview(whiteView)
        
        loadingIndicatorView = UIActivityIndicatorView(frame: CGRect(x: frame.size.width/2-20, y: frame.size.height/2-20, width: 40, height: 40))
        loadingIndicatorView.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicatorView.color = UIColor.black
        loadingIndicatorView.startAnimating()
        addSubview(loadingIndicatorView)
        
        percentageLabel = UILabel(frame: CGRect(x: frame.size.width/2-30, y: frame.size.height/2-20-40, width: 60, height: 40))
        percentageLabel.textColor = UIColor.black
        percentageLabel.textAlignment = NSTextAlignment.center
        percentageLabel.isHidden = true
        addSubview(percentageLabel)
        
        cancelButton = UIButton(frame: CGRect(x: frame.size.width/2-50, y: frame.size.height/2+20, width: 100, height: 30))
        cancelButton.setTitle("Cancel", for: UIControl.State.normal)
        cancelButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        cancelButton.isHidden = true
        addSubview(cancelButton)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
