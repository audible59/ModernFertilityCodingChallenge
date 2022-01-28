//
//  ViewController.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    let cellNibName: String = "FormInputButtonTableViewCell"
    let cellReuseIdentifier: String = "HomeScreenTableViewCellIdentifier"
    
    var imageList: [Images]?
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveImages()
    }
    
    // MARK: - Networking
    
    private func retrieveImages() {
        ImagesNetworking.getImages { [weak self] (images, resultStatus) in
            guard let strongSelf = self else { return }
            
            // If there are valid images and there are one or more images
            if let imageList = images as? [Images] {
                strongSelf.imageList = imageList
                strongSelf.tableView.reloadData()
            } else {
                // TODO: Handle the scenario where there are no Images
            }
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If there are users available return the count otherwise we set the number of rows to 0
        return imageList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
