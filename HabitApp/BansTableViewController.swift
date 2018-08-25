//
//  BansTableViewController.swift
//  HabitApp
//
//  Created by Jacob Guerena on 8/25/18.
//  Copyright © 2018 Jacob Guerena. All rights reserved.
//

import UIKit
import CoreData
class BansTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    private let persistentContainer = NSPersistentContainer(name: "Bans")
    
    private var bans = [Ban]()
    
    private var managedObjectContext: NSManagedObjectContext?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Ban> = {
        let fetchRequest: NSFetchRequest<Ban> = Ban.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add touch dismissal
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
        
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
                self.tableView.reloadData()
                self.managedObjectContext = self.persistentContainer.viewContext
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bans = fetchedResultsController.fetchedObjects else { return 0 }
        return bans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BanTableViewCell") as? BanTableViewCell else {
            return UITableViewCell()
        }
        let ban = fetchedResultsController.object(at: indexPath)
        cell.setLabels(ban: ban, row: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Ban
            let ban = fetchedResultsController.object(at: indexPath)
            
            // Delete Ban
            ban.managedObjectContext?.delete(ban)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Actions
    
    public func updateBan(atRow row: Int, submitCount: Int, resistCount: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let ban = fetchedResultsController.object(at: indexPath)
        ban.resistCount = Int32(resistCount)
        ban.submitCount = Int32(submitCount)
    }
    
    public func addBan() {
        guard let managedObjectContext = managedObjectContext else { return }
        
        let ban = Ban(context: managedObjectContext)
        ban.createdAt = Date().timeIntervalSince1970
        ban.resistCount = 0
        ban.submitCount = 0
    }
    
    public func reset() {
        guard let bans = fetchedResultsController.fetchedObjects else { return }
        for ban in bans {
            ban.resistCount = Int32(0)
            ban.submitCount = Int32(0)
        }
        do {
            try managedObjectContext?.save()
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Notifications
    @objc func applicationDidEnterBackground() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
}

extension BansTableViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            print("insert")
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
             print("delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            break
        case .update:
            print("update")
            break
        default:
            print("...")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
