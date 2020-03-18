//
//  TransferViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 1/21/20.
//  Copyright © 2020 Thomas Kellough. All rights reserved.
//

import AVFoundation
import UIKit

extension UIPickerView {
    /// Sets a custom layer for the specified picker view
    func setLayer() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
    }
}

class TransferViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var picker: UIPickerView!
    var pickerData = [[String]]()
    var playerOneName: String = ""
    var playerTwoName: String = ""
    var playerOneLabel: UILabel!
    var playerTwoLabel: UILabel!
    var transferScore: UITextField!
    var transferSound: AVAudioPlayer?
    var players: [String] = []
    var playerScores: [String: Int] = [:]
    var log: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadUserDefaults()
        
        if players.isEmpty {
            let ac = UIAlertController(title: "Oops", message: "You need to add some players to the game!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            ac.addAction(cancel)
            present(ac, animated: true)
            
            let emptyDataSet = [""]
            pickerData.append(emptyDataSet)
            pickerData.append(emptyDataSet)
        } else {
            pickerData.removeAll()
            pickerData.append(players)
            pickerData.append(players)
        }
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        loadInterface()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        if let playersArray = defaults.object(forKey: "savedPlayersArray") as? [String] {
            if let playerScoresDict = defaults.object(forKey: "savedPlayerScoresDict") as? [String: Int] {
                if let logArray = defaults.object(forKey: "logArray") as? [String] {
                    players = playersArray
                    playerScores = playerScoresDict
                    log = logArray
                }
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(players, forKey: "savedPlayersArray")
        defaults.set(playerScores, forKey: "savedPlayerScoresDict")
        defaults.set(log, forKey: "logArray")
    }
    
    func loadInterface() {
        if players.isEmpty {
            return
        }
        let player = players[0]
        guard let score = playerScores[player] else { return }
        
        picker = UIPickerView()
        picker.setLayer()
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.picker.delegate = self
        self.picker.dataSource = self
        self.view.addSubview(picker)
        
        playerOneLabel = UILabel()
        playerOneLabel.text = "\(player): \(String(score))"
        playerOneLabel.textAlignment = .center
        playerOneLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerOneLabel)
        
        playerTwoLabel = UILabel()
        playerTwoLabel.text = "\(player): \(String(score))"
        playerTwoLabel.textAlignment = .center
        playerTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerTwoLabel)
        
        transferScore = UITextField()
        transferScore.font = .preferredFont(forTextStyle: .largeTitle)
        transferScore.keyboardType = .numberPad
        transferScore.layer.borderColor = UIColor.systemGray.cgColor
        transferScore.layer.cornerRadius = 8
        transferScore.layer.borderWidth = 1
        transferScore.placeholder = "Enter amount"
        transferScore.textAlignment = .center
        transferScore.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(transferScore)
        
        let transferBtn = UIButton()
        transferBtn.addTarget(self, action: #selector(transferBtnTapped), for: .touchUpInside)
        transferBtn.setBackgroundColor(color: .systemBlue, forState: .normal)
        transferBtn.setLayer()
        transferBtn.setTitle("Transfer", for: .normal)
        transferBtn.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        transferBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(transferBtn)

        NSLayoutConstraint.activate([
            playerOneLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            playerOneLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            playerOneLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.bounds.width / 2),
            
            playerTwoLabel.topAnchor.constraint(equalTo: playerOneLabel.topAnchor),
            playerTwoLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.bounds.width / 2),
            playerTwoLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            transferScore.topAnchor.constraint(equalTo: playerOneLabel.bottomAnchor, constant: 50),
            transferScore.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -30),
            transferScore.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            picker.topAnchor.constraint(equalTo: transferScore.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            transferBtn.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
            transferBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40),
            transferBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            transferBtn.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func transferBtnTapped() {
        if transferScore.text == "" {
            let ac = UIAlertController(title: "Oops!", message: "You didn't enter a number!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            ac.addAction(cancel)
            present(ac, animated: true)
        }
        if playerOneName == playerTwoName {
            let ac = UIAlertController(title: "Oops!", message: "You can't send yourself points!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)

            ac.addAction(cancel)
            present(ac, animated: true)
        } else {
            guard let scoreInput = transferScore.text else { return  }
            guard let scoreInputInt = Int(scoreInput) else { return }
            playerScores[playerOneName]! -= scoreInputInt
            playerScores[playerTwoName]! += scoreInputInt
            let message = "\(playerOneName) transferred \(scoreInput) points to \(playerTwoName)!"
            log.insert(message, at: 0)
            playSound()
            if let scoreOne = playerScores[playerOneName] {
                playerOneLabel.text = "\(playerOneName): \(String(scoreOne))"
            }
            if let scoreTwo = playerScores[playerTwoName] {
                playerTwoLabel.text = "\(playerTwoName): \(String(scoreTwo))"
            }
            save()
            view.endEditing(true)
        }
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "transfer.wav", ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            transferSound = try AVAudioPlayer(contentsOf: url)
            transferSound?.play()
        } catch {
            // File could not load
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let playerOneIndex = pickerView.selectedRow(inComponent: 0)
        let playerTwoIndex = pickerView.selectedRow(inComponent: 1)
        playerOneName = pickerData[0][playerOneIndex]
        playerTwoName = pickerData[1][playerTwoIndex]
        if let scoreOne = playerScores[playerOneName] {
            playerOneLabel.text = "\(playerOneName): \(String(scoreOne))"
        }
        if let scoreTwo = playerScores[playerTwoName] {
            playerTwoLabel.text = "\(playerTwoName): \(String(scoreTwo))"
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[0].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }

}
