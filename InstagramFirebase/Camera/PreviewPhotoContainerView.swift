//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by renks on 26/10/2019.
//  Copyright © 2019 Renald Shchetinin. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave() {
        print("Handling save...")
        
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library", err)
                return
            }
            print("Successfully saved image to libraby")
            
            DispatchQueue.main.async {
                
                let savedLabel = UILabel()
                savedLabel.text = "Saved Succsessfully"
                savedLabel.textColor = .white
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textAlignment = .center
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                
                //animating the label
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }) { (completed) in
                    
                    //completed
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }) { (_) in
                        
                        savedLabel.removeFromSuperview()
                        
                    }
                }
            }
        }
    }
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
