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
    @IBOutlet var checkButton: UIButton!
    private var readingAnswer = "cevap 1"
    private var selectedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let cellNib = UINib(nibName: "ReadingTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ReadingCell")
        setNotification()
        
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
    
    @IBAction func checkButton(_ sender: Any) {
        self.showLottieLoading()
        guard let selectedIndexPath = tableView.indexPathForSelectedRow,
              let cell = tableView.cellForRow(at: selectedIndexPath) as? ReadingTableViewCell,
              let selectedText = cell.answerText.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        else {
            self.hideLottieLoading()
            self.showAlert(title: "Error", message: "Choose one")
            return
        }

        let correctText = readingAnswer
        print(selectedText)
        print(correctText)
        let aiMessage = """
        The user listened to a word and tried to understand its meaning.
        Correct answer: "\(correctText)"
        User's response: "\(selectedText)"
        
        Please evaluate the response:
        - If the user's choice is correct, clearly confirm it and provide a short, encouraging remark such as "Yes, this is the correct answer. Well done!" End your sentence there.
        - If the answer is incorrect, say something like: "You selected '\(selectedText)', but the correct answer is '\(correctText)'." Avoid saying “wrong.” Then, briefly encourage the user by explaining that careful and focused listening can greatly improve understanding — for example, "With a bit more focus during listening, you'll catch it more easily next time." Do not suggest trying again. Finish your explanation in one sentence.
        """
        viewModel?.sendMessage(aiMessage)
    }

    private func setNotification(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAIFinalMessage),
            name: .aiMessageFinished,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .aiMessageUpdated, object: nil)
    }

    @objc private func handleAIFinalMessage() {
        let message = AIAPIManager.shared.currentMessage.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let popup = AIRobotPopupViewController(message: message)
        DispatchQueue.main.async {
            self.present(popup, animated: true){
                self.hideLottieLoading()
            }
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReadingTableViewCell {
            let selectedText = cell.answerText.text ?? ""
            }
    }
}
