//
//  TaskViewController.swift
//  CoreDataDemo
//
//  Created by Иван Худяков on 30.09.2022.
//

import CoreData
import UIKit

class TaskViewController: UIViewController {
    // MARK: - Properties
    var delegate: TaskViewControllerDelegate?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private lazy var taskTextField: UITextField = {
        let textField = UITextField()

        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect

        return textField
    }()

    private lazy var saveButton: UIButton = createButton(with: "Save Task",
                                                         and: UIColor(
                                                             red: 21 / 255,
                                                             green: 101 / 255,
                                                             blue: 192 / 255,
                                                             alpha: 194 / 255
                                                         ),
                                                         action: UIAction { _ in
                                                             self.save()
                                                         })

    private lazy var cancelButton: UIButton = createButton(with: "Cancel",
                                                           and: .systemRed,
                                                           action: UIAction { _ in
                                                               self.dismiss(animated: true)
                                                           })
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup(subviews: taskTextField, saveButton, cancelButton)
        setConstraints()
    }

    // MARK: - Helpers
    private func setup(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }

    private func createButton(with title: String, and color: UIColor, action: UIAction) -> UIButton {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.buttonSize = .medium

        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)

        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)

        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }

    private func setConstraints() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ]
        )

        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ]
        )

        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ]
        )
    }

    private func save() {
        let task = Task(context: context)
        task.name = taskTextField.text
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
        delegate?.reloadData()
        dismiss(animated: true)
    }
}
