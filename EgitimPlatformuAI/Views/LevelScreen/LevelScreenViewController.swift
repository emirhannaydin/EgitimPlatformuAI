//
//  WritingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class LevelScreenViewController: UIViewController {
    var viewModel: LevelScreenViewModel?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "LevelTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LevelCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        print("continue button tapped")
    }
    
    
}

extension LevelScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelCell", for: indexPath) as! LevelTableViewCell
        return cell
    }
    
    
}

extension LevelScreenViewController: UITableViewDelegate{
    
}
