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
        setup()
        
    }
}
// MARK: - Setup
private extension AIScreenViewController {
    
    func setup() {
        setupUI()
        setupHamburgerMenu()
        setupNotifications()
        setupTextFieldTarget()
    }
    
    func setupUI() {
        setupTableView()
        setupTextField()
        setupTextView()
        setupDismissKeyboardGesture()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(AIChatTableViewCell.self, forCellReuseIdentifier: AIChatTableViewCell.identifier)
    }
    
    func setupTextField() {
        textField.delegate = self
        textField.autocorrectionType = .no
        textField.returnKeyType = .send
        textField.layer.cornerRadius = 10
        textField.borderStyle = .none
    }
    
    func setupTextFieldTarget() {
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    func setupTextView() {
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupHamburgerMenu() {
        hamburgerMenuManager = HamburgerMenuManager(viewController: self)
        hamburgerMenuManager.setNavigationBar()
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAIMessageStarted), name: Notification.Name("AIMessageStarted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAIMessageCompleted), name: Notification.Name("AIMessageCompleted"), object: nil)
    }
    
    func setupDismissKeyboardGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
}

// MARK: - Actions
private extension AIScreenViewController {
    
    @objc func handleAIMessageStarted() {
        textField.isEnabled = false
        sendButton.isEnabled = false
    }
    
    @objc func handleAIMessageCompleted() {
        if let lastMessage = viewModel.messages.last, lastMessage.role == .system, !lastMessage.text.isEmpty {
            textField.isEnabled = true
            textFieldEditingChanged(textField)
        }
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
        
        viewModel.sendMessage(message) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.scrollToBottom()
            self.textField.isEnabled = true
            self.textFieldEditingChanged(self.textField)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

