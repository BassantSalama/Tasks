//
//  ContactsVC.swift
//  Task1
//
//  Created by mac on 02/03/2025.
//

import UIKit

class ContactsVC: UIViewController {
    
    
    @IBOutlet var contactsTabelView: UITableView!
    
    
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    
    var searchController: UISearchController!
    
    
    var groupedContacts = [String: [Contact]]()  // Dictionary to group contacts
    var sectionTitles: [String] = []  // Titles (A, B, C, ...)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTabelView.delegate   = self
        contactsTabelView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContactTapped))
        
        
        setupSearchController()
        fetchContacts()
        
    }
    
    @objc func addContactTapped() {
        let addContactVC = AddContactVC()
        addContactVC.delegate = self
        let navController = UINavigationController(rootViewController: addContactVC)
        present(navController, animated: true, completion: nil)
    }
    
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        // Ensures the table view remains visible while typing.
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Contacts"
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
        // Prevents search bar from persisting on other screens.
        definesPresentationContext = true
    }
    
    
    
    func fetchContacts() {
        NetworkManager.shared.fetchContacts { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let contacts):
                self.contacts = contacts
                self.groupContacts()  // Group contacts after fetching
                DispatchQueue.main.async {
                    self.contactsTabelView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch contacts: \(error.localizedDescription)")
            }
        }
    }
    
    
    func groupContacts() {
        groupedContacts.removeAll()
        sectionTitles.removeAll()
        
        for contact in contacts {
            let firstLetter = String(contact.name.prefix(1)).uppercased()
            
            if groupedContacts[firstLetter] != nil {
                groupedContacts[firstLetter]?.append(contact)
            } else {
                groupedContacts[firstLetter] = [contact]
            }
        }

        sectionTitles = Array(groupedContacts.keys).sorted()
    }
}
    
extension ContactsVC: UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            let key = sectionTitles[section]
            return searchController.isActive ? filteredContacts.count : groupedContacts[key]?.count ?? 0
          
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTabelView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact: Contact
        
        if searchController.isActive {
            // When searching, use the filteredContacts array
            contact = filteredContacts[indexPath.row]
        } else {
            // When not searching, get the correct section and row
            let key = sectionTitles[indexPath.section]
            if let contactsInSection = groupedContacts[key] {
                contact = contactsInSection[indexPath.row]
            } else {
                fatalError("Section data mismatch") // This should never happen
            }
        }
        
        cell.textLabel?.text = contact.name
        return cell
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionTitles.firstIndex(of: title) ?? 0
    }


    

        
        
        
    }
    
    
extension ContactsVC: UISearchControllerDelegate, UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            
            if let searchText = searchController.searchBar.text, !searchText.isEmpty {
                filteredContacts = contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            } else {
                filteredContacts = contacts
            }
            DispatchQueue.main.async {
                self.contactsTabelView.reloadData()
            }
            
            
            
        }
    }

extension ContactsVC: AddContactDelegate {
    func didAddContact(_ contact: Contact) {
        contacts.append(contact) // Add to main contacts list
        
        // Update groupedContacts
        let firstLetter = String(contact.name.prefix(1)).uppercased()
        
        if var existingContacts = groupedContacts[firstLetter] {
            existingContacts.append(contact)
            groupedContacts[firstLetter] = existingContacts
        } else {
            groupedContacts[firstLetter] = [contact]
            sectionTitles.append(firstLetter)
            sectionTitles.sort() // Keep section headers sorted (A-Z)
        }
        
        DispatchQueue.main.async {
            self.contactsTabelView.reloadData()
        }
    }

}

