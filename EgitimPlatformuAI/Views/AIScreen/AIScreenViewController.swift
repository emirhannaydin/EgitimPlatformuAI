//
//  AIScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import UIKit
import SwiftOpenAI

final class AIScreenViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    private var hamburgerMenuManager: HamburgerMenuManager!
    
    var viewModel: AIScreenViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Setup
private extension AIScreenViewController {
    func setup() {
        setupUI()
        setupHamburgerMenu()
        setupNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(AIChatTableViewCell.self, forCellReuseIdentifier: AIChatTableViewCell.identifier)
        
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.returnKeyType = .send
        textField.layer.cornerRadius = 10
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.backDarkBlue.cgColor
    }
    
    func setupHamburgerMenu() {
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAIMessageUpdated), name: .aiMessageUpdated, object: nil)
    }
    
}



// MARK: - Actions
private extension AIScreenViewController {
    @objc func handleAIMessageUpdated() {
        tableView.reloadData()
        scrollToBottom()
        textField.isEnabled = true
        textFieldEditingChanged(textField)
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        sendMessage()
    }
    
    func sendMessage() {
        guard let message = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else { return }
        
        textField.isEnabled = false
        sendButton.isEnabled = false
        textField.text = ""
        
        viewModel.sendMessage(message)
    }
    
    
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        sendButton.isEnabled = !trimmedText.isEmpty
    }
    
    func scrollToBottom() {
        guard !viewModel.messages.isEmpty else { return }
        let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - TableView
extension AIScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AIChatTableViewCell.identifier, for: indexPath) as! AIChatTableViewCell
        cell.configure(with: viewModel.messages[indexPath.row])
        return cell
    }
}

// MARK: - TextField
extension AIScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

// MARK: - Keyboard
private extension AIScreenViewController{
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


