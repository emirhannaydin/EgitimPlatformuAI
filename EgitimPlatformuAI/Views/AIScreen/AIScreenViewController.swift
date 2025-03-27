//
//  AIScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import UIKit
import SwiftOpenAI

class AIScreenViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private var hamburgerMenuManager: HamburgerMenuManager!
    
    var viewModel: AIScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        style()
        setHamburgerMenu()
        aiChatNotifications()
        
    }
}
extension AIScreenViewController{
    private func style(){
        setTableView()
        setTextField()
        setTextView()
    }
    private func setHamburgerMenu(){
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
    }
    private func scrollToBottom() {
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
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.returnKeyType = .send
        textField.layer.cornerRadius = 10
        textField.borderStyle = .none

    }
    private func setTextView(){
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    private func setGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gesture)
    }
    @objc func handleTap() {
            view.endEditing(true)
        }
    @objc private func handleAIMessageStarted() {
        textField.isEnabled = false
    }

    @IBAction private func sendButtonTapped(_ sender: UIButton) {
        handleTextAction(for: sender)
    }
    
    @objc private func handleAIMessageCompleted() {
        if let lastMessage = viewModel.messages.last, lastMessage.role == .system, !lastMessage.text.isEmpty {
            textField.isEnabled = true
        }
    }
    private func handleTextAction(for sender: Any) {
        guard let message = textField.text, !message.isEmpty else { return }
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if let textField = sender as? UITextField {
           
            textField.isEnabled = false
            textField.text = ""
            
            viewModel.sendMessage(trimmedMessage) { [weak self] in
                self?.tableView.reloadData()
                self?.scrollToBottom()
                textField.isEnabled = true
            }
            
        } else if let button = sender as? UIButton {
            guard let textField = self.textField else { return }
            textField.isEnabled = false
            textField.text = ""
            
            viewModel.sendMessage(trimmedMessage) { [weak self] in
                self?.tableView.reloadData()
                self?.scrollToBottom()
                textField.isEnabled = true
            }
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
        handleTextAction(for: textField)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            
            return true
        }
}

