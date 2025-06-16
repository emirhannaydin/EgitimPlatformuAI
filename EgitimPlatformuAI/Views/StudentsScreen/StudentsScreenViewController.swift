//
//  StudentsScreenViewController.swift
//  EgitimPlatformuAI
//
//  Created by Emirhan Aydın on 16.06.2025.
//

import UIKit

final class StudentsScreenViewController: UIViewController{
    
    
    @IBOutlet var totalStudents: UILabel!
    @IBOutlet var backButton: CustomBackButtonView!
    @IBOutlet var tableView: UITableView!
    var viewModel: StudentsScreenViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        getStudents()
    }
    
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StudentsScreenTableViewCell.nib(), forCellReuseIdentifier: StudentsScreenTableViewCell.identifier)

        tableView.separatorStyle = .none
        tableView.separatorColor = .winter
        
    }
    
    private func getStudents(){
        viewModel?.getStudents { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.setTableView()
                    self.setTotalStudents()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setTotalStudents() {
        let totalStudentsCount = viewModel.students.count
        let totalCountString = String(totalStudentsCount)
        let fullText = "Total Students = \(totalCountString)"
        
        let attributedText = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: totalCountString)
        
        attributedText.addAttribute(.foregroundColor, value: UIColor.summer, range: range)
        
        totalStudents.attributedText = attributedText
    }

    
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension StudentsScreenViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentsScreenTableViewCell.identifier) as! StudentsScreenTableViewCell
        
        cell.nameLabel.text = viewModel!.students[indexPath.row].name
        cell.emailLabel.text = viewModel!.students[indexPath.row].email
        

        viewModel?.fetchProfileImage(for: viewModel.students[indexPath.row]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        if let image = UIImage(data: imageData) {
                            cell.profileImageView.image = image
                        }
                    case .failure:
                        cell.profileImageView.image = UIImage(systemName: "person.circle")
                        cell.profileImageView.tintColor = .systemGray
                    }
                }
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(viewModel.students[indexPath.row].name)
        
        let coordinator = StudentsScreenInfoCoordinator.getInstance()
        let studentId = viewModel.students[indexPath.row].id
        
        let viewModel = StudentsScreenInfoViewModel(coordinator: coordinator, studentId: studentId)
        
        coordinator.start(with: viewModel)
        ApplicationCoordinator.getInstance().pushFromTeacherScreenCoordinatorAndVariables(coordinator, hidesBottomBar: true)
    }
}
