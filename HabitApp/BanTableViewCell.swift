//
//  BanTableViewCell.swift
//  HabitApp
//
//  Created by Jacob Guerena on 8/25/18.
//  Copyright © 2018 Jacob Guerena. All rights reserved.
//

import UIKit

class BanTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var resistButton: UIButton!
    
    @IBOutlet weak var banLabel: UITextField!
    
    @IBOutlet weak var resistCountLabel: UITextField!
    
    @IBOutlet weak var submitCountLabel: UITextField!
    
    public var ban: Ban?
    
    public var row: Int = 0
    
    public var submitCount: Int = 0 {
        didSet {
            submitCountLabel.text = String(submitCount)
            if let ban = self.ban {
                ban.submitCount = Int32(submitCount)
            }
        }
    }
    
    public var resistCount: Int = 0 {
        didSet {
            resistCountLabel.text = String(resistCount)
            if let ban = self.ban {
                ban.resistCount = Int32(resistCount)
            }
        }
    }
    
    //MARK: - UI/Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //UI
        self.selectionStyle = .none
        submitButton.layer.cornerRadius = 8
        resistButton.layer.cornerRadius = 8
        
        //Add Done buttons
        banLabel.addDoneButtonOnKeyboard()
        resistCountLabel.addDoneButtonOnKeyboard()
        submitCountLabel.addDoneButtonOnKeyboard()
        
        //Add label targets
        resistCountLabel.addTarget(self, action: #selector(editLabel), for: UIControlEvents.editingDidEnd)
        submitCountLabel.addTarget(self, action: #selector(editLabel), for: UIControlEvents.editingDidEnd)
        banLabel.addTarget(self, action: #selector(editLabel), for: UIControlEvents.editingDidEnd)
        
        //Add targets
        let longTouchSubmit = UILongPressGestureRecognizer(target: self, action: #selector(decrementSubmitCount))
        longTouchSubmit.minimumPressDuration = 0.5
        let longTouchResist = UILongPressGestureRecognizer(target: self, action: #selector(decrementResistCount))
        longTouchResist.minimumPressDuration = 0.5
        let tapTouchSubmit = UITapGestureRecognizer(target: self, action: #selector(incrementSubmitCount))
        let tapTouchResist = UITapGestureRecognizer(target: self, action: #selector(incrementResistCount))
        submitButton.addGestureRecognizer(longTouchSubmit)
        submitButton.addGestureRecognizer(tapTouchSubmit)
        resistButton.addGestureRecognizer(longTouchResist)
        resistButton.addGestureRecognizer(tapTouchResist)
    }

    public func setLabels(ban: Ban, row: Int) {
        self.row = row
        banLabel.text = ban.name ?? "Ban #" + "\(row + 1)"
        resistCount = Int(ban.value(forKeyPath: "resistCount") as! Int32)
        submitCount = Int(ban.value(forKeyPath: "submitCount") as! Int32)
        self.ban = ban
    }
    
    @objc private func incrementSubmitCount() {
        guard submitCount != INT32_MAX - 1 else {
            return
        }
        submitCount += 1
    }
    
    @objc private func incrementResistCount() {
        guard resistCount != INT32_MAX - 1 else {
            return
        }
        resistCount += 1
    }
    
    @objc private func decrementSubmitCount(sender: UILongPressGestureRecognizer) {
        guard submitCount != 0 else {
            return
        }
        if sender.state == .began {
            submitCount -= 1
        }
    }
    
    @objc private func decrementResistCount(sender: UILongPressGestureRecognizer) {
        guard resistCount != 0 else {
            return
        }
        if sender.state == .began {
            resistCount -= 1
        }
    }
    
    @objc private func editLabel(sender: UITextField) {
        if sender.text == nil || sender.text!.isEmpty {
            self.submitCountLabel.text = String(submitCount)
            self.resistCountLabel.text = String(resistCount)
            return
        }
        if sender === self.submitCountLabel {
            if let amount = Int(sender.text!), amount < INT32_MAX {
                submitCount = amount
            } else {
                submitCountLabel.text = String(submitCount)
            }
        }
        if sender === self.resistCountLabel {
            if let amount = Int(sender.text!), amount < INT32_MAX {
                resistCount = amount
            } else {
                resistCountLabel.text = String(resistCount)
            }
        }
        if sender === self.banLabel {
            if let ban = self.ban, sender.text! != "Ban #" + "\(row + 1)" {
                print(sender.text!)
                ban.name = sender.text!
            }
        }
    }
    
    override func prepareForReuse() {
        self.ban = nil
    }
}
