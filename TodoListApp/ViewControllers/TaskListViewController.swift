//
//  ViewController.swift
//  TodoListApp
//
//  Created by Evgeniy Maksimov on 19.08.2024.
//

import UIKit


final class TaskListViewController: UITableViewController {
    
    private var taskList: [ToDoTask] = []
    private let cellID = "task"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func addNewTask() {
        showAlert(withTitle: "Добавить задание", andMessage: "Описание")
    }
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        cell.contentConfiguration = content
        return cell
    }
    
    private func fetchData() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let fetchRequest = ToDoTask.fetchRequest()
        
        do {
            taskList = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
 
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            saveTask(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New task"
        }
        present(alert, animated: true)
    }
    
    private func saveTask(_ taskName: String) {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let task = ToDoTask(context: appDelegate.persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        appDelegate.saveContext()
    }
}


    //MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        
        // Создаем объект конфигурации
        let navBarApearance = UINavigationBarAppearance()
        
        navBarApearance.backgroundColor = UIColor.mIlkBlue
        navBarApearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarApearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.standardAppearance = navBarApearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApearance
        
        // Добавляем кнопку
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
    }
}

#Preview {
    TaskListViewController()
}
