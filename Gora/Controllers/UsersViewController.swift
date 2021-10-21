//
//  ViewController.swift
//  Gora
//
//  Created by Антон Усов on 19.10.2021.
//

import UIKit

class UsersViewController: UIViewController {
    
    private var users: [User] = []
    
    private let userManager = UserManager()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchUsers() {
        userManager.getUsers { [weak self] (newUsers) in
            self?.users = newUsers
            self?.tableView.reloadData()
        }
    }
    
}


extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let userName = users[indexPath.row].name
        cell.textLabel?.text = userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let vc = PhotosViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
