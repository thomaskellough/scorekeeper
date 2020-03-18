//
//  DetailTableViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 12/31/19.
//  Copyright © 2019 Thomas Kellough. All rights reserved.
//

import AVFoundation
import UIKit


/*
 This is the default view. To acheive this in storyboard select the tab bar controller and select the identity inspector.
 Then you can add a new key path of selectedIndex: Number: 1 (or whichever tab you want to show on launch)
*/

class DetailTableViewController: UITableViewController {
    var players: [String] = []
    var playerScores: [String: Int] = [:]
    var playerColors: [String: UIColor] = [:]
    var playerColorsIndex: [String: Int] = [:]
    var log: [String] = []
    
    var playSound: AVAudioPlayer?
    var colorArray: [UIColor] = [
        UIColor.red.withAlphaComponent(0.9),
        UIColor.orange.withAlphaComponent(0.9),
        UIColor.yellow.withAlphaComponent(0.9),
        UIColor.green.withAlphaComponent(0.9),
        UIColor.blue.withAlphaComponent(0.9),
        UIColor.cyan.withAlphaComponent(0.9),
        UIColor.magenta.withAlphaComponent(0.9),
        UIColor.purple.withAlphaComponent(0.9)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Scorekeeper"

        let addPlayerBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlayer))
        let restart = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        navigationItem.rightBarButtonItems = [addPlayerBtn, restart]
        
        let newGameBtn = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        navigationItem.leftBarButtonItem = newGameBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserDefaults()
        self.tableView.reloadData()
    }
    
    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        if let playersArray = defaults.object(forKey: "savedPlayersArray") as? [String] {
            if let playerScoresDict = defaults.object(forKey: "savedPlayerScoresDict") as? [String: Int] {
                if let logArray = defaults.object(forKey: "logArray") as? [String] {
                    if let colorsIndex = defaults.object(forKey: "savedPlayerColorsIndex") as? [String: Int] {
                        players = playersArray
                        playerScores = playerScoresDict
                        playerColorsIndex = colorsIndex
                        log = logArray
                    }
                }
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(players, forKey: "savedPlayersArray")
        defaults.set(playerScores, forKey: "savedPlayerScoresDict")
        defaults.set(playerColorsIndex, forKey: "savedPlayerColorsIndex")
        defaults.set(log, forKey: "logArray")
    }
    
    func incrementScore(score: Int, player: String) {
        playerScores[player]! += score
        save()
        tableView.reloadData()
    }
    
    func decrementScore(score: Int, player: String) {
        playerScores[player]! -= score
        save()
        tableView.reloadData()
    }
    
    func editScore(score: Int, player: String) {
        playerScores[player] = score
        save()
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        let ac = UIAlertController(title: "Start over?", message: "This will change everyone's current score to 0", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "I'm sure!", style: .default) {
            [weak self] _ in
            for (player, _) in self!.playerScores {
                self?.playerScores[player] = 0
                self?.log.removeAll()
                self?.save()
                self?.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func newGame() {
        let ac = UIAlertController(title: "New game?", message: "This will erase all players from the game. Are you sure you want to do this?", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "I'm sure!", style: .default) {
            [weak self] _ in
            self?.players.removeAll()
            self?.playerScores.removeAll()
            self?.log.removeAll()
            self?.playerColors.removeAll()
            //self!.colors.shuffle()
            self!.save()
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    @objc func addPlayer() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "addPlayerVC") as? AddPlayerViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func playSound(_ type: String) {
        if type == "inc" {
            guard let path = Bundle.main.path(forResource: "pointsUp.wav", ofType: nil) else { return }
            let url = URL(fileURLWithPath: path)
            do {
                playSound = try AVAudioPlayer(contentsOf: url)
                playSound?.play()
            } catch {
                // File could not load
            }
        } else {
            guard let path = Bundle.main.path(forResource: "pointsDown.mp3", ofType: nil) else { return }
            let url = URL(fileURLWithPath: path)
            do {
                playSound = try AVAudioPlayer(contentsOf: url)
                playSound?.play()
            } catch {
                // File could not load
            }
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return players.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let incrementScore = UIContextualAction(style: .normal, title: "Increase") {_,_,_ in
            let player = self.players[indexPath.section]
            self.playerScores[player]! += 1
            let message = "Increased \(player)'s score by 1!"
            self.log.insert(message, at: 0)
            self.playSound("inc")
            self.save()
            tableView.reloadData()
        }
        incrementScore.backgroundColor = UIColor.systemGreen
        incrementScore.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "upArrow")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        
        return UISwipeActionsConfiguration(actions: [incrementScore])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Remove") {_,_,_ in
            let player = self.players[indexPath.section]
            self.players.remove(at: indexPath.section)
            self.playerScores.removeValue(forKey: player)
            let message = "\(player) has left the game!"
            self.log.insert(message, at: 0)
            self.save()
            tableView.reloadData()
        }
        let decrementScore = UIContextualAction(style: .normal, title: "Decrease") {_,_,_ in
            let player = self.players[indexPath.section]
            self.playerScores[player]! -= 1
            let message = "Decreased \(player)'s score by 1!"
            self.log.insert(message, at: 0)
            self.playSound("dec")
            self.save()
            tableView.reloadData()
        }
        delete.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "delete")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        decrementScore.backgroundColor = UIColor.systemBlue
        decrementScore.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "downArrow")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        
        return UISwipeActionsConfiguration(actions: [decrementScore, delete])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "player", for: indexPath)
        let player = players[indexPath.section]
        if let colorIndex = playerColorsIndex[player] {
            let color = colorArray[colorIndex]
            if ([0, 4, 6, 7]).contains(colorIndex) {
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.textColor = .white
            } else {
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.textColor = .black
            }
            cell.backgroundColor = color
            cell.clipsToBounds = true
            cell.detailTextLabel?.text = String(playerScores[player]!)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = player
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let player = players[indexPath.section]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "playerVC") as? PlayerViewController {
            vc.playerName = player
            vc.playerScore = playerScores[player]!
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
