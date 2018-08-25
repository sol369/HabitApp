//
//  ContainerViewController.swift
//  HabitApp
//
//  Created by Jacob Guerena on 8/25/18.
//  Copyright © 2018 Jacob Guerena. All rights reserved.
//

import UIKit
import Material

class ContainerViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    @IBOutlet weak var resetButton: RaisedButton!
    
    private var tableVC: BansTableViewController?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "tableViewEmbedSegue") {
            let tableViewController = segue.destination as! BansTableViewController
            self.tableVC = tableViewController
            self.addChildViewController(tableViewController)
            tableViewController.didMove(toParentViewController: self)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func help(_ sender: Any) {
        self.performSegue(withIdentifier: "helpSegue", sender: self)
    }
    
    @IBAction func add(_ sender: Any) {
        if let tableVC = self.tableVC {
            tableVC.addBan()
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        if let tableVC = self.tableVC {
            tableVC.reset()
        }
    }
    
}

//MARK: - UI

extension ContainerViewController {
    
    private func prepareUI() {
        addButton.image = Icon.addCircleOutline
        resetButton.backgroundColor = UIColor(red: 70/255, green: 116/255, blue: 193/255, alpha: 1.0)
    }
    
}
