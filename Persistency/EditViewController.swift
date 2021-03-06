//
//  EditViewController.swift
//  Persistency
//
//  Created by Simon Müller on 19.10.20.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    @IBOutlet weak var nameInput: UITextField!
    var person : Person?
    var managedContext : NSManagedObjectContext!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameInput.text = self.person?.name
    }
    
    
    @IBAction func saveAndExitButtonPressed(_ sender: UIButton) {
        if (self.person == nil) {
            print("from MasterView")
            let newPerson = Person(context: self.managedContext)
            newPerson.name = nameInput.text!
            
            do {
                try self.managedContext?.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            dismiss(animated: true)
            
        } else {
            print("from DetailView")
            self.person?.name = nameInput.text!
            
            do {
                try self.managedContext?.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
            dismiss(animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
