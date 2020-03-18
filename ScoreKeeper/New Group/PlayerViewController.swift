//
//  PlayerViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 1/20/20.
//  Copyright © 2020 Thomas Kellough. All rights reserved.
//

import UIKit

extension UIButton {

  /// Sets the background color to use for the specified button state.
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {

        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)

        UIGraphicsBeginImageContext(minimumSize)

        if let context = UIGraphicsGetCurrentContext() {
          context.setFillColor(color.cgColor)
          context.fill(CGRect(origin: .zero, size: minimumSize))
        }

        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIButton {
    /// Sets a custom layer for the specified button
    func setLayer() {
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 5
    }
}

class PlayerViewController: UIViewController {
    
    var playerLabel: UILabel!
    var playerName: String!
    var playerScore: Int!
    var scoreTextField: UITextField!
    
    weak var delegate: DetailTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInterface()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadInterface() {
        playerLabel = UILabel()
        playerLabel.font = .preferredFont(forTextStyle: .largeTitle)
        playerLabel.text = "\(playerName ?? "Player"): \(String(playerScore))"
        playerLabel.textAlignment = .center
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerLabel)
        
        scoreTextField = UITextField()
        scoreTextField.layer.borderColor = UIColor.systemGray.cgColor
        scoreTextField.layer.borderWidth = 1
        scoreTextField.layer.cornerRadius = 8
        scoreTextField.font = .preferredFont(forTextStyle: .largeTitle)
        scoreTextField.keyboardType = .numberPad
        scoreTextField.placeholder = "Enter amount"
        scoreTextField.textAlignment = .center
        scoreTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreTextField)

        let incBtn = UIButton()
        incBtn.tag = 1
        incBtn.addTarget(self, action: #selector(editScore), for: .touchUpInside)
        incBtn.setBackgroundColor(color: .systemGreen, forState: .normal)
        incBtn.setLayer()
        incBtn.setTitle("+", for: .normal)
        incBtn.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        incBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(incBtn)

        let decBtn = UIButton()
        decBtn.tag = 2
        decBtn.addTarget(self, action: #selector(editScore), for: .touchUpInside)
        decBtn.setBackgroundColor(color: .systemBlue, forState: .normal)
        decBtn.setLayer()
        decBtn.setTitle("-", for: .normal)
        decBtn.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        decBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(decBtn)

        let editBtn = UIButton()
        editBtn.tag = 3
        editBtn.addTarget(self, action: #selector(editScore), for: .touchUpInside)
        editBtn.setBackgroundColor(color: .systemOrange, forState: .normal)
        editBtn.setLayer()
        editBtn.setTitle("Edit Score", for: .normal)
        editBtn.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editBtn)
        
        let deleteBtn = UIButton()
        deleteBtn.addTarget(self, action: #selector(deletePlayer), for: .touchUpInside)
        deleteBtn.setBackgroundColor(color: .systemRed, forState: .normal)
        deleteBtn.setLayer()
        deleteBtn.setTitle("Delete Player", for: .normal)
        deleteBtn.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(deleteBtn)

        NSLayoutConstraint.activate([
            
            playerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            playerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            scoreTextField.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 20),
            scoreTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -30),
            scoreTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            incBtn.topAnchor.constraint(equalTo: scoreTextField.bottomAnchor, constant: 20),
            incBtn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.bounds.size.width / 2),
            incBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            incBtn.heightAnchor.constraint(equalToConstant: 80),


            decBtn.topAnchor.constraint(equalTo: scoreTextField.bottomAnchor, constant: 20),
            decBtn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            decBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.bounds.size.width / 2),
            decBtn.heightAnchor.constraint(equalToConstant: 80),


            editBtn.topAnchor.constraint(equalTo: decBtn.bottomAnchor, constant: 20),
            editBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            editBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editBtn.heightAnchor.constraint(equalToConstant: 100),


            deleteBtn.topAnchor.constraint(equalTo: editBtn.bottomAnchor, constant: 20),
            deleteBtn.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            deleteBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteBtn.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func editScore(_ sender: UIButton) {
        if scoreTextField.text == "" {
            let ac = UIAlertController(title: "Oops!", message: "You didn't enter a number!", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            ac.addAction(cancel)
            present(ac, animated: true)
        }
        
        guard let scoreInput = scoreTextField.text else { return  }
        guard let scoreInputInt = Int(scoreInput) else { return }
        guard let player = playerName else { return }
        switch sender.tag {
        case 1:
            delegate.playerScores[playerName]! += scoreInputInt
            let message = "Increased \(player)'s score by \(scoreInput)!"
            delegate.log.insert(message, at: 0)
            delegate.playSound("inc")
        case 2:
            delegate.playerScores[playerName]! -= scoreInputInt
            let message = "Increased \(player)'s score by \(scoreInput)!"
            delegate.log.insert(message, at: 0)
            delegate.playSound("dec")
        case 3:
            if scoreInputInt >= delegate.playerScores[playerName]! {
                delegate.playSound("inc")
            } else {
                delegate.playSound("dec")
            }
            let message = "Changed \(player)'s score to \(scoreInput)!"
            delegate.log.insert(message, at: 0)
            delegate.playerScores[playerName]! = scoreInputInt
        default:
            return
        }
        
        guard let score = delegate.playerScores[playerName] else { return }
        guard let name = playerName else { return }
        playerLabel.text = "\(name): \(String(score))"
        delegate.save()
        view.endEditing(true)
    }
    
    @objc func deletePlayer() {
        guard let player = playerName else { return }
        let ac = UIAlertController(title: "Delete Player", message: "Are you sure you want to delete this \(player) from the game?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "I'm sure!", style: .default) {
            [weak self] _ in
            self?.delegate.players.removeAll(where: {$0 == player})
            self?.delegate.playerScores.removeValue(forKey: player)
            let message = "\(player) has left the game!"
            self?.delegate.log.insert(message, at: 0)
            self!.delegate.save()
            self!.navigationController?.popToRootViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(confirm)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}
