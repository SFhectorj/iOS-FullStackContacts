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
        loadMyProfile()
        loadContacts()
        setupFilterButtons()
    }
    
    // Setup the tableview that displays the list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = filteredContacts()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        if contact == myProfile {
            cell.textLabel?.text = "👤 My Profile"
        } else if contact.isEmergency {
            cell.textLabel?.text = "🚨 \(contact.fullName)"
        } else {
            cell.textLabel?.text = contact.fullName
        }
        
        cell.detailTextLabel?.text = contact.relationship ?? contact.phoneNumber
        return cell
    }
    
    func filteredContacts() -> [Contact] {
        if activeFilter == "All" {
            return contacts.sorted { $0.lastName < $1.lastName }
        } else {
            return contacts
                .filter { $0.relationship == activeFilter }
                .sorted { $0.lastName < $1.lastName }
        }
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
    
    // Tap My Profile
    @IBAction func editProfileTapped(_ sender: UIBarButtonItem) {
        print("Edit Profile tapped!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            profileVC.profile = myProfile
            profileVC.onSaveProfile = { updatedProfile in
                self.myProfile = updatedProfile
                self.saveMyProfile()
                self.sortContacts()
                self.tableView.reloadData()
            }
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // Add User Profile/contact
    var myProfile: Contact?
    
    // Load user contact profile
    func loadMyProfile() {
        if let url = getDocumentURL()?.appendingPathComponent("myProfile.json"),
           let data = try? Data(contentsOf: url),
           let profile = try? JSONDecoder().decode(Contact.self, from: data) {
            myProfile = profile
        }
    }
    
    // Save user contact info
    func saveMyProfile() {
        guard let profile = myProfile,
              let url = getDocumentURL()?.appendingPathComponent("myProfile.json"),
              let data = try? JSONEncoder().encode(profile) else { return }
        try? data.write(to: url)
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
            detailVC.onUpdate = { updated in
                if let index = self.contacts.firstIndex(where: { $0.id == updated.id }) {
                    self.contacts[index] = updated
                    self.saveContacts()
                    self.tableView.reloadData()
                }
            }
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
        // Ensure profile is at the top
        if let profile = myProfile {
            contacts.removeAll { $0.id == profile.id }
            contacts.insert(profile, at: 0)
        }
    }
    
    // Save updated data to JSON
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        saveContacts()
        sortContacts()
    }
    
    @IBOutlet weak var filterStackView: UIStackView!
    
    let relationshipFilters = ["All", "Spouse", "Child", "Parent", "Sibling", "Other"]
    var activeFilter: String = "All"
    
    func setupFilterButtons() {
        filterStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for filter in relationshipFilters {
            let button = UIButton(type: .system)
            
            if #available(iOS 15.0, *) {
                button.configuration = nil
            }
            
            button.setTitle(filter, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = (filter == activeFilter) ? UIColor.systemBlue : UIColor.systemGray4
            button.layer.cornerRadius = 15
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            
            //stop buttons from stretching
            button.setContentHuggingPriority(.required, for: .horizontal)
            button.setContentHuggingPriority(.required, for: .vertical)
            
            button.sizeToFit()
            button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
            
            filterStackView.addArrangedSubview(button)
        }
    }
    
    @objc func filterTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        activeFilter = title
        setupFilterButtons() // Refresh pill highlighting
        tableView.reloadData()
    }
}
