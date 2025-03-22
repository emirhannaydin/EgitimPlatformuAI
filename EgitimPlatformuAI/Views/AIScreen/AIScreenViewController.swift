//
//  AIScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 21.03.2025.
//

import UIKit
import SwiftOpenAI

class AIScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    private var aiAPIManager = AIAPIManager()
    private var messages: [MessageChatGPT] = []
    var viewModel: AIScreenViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view
        tableView.dataSource = self
        tableView.register(AIChatTableViewCell.nib(), forCellReuseIdentifier: AIChatTableViewCell.identifier)
        textField.returnKeyType = .send
        textField.delegate = self
        
        messages = aiAPIManager.messages
        tableView.reloadData()
        
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AIChatTableViewCell.identifier) as! AIChatTableViewCell
        cell.textLabel?.text = messages[indexPath.row].text
        cell.textLabel?.numberOfLines = 0

        return cell
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let message = textField.text, !message.isEmpty else {
            return true
        }

        // Send the user's message
        sendMessage(message)
        
        return true
    }

    // MARK: - Send Message

    private func sendMessage(_ message: String) {
        textField.isHidden = true
        messages.append(MessageChatGPT(text: message, role: .user))
        textField.text = ""
        
        Task {
            await aiAPIManager.send(message: message)
            
            DispatchQueue.main.async {
                self.messages = self.aiAPIManager.messages
                self.tableView.reloadData()
                self.textField.isHidden = false
            }
        }
    }
}

