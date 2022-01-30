//
//  ImageDetailViewController.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var imageURL: URL!
    var imageTitle: String = ""
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let imageDetailView = ImageDetailView(
            view: view,
            fileURL: imageURL,
            imageTitle: imageTitle
        )
        
        view.addSubview(imageDetailView)
        
        NSLayoutConstraint.activate([
            imageDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0),
            imageDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0.0),
            imageDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
        ])
    }
}
