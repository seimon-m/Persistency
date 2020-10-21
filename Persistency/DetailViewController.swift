//
//  DetailViewController.swift
//  Persistency
//
//  Created by Simon Müller on 19.10.20.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var person : Person?
    var managedContext : NSManagedObjectContext?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = self.person?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let editView = segue.destination as? EditViewController
        editView?.managedContext = self.managedContext
        editView?.person = self.person
    }
    
    

}
