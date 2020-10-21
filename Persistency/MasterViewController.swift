//
//  MasterViewController.swift
//  EditList
//
//  Created by Simon Müller on 07.10.20.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Person>!
    var container: NSPersistentContainer!
    var person: Person!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        initializeFetchedResultsController()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func insertNewObject(sender: UIBarButtonItem) {
        print("add")
        let person = Person(context: self.container.viewContext)
        person.name = "Simon"
        do {
            try container.viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Could not save person. \(nserror)")
        }
    }
    
    // MARK: - Core Data
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<Person>(entityName: "Person")
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        let moc = container.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        return fetchedResultsController.sections!.count
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        self.person = object
//        let person2 = fetchedResultsController.object(at: indexPath)
        //Populate the cell from the object
        cell.textLabel?.text = object.name
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            container.viewContext.delete(fetchedResultsController.object(at: indexPath))
            do {
                try container.viewContext.save()
                tableView.reloadData()
            } catch {
                fatalError("Failed to delete row: \(error)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let detailView = segue.destination as? DetailViewController
        detailView?.managedContext = container.viewContext
        detailView?.person = self.person
    }
    

}
