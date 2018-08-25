//
//  HelpViewController.swift
//  HabitApp
//
//  Created by Jacob Guerena on 8/25/18.
//  Copyright © 2018 Jacob Guerena. All rights reserved.
//

import UIKit
import Material
class HelpViewController: UIViewController {

    @IBOutlet weak var exit: UIBarButtonItem!
    
    @IBOutlet weak var addIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = Icon.addCircleOutline?.withRenderingMode(.alwaysTemplate)
        addIcon.tintColor = UIColor.black
        addIcon.image = image
        exit.image = Icon.close
    }
    
    @IBAction func exit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
