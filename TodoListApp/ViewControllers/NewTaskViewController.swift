//
//  NewTaskViewController.swift
//  TodoListApp
//
//  Created by Evgeniy Maksimov on 20.08.2024.
//

import UIKit

protocol ButtonFactory {
    // Метод, который создает кнопку
    
    func createButton() -> UIButton
}

final class FilledButtonFactory: ButtonFactory {
    
    let title: String
    
    let color: UIColor
    
    let action: UIAction
    
    init(title: String, color: UIColor, action: UIAction) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    func createButton() -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        let button = UIButton(
            configuration: buttonConfiguration,
            primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

final class NewTaskViewController: UIViewController {
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
       let filledButtonFactory = FilledButtonFactory(
        title: "Save task",
        color: .mIlkBlue,
        action: UIAction { [unowned self] _ in
            save()
        }
    )
        return filledButtonFactory.createButton()
    }()
    
    private lazy var cancelButton: UIButton = {
     let filledbuttonFactory = FilledButtonFactory(
        title: "Cancel",
        color: .milkRed,
        action: UIAction { [unowned self] _ in
            dismiss(animated: true)
        }
    )
        return filledbuttonFactory.createButton()
    }()
    
    weak var delegate: NewTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextField, saveButton, cancelButton)
        setConstreints()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstreints() {
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 25),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 13),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    private func save() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let task = ToDoTask(context: appDelegate.persistentContainer.viewContext)
        task.title = taskTextField.text
        appDelegate.saveContext()
        delegate?.reloadData()
        dismiss(animated: true)
    }
}

#Preview {
    NewTaskViewController()
}
