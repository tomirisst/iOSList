//
//  SecondViewController.swift
//  lecture3DemoSimpleApp
//
//  Created by admin on 06.01.2021.
//

import UIKit

protocol SecondViewControllerDelegate {
    func removeItem(_ id: Int)
    func editItem(_ id: Int)
}

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var arr = [ToDoItem]()
    let cellId = "TableViewCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        testDataConfigure()
    }
    
    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSecondViewController" {
            let editViewController = segue.destination as! EditViewController
            editViewController.callback = { text in self.arr[].title.text = text }
        }
    }*/
    
    @IBAction func pushAddAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "New item title"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Due date"
        }
        
        let alertAction1 = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
        
        let alertAction2 = UIAlertAction(title: "Add", style: .default) { [self] (alert) in
            let newTitle = alertController.textFields![0].text
            let newDate = alertController.textFields![1].text
            add(newTitle: newTitle!, newDate: newDate!)
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main page"
        self.configureTableView()
    }

    
    func testDataConfigure(){
        arr.append(ToDoItem(id: 1, title: "first", deadLine: "20.12.2021"))
        arr.append(ToDoItem(id: 2, title: "second", deadLine: "22.12.2021"))
        arr.append(ToDoItem(id: 3, title: "third", deadLine: "12.08.2021"))
        arr.append(ToDoItem(id: 4, title: "uno", deadLine: "05.07.2021"))
        arr.append(ToDoItem(id: 5, title: "dos", deadLine: "29.12.2021"))
    }
    
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func add(newTitle: String, newDate: String) {
        arr.append(ToDoItem(id: arr.count+1, title: newTitle, deadLine: newDate))
        
        tableView.reloadData()
    }
    
}

extension SecondViewController: SecondViewControllerDelegate{
    func removeItem(_ id: Int) {
        arr.remove(at: id)
    }
    
   
    
    func editItem(_ id: Int) {
        //arr[id].title = finalTitle
        //arr[id].deadLine = finalDate
        saveData()
    }
    
    func saveData(){
        UserDefaults.standard.set(arr, forKey: "arrDataKey")
        UserDefaults.standard.synchronize()
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        let item = arr[indexPath.row]
//        cell.delegate = self
        cell.id = item.id ?? 0
        cell.titleLabel.text = item.title
        cell.subTitleLabel.text = item.deadLine
        
        cell.removeCallback = { id in
            self.removeItem(id)
        }
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.removeItem(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            print("Press")
        }
        
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
        /*if editingStyle == UITableViewCell.EditingStyle.delete {
            removeItem(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }*/
    }*/
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action,view, completionHandler) in
                self.arr.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }

        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action,view, completionHandler) in
            let vc = self.storyboard?.instantiateViewController(identifier: "EditViewController") as! EditViewController
            vc.delegate = self
            vc.title1 = self.arr[indexPath.row].title ?? ""
            vc.date1 = self.arr[indexPath.row].deadLine ?? ""
            vc.callBack = {
                title, deadline in
                let id = self.arr[indexPath.row].id
                self.arr[indexPath.row] = ToDoItem(id: id, title: title, deadLine: deadline)
                tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            completionHandler(true)
            
        }
        
        editAction.backgroundColor = UIColor.blue
        let configuration = UISwipeActionsConfiguration(actions: [delete, editAction])
        return configuration
    }
    
}
