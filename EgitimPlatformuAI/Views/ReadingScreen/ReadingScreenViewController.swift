//
//  ReadingScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 28.04.2025.
//

import Foundation
import UIKit

final class ReadingScreenViewController: UIViewController {
    var viewModel: ReadingScreenViewModel?
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let cellNib = UINib(nibName: "ReadingTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ReadingCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
        self.navigationController?.isNavigationBarHidden = false
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }

}

extension ReadingScreenViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingTableViewCell
        cell.answerText.text = "cevap \(indexPath.row)"
        return cell
    }
    
    
}

extension ReadingScreenViewController: UITableViewDelegate{
    
}
