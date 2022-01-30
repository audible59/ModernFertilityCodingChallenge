//
//  ViewController.swift
//  ModernFertility
//
//  Created by Kevin E. Rafferty II on 1/28/22.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeScreenViewController: UIViewController {
    
    // MARK: - ENUM
    
    enum HomeScreenViewControllerConstants {
        static let screenTitle = NSLocalizedString(
            "Modern Fertility",
            comment: "The title of the Home screen."
        )
    }
    
    // MARK: - Properties
    
    let cellNibName: String = "ImagesTableViewCell"
    let cellReuseIdentifier: String = "HomeScreenTableViewCellIdentifier"
    
    var imageList: [Images]?
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveImages()
        self.setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        self.title = HomeScreenViewControllerConstants.screenTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil),
                           forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - Networking
    
    private func retrieveImages() {
        ImagesNetworking.getImages { [weak self] (images, resultStatus) in
            guard let strongSelf = self else { return }
            
            switch resultStatus {
            case .success:
                // If there are valid images and there are one or more images
                if let imageList = images as? [Images] {
                    strongSelf.imageList = imageList
                    strongSelf.tableView.reloadData()
                } else {
                    // TODO: Handle the scenario where there are no Images
                }
            case .failure:
                // TODO: Handle the Failure scenario
                break
            case .error:
                // TODO: Handle the Error scenario
                break
            }
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // If there are users available return the count otherwise we set the number of rows to 0
        return imageList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ImagesTableViewCell else {
            return UITableViewCell()
        }
        
        if let imageDetails = imageList?[indexPath.section] {
            cell.detailLabel.text = imageDetails.title
            
            if let url = URL(string: imageDetails.thumbnailUrl) {
                cell.thumbnailImage.af.setImage(
                    withURL: url,
                    placeholderImage: UIImage(named: "placeHolderImage")
                )
            } else {
                cell.thumbnailImage.image = UIImage(named: "placeHolderImage")
            }
        }

        return cell
    }
    
    // MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        
        if let imageDetailViewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailStoryboardID") as? ImageDetailViewController {
            guard let imageDetail = imageList?[indexPath.section] else {
                return
            }
            
            imageDetailViewController.imageURL = URL(string: imageDetail.url)
            imageDetailViewController.imageTitle = imageDetail.title
            
            self.present(imageDetailViewController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
