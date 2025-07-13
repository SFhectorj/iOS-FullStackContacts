//
//  ViewController.swift
//  Contacts
//
//  Created by Hector J. Baeza-Arguello on 7/12/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        tableView.delegate = self
        tableView.dataSource = self
        loadContacts()
    }
    
    // Setup the tableview that displays the list
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        if contact.isEmergency {
            cell.textLabel?.text = "🚨 \(contact.fullName)"
        } else {
            cell.textLabel?.text = contact.fullName
        }
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }
    
    // Add contact
    
    @IBAction func addContactTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Contact", message: "Enter contact information", preferredStyle: .alert)
        
        alert.addTextField { $0.placeholder = "Name" }
        alert.addTextField { $0.placeholder = "Last Name" }
        alert.addTextField { $0.placeholder = "Phone Number" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let firstName = alert.textFields?[0].text,
                  let lastName = alert.textFields?[1].text,
                  let phone = alert.textFields?[2].text,
                  !firstName.isEmpty, !lastName.isEmpty, !phone.isEmpty else { return }
            let newContact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phone)
            self.contacts.append(newContact)
            self.contacts.sort {
                if $0.isEmergency != $1.isEmergency {
                    return $0.isEmergency
                }
                return $0.lastName < $1.lastName
            }
            self.saveContacts()
            self.tableView.reloadData()
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // Get document directory
    func getDocumentURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // Load content from JSON
    func loadContacts() {
        if let documentURL = getDocumentURL()?.appendingPathComponent("contacts.json"),
           FileManager.default.fileExists(atPath: documentURL.path) {
            // Load from documents (saved data)
            do {
                let data = try Data(contentsOf: documentURL)
                let decoded = try JSONDecoder().decode([Contact].self, from: data)
                contacts = decoded
            } catch {
                print("Failed to load saved contacts: \(error)")
            }
        } else if let bundleURL = Bundle.main.url(forResource: "contacts", withExtension: "json") {
            // First-time load from bundle
            do {
                let data = try Data(contentsOf: bundleURL)
                let decoded = try JSONDecoder().decode([Contact].self, from: data)
                contacts = decoded
            } catch {
                print("Failed to load bundled contacts: \(error)")
            }
        }
        // Always sort after loading
        contacts.sort {
            if $0.isEmergency != $1.isEmergency {
                return $0.isEmergency
            }
            return $0.lastName < $1.lastName
        }
    }
    
    //Save contacts to JSON
    func saveContacts() {
        guard let documentURL = getDocumentURL()?.appendingPathComponent("contacts.json") else { return }

        do {
            let data = try JSONEncoder().encode(contacts)
            try data.write(to: documentURL)
            // Prints all contacts stored in json database
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Saved JSON:\n\(jsonString)")
            }
        } catch {
            print("Failed to save contacts: \(error)")
        }
        
    }
    
    // Connect contact detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController {
            detailVC.contact = contact

            detailVC.onDelete = {
                self.contacts.removeAll { $0 === contact } // === only works if Contact is a class
                self.saveContacts()
                self.tableView.reloadData()
            }

            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // Helper function: Sort emergency contact to top of list
    func sortContacts() {
        contacts.sort {
            if $0.isEmergency != $1.isEmergency {
                return $0.isEmergency
            }
            return $0.lastName < $1.lastName
        }
    }
    
    // Save updated data to JSON
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        saveContacts()
        sortContacts()
    }
}
