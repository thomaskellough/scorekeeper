//
//  AddPlayerViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 1/26/20.
//  Copyright © 2020 Thomas Kellough. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {

    var playerTextField: UITextField!
    var buttonsView: UIView!
    weak var delegate: DetailTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerTextField = UITextField()
        playerTextField.layer.borderColor = UIColor.systemGray.cgColor
        playerTextField.layer.borderWidth = 1
        playerTextField.layer.cornerRadius = 8
        playerTextField.placeholder = "Enter name"
        playerTextField.textAlignment = .center
        playerTextField.font = .preferredFont(forTextStyle: .largeTitle)
        playerTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerTextField)
        
        let colorLabel = UILabel()
        colorLabel.text = "Choose a color"
        colorLabel.font = .preferredFont(forTextStyle: .largeTitle)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            playerTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            playerTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            playerTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            
            colorLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 250),
            colorLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            colorLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            
            buttonsView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 10),
            buttonsView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20),
            buttonsView.heightAnchor.constraint(equalToConstant: view.bounds.width - 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
            
        ])
        
        var counter = 0
        let width = Int((view.bounds.width / 4) - 5)
        let height = Int((view.bounds.width / 4) - 5)
        
        for row in (0..<2) {
            for column in (0..<4) {
                let btn = UIButton()
                let frame = CGRect(x: column * width, y: height * row, width: width, height: height)
                let color = delegate.colorArray[counter]
                
                btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
                btn.backgroundColor = color
                btn.frame = frame
                btn.layer.borderColor = UIColor.systemGray.cgColor
                btn.layer.borderWidth = 1
                btn.tag = counter
                counter += 1
                buttonsView.addSubview(btn)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func btnTapped(_ sender: UIButton) {
        guard let player = playerTextField.text else { return }
        let colorIndex = sender.tag
        let color = delegate.colorArray[colorIndex]
        submit(player, color, colorIndex)
        
    }
    
    func submit(_ name: String, _ color: UIColor, _ colorIndex: Int) {
        // Used in addPlayer()
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
        if delegate.players.contains(trimmedName) {
            let ac = UIAlertController(title: "Oops!", message: "It seems that you have already added that player. Please try a different name.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
        } else {
            if trimmedName != "" {
                let ac = UIAlertController(title: "Confirm", message: "Are you sure you want to add \(trimmedName) to the game?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                let submitAction = UIAlertAction(title: "I'm sure!", style: .default) {
                    [weak self] _ in
                    self?.delegate.players.append(trimmedName)
                    self?.delegate.playerScores[trimmedName] = 0
                    self?.delegate.playerColors[trimmedName] = color
                    self?.delegate.playerColorsIndex[trimmedName] = colorIndex
                    let message = "\(trimmedName) joined the game!"
                    self?.delegate.log.insert(message, at: 0)
                    self!.delegate.save()
                    self?.playerTextField.text = ""
                }
                
                ac.addAction(cancel)
                ac.addAction(submitAction)
                present(ac, animated: true)
            }
        }
    }
    
}
