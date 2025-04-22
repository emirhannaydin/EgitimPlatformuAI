//
//  ViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.01.2025.
//
import UIKit

final class MainScreenViewController: UIViewController{
    
    @IBOutlet weak var nameContainerView: CustomNameContainer!
    @IBOutlet weak var collectionView: UICollectionView!
    private var hamburgerMenuManager: HamburgerMenuManager!
    var viewModel: MainScreenViewModel?
    var screenName: [String] = ["Home", "Profile", "Lessons", "Deneme", "Deneme"]
    var screenLogo: [String] = ["house", "person.circle", "book","lock","lock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
        nameContainerView.configureView(nameLabel: "emirhanaydin_1600@hotmail.com", statusLabel: "Online", image: "person.fill")
        setCollectionView()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeScreenCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeScreenCollectionViewCell.identifier)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
}

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        screenName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeScreenCollectionViewCell.identifier, for: indexPath) as! HomeScreenCollectionViewCell
        cell.imageView.image = UIImage(systemName: screenLogo[indexPath.row])
        cell.labelText.text = screenName[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        
        return CGSize(width: size, height: size)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected\(indexPath.row)")
    }
    
}


    
