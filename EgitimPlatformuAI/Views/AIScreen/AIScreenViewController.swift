//
//  AIScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import UIKit
import SwiftOpenAI

class AIScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private var hamburgerMenuManager: HamburgerMenuManager!
    
    var viewModel: AIScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        setTableView()
        setTextField()
        aiChatNotifications()
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
        
    }
    func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    private func aiChatNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleAIMessageStarted), name: Notification.Name("AIMessageStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAIMessageCompleted), name: Notification.Name("AIMessageCompleted"), object: nil)
    }
    private func setTableView(){
        tableView.dataSource = self
        tableView.register(AIChatTableViewCell.self, forCellReuseIdentifier: AIChatTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    private func setTextField(){
        textField.autocorrectionType = .no
        textField.returnKeyType = .send
        textField.delegate = self
    }
    @objc func handleAIMessageStarted() {
        textField.isEnabled = false
    }

    @objc func handleAIMessageCompleted() {
        if let lastMessage = viewModel.messages.last, lastMessage.role == .system, !lastMessage.text.isEmpty {
            textField.isEnabled = true
        }
    }
    
}
// MARK: - TableView
extension AIScreenViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AIChatTableViewCell.identifier) as! AIChatTableViewCell
        cell.configure(with: viewModel.messages[indexPath.row])
        return cell
    }
    
}
// MARK: - TextField
extension AIScreenViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = textField.text, !message.isEmpty else { return true }
        
        textField.isEnabled = false
        textField.text = ""
        
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.sendMessage(trimmedMessage) { [weak self] in
            
            self?.tableView.reloadData()
            self?.scrollToBottom()
            self?.textField.isEnabled = true
        }
        
        return true
    }
}

