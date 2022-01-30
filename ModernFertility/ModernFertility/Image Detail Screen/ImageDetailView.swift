//
//  ImageDetailView.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import UIKit
import AlamofireImage

class ImageDetailView: UIStackView {
    
    // MARK: - Properties
    
    var fileURL: URL!
    var imageTitle: String!
    var parentView: UIView!
    
    // MARK: - Initializer
    
    init(view: UIView, fileURL: URL, imageTitle: String) {
        super.init(frame: .zero)
        
        self.fileURL = fileURL
        self.imageTitle = imageTitle
        self.parentView = view
        
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        let imageView = self.setupImageView()
        let imageTitle = self.setupImageTitle()
        
        self.axis = .vertical
        self.spacing = 10
        self.alignment = .center
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(imageTitle)
    }
    
    // MARK: - Setup
    
    private func setupImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        imageView.af.setImage(
            withURL: fileURL,
            placeholderImage: UIImage(named: "placeHolderImage")
        )
        
        return imageView
    }
    
    private func setupImageTitle() -> UILabel {
        let imageTitleLabel = UILabel()
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageTitleLabel.text = imageTitle
        imageTitleLabel.font = UIFont.systemFont(ofSize: 17)
        imageTitleLabel.textAlignment = .center
        imageTitleLabel.numberOfLines = 0
        imageTitleLabel.lineBreakMode = .byWordWrapping
        imageTitleLabel.sizeToFit()
        
        return imageTitleLabel
    }
}
