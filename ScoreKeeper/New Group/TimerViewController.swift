//
//  TimerViewController.swift
//  ScoreKeeper
//
//  Created by Thomas Kellough on 1/24/20.
//  Copyright © 2020 Thomas Kellough. All rights reserved.
//

import AVFoundation
import UIKit

class TimerViewController: UIViewController {
    
    var timer: Timer?
    var timerLabel: UILabel!
    var timerButton: UIButton!
    var timeButtons: [UIButton] = []
    var timerBuzzer: AVAudioPlayer?
    var time = 60 {
        didSet {
            timerLabel.text = "Time Left: \(time)s"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadInterface()
        
    }
    
    func loadInterface() {
        
        let width = view.bounds.width
        
        let customTimeButton = UIButton()
        customTimeButton.addTarget(self, action: #selector(customTimeTapped), for: .touchUpInside)
        customTimeButton.setBackgroundColor(color: .systemTeal, forState: .normal)
        customTimeButton.setLayer()
        customTimeButton.setTitle("Custom Time", for: .normal)
        customTimeButton.translatesAutoresizingMaskIntoConstraints = false
        timeButtons.append(customTimeButton)
        view.addSubview(customTimeButton)
        
        let button15 = UIButton()
        button15.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
        button15.setBackgroundColor(color: .systemOrange, forState: .normal)
        button15.setLayer()
        button15.setTitle("15s", for: .normal)
        button15.setTitleColor(.white, for: .normal)
        button15.tag = 15
        button15.translatesAutoresizingMaskIntoConstraints = false
        timeButtons.append(button15)
        view.addSubview(button15)
        
        let button30 = UIButton()
        button30.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
        button30.setBackgroundColor(color: .systemOrange, forState: .normal)
        button30.setLayer()
        button30.setTitle("30s", for: .normal)
        button30.setTitleColor(.white, for: .normal)
        button30.tag = 30
        button30.translatesAutoresizingMaskIntoConstraints = false
        timeButtons.append(button30)
        view.addSubview(button30)
        
        let button60 = UIButton()
        button60.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
        button60.setBackgroundColor(color: .systemOrange, forState: .normal)
        button60.setLayer()
        button60.setTitle("60s", for: .normal)
        button60.setTitleColor(.white, for: .normal)
        button60.tag = 60
        button60.translatesAutoresizingMaskIntoConstraints = false
        timeButtons.append(button60)
        view.addSubview(button60)
        
        timerLabel = UILabel()
        timerLabel.font = .preferredFont(forTextStyle: .largeTitle)
        timerLabel.text = "Time Left: 60s"
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)

        timerButton = UIButton()
        timerButton.addTarget(self, action: #selector(timerTapped), for: .touchUpInside)
        timerButton.setBackgroundColor(color: .systemRed, forState: .selected)
        timerButton.setBackgroundColor(color: .systemBlue, forState: .normal)
        timerButton.layer.borderWidth = 1
        timerButton.layer.cornerRadius = width / 4
        timerButton.layer.borderColor = UIColor.systemGray.cgColor
        timerButton.setTitle("Start", for: .normal)
        timerButton.setTitle("Pause", for: .selected)
        timerButton.setTitleColor(UIColor.white, for: .normal)
        timerButton.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        timerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerButton)
        
        let resetButton = UIButton()
        resetButton.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setBackgroundColor(color: .systemGreen, forState: .normal)
        resetButton.setLayer()
        resetButton.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
            
        NSLayoutConstraint.activate([
            
            customTimeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            customTimeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            customTimeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            customTimeButton.heightAnchor.constraint(equalToConstant: 50),

            button15.topAnchor.constraint(equalTo: customTimeButton.bottomAnchor, constant: 40),
            button15.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            button15.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.bounds.width * 0.66 ),
            button15.heightAnchor.constraint(equalToConstant: 45),
            
            button30.topAnchor.constraint(equalTo: button15.topAnchor),
            button30.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.bounds.width * 0.33),
            button30.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -view.bounds.width * 0.33),
            button30.heightAnchor.constraint(equalToConstant: 45),

            button60.topAnchor.constraint(equalTo: button15.topAnchor),
            button60.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: view.bounds.width * 0.66),
            button60.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            button60.heightAnchor.constraint(equalToConstant: 45),

            timerLabel.topAnchor.constraint(equalTo: button15.bottomAnchor, constant: 40),
            timerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: -20),
            timerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 20),
            
            
            timerButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            timerButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            timerButton.widthAnchor.constraint(equalToConstant: width / 2),
            timerButton.heightAnchor.constraint(equalToConstant: width / 2),
            
            resetButton.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: 30),
            resetButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            resetButton.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            resetButton.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: -16)
        ])
 
    }
    
    @objc func timerTapped(_ sender: UIButton) {
    
        if timerButton.isSelected == true {
            timerButton.isSelected.toggle()
            timer?.invalidate()
            for button in timeButtons {
                button.isEnabled = true
            }
            
        } else {
            let tag = sender.tag
            switch tag {
            case 15:
                time = 15
            case 30:
                time = 30
            case 60:
                time = 60
            default:
                break
            }
            for button in timeButtons {
                button.isEnabled = false
            }
            
            timerButton.isSelected.toggle()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLeft), userInfo: nil, repeats: true)
        }
    }
    
    @objc func customTimeTapped() {
        let ac = UIAlertController(title: "Enter a time", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let submit = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            guard let time = Int(text) else { return }
            self?.time = time
        }
        
        ac.addAction(cancel)
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    func playBuzzer() {
        guard let path = Bundle.main.path(forResource: "buzzer.wav", ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            timerBuzzer = try AVAudioPlayer(contentsOf: url)
            timerBuzzer?.play()
        } catch {
            // File could not load
        }
    }
    
    @objc func updateTimeLeft() {
        time -= 1
        if time <= 0 {
            playBuzzer()
            timer?.invalidate()
            time = 60
            timerButton.isSelected.toggle()
        }
    }
    
    @objc func resetTimer() {
        for button in timeButtons {
            button.isEnabled = true
        }
        timer?.invalidate()
        time = 60
        timerButton.isSelected = false
    }

}
