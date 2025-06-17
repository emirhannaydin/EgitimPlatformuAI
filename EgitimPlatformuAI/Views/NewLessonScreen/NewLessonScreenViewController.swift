//
//  NewLessonScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Başar Noyan on 12.06.2025.
//

import Foundation
import UIKit
import Lottie

final class NewLessonScreenViewController: UIViewController {
    var viewModel: NewLessonScreenViewModel!
    @IBOutlet var levelTextField: UITextField!
    let pickerView = UIPickerView()
    let options = ["A1", "A2", "B1", "B2", "C1", "C2"]
    @IBOutlet var lottieView: LottieAnimationView!
    @IBOutlet var lessonNameTextField: UITextField!
    var selectedClassIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewModel.courseClasses)
        setupLevelTextField()
        setLottieAnimation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let presentingVC = presentingViewController {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
                tapGesture.cancelsTouchesInView = false
                presentingVC.view.addGestureRecognizer(tapGesture)
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .questionScreenDismissed, object: nil)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupLevelTextField(){
        pickerView.delegate = self
        pickerView.dataSource = self
        levelTextField.inputView = pickerView
        levelTextField.delegate = self
        levelTextField.tintColor = .clear
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(doneTapped))

        toolbar.setItems([flexibleSpace, doneButton, flexibleSpace], animated: false)
        levelTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneTapped() {
        levelTextField.resignFirstResponder()
    }
    
    private func setLottieAnimation(){
        let animation = LottieAnimation.named("bookAnimation")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.play()
    }
    
    @IBAction func addLessonButtonTapped(_ sender: Any) {
        guard
            let index = selectedClassIndex,
            index < viewModel.courseClasses.count,
            let content = lessonNameTextField.text,
            !content.isEmpty
        else {
            showAlert(title: "Error", message: "Please fill all fields", lottieName: "error")
            return
        }

        guard let selectedClassId = viewModel.courseClasses.first(where: { $0.level == index })?.id else {
            return
        }

        viewModel.addLesson(classId: selectedClassId, content: content) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(title: "Success", message: "Lesson added successfully", lottieName: "success"){
                        self?.dismiss(animated: true)
                    }
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription, lottieName: "error")
                }
            }
        }
        

    }

    @objc func handleBackgroundTap() {
        self.dismiss(animated: true)
    }

    
    
}

extension NewLessonScreenViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        levelTextField.text = options[row]
        selectedClassIndex = row
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
