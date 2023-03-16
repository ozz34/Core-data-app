//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Иван Худяков on 30.09.2022.
//

import CoreData
import UIKit

// MARK: - TaskViewControllerDelegate
protocol TaskViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let cellID = "task"
    private var taskList: [Task] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }

    // MARK: - Actions
    @objc private func addNewTask() {
        let newTaskVC = TaskViewController()
        newTaskVC.delegate = self
        present(newTaskVC, animated: true)
    }

    // MARK: - Helpers
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true

        let navBarAppearance = UINavigationBarAppearance()

        navBarAppearance.configureWithOpaqueBackground()

        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navBarAppearance.backgroundColor = UIColor(
            red: 21 / 255,
            green: 101 / 255,
            blue: 192 / 255,
            alpha: 194 / 255
        )

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }

    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
            print("failed")
        }
    }
}

// MARK: - TableViewDataSource
extension TaskListViewController {
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        taskList.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - TaskViewControllerDelegate

extension TaskListViewController: TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}
