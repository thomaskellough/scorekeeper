//
//  LogTableViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 1/25/20.
//  Copyright © 2020 Thomas Kellough. All rights reserved.
//

import UIKit

class LogTableViewController: UITableViewController {

    var log: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserDefaults()
        self.tableView.reloadData()
    }
    
    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        if let logArray = defaults.object(forKey: "logArray") as? [String] {
           log = logArray
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return log.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        
        cell.detailTextLabel?.text = dateString
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = log[indexPath.row]
        
        return cell
    }

}
