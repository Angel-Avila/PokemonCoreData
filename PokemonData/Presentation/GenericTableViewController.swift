//
//  GenericTableViewController.swift
//  CoreDataTests
//
//  Created by Angel Avila on 4/5/19.
//  Copyright © 2019 Regiztra. All rights reserved.
//

import UIKit

class GenericCell<U>: UITableViewCell {
    var item: U!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class StringCell: GenericCell<String> {
    override var item: String! {
        didSet {
            guard let label = textLabel, let item = item else { return }
            label.font = UIFont.regular
            label.textColor = .darkGray
            label.text = "\(item)"
        }
    }
}

class GenericTableViewController<T: GenericCell<U>, U>: UITableViewController {
    
    var items = [U]()
    let cellId = "id"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(T.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GenericCell<U>
        
        cell.item = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
