


import UIKit

protocol AddContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

class AddContactVC: UIViewController {

    var delegate: AddContactDelegate?
    
    let nameTextField = UITextField()
    let phoneTextField = UITextField()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Contact"
        view.backgroundColor = UIColor.systemBackground

        setupUI()
        setupSaveButton()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
    }
    
    func setupUI() {
        nameTextField.placeholder = "Enter Name"
        phoneTextField.placeholder = "Enter Phone"
        phoneTextField.keyboardType = .phonePad

        let textFields = [nameTextField, phoneTextField]

        for textField in textFields {
            textField.borderStyle = .roundedRect
            textField.backgroundColor = UIColor.systemBackground
            textField.textColor = UIColor.label
            textField.layer.borderColor = UIColor.separator.cgColor 
            textField.layer.borderWidth = 1.0
        }
        

        let stackView = UIStackView(arrangedSubviews: [nameTextField, phoneTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupSaveButton() {
        saveButton.setTitle("Save Contact", for: .normal)
        saveButton.addTarget(self, action: #selector(saveContact), for: .touchUpInside)
    }
    
    @objc func saveContact() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else { return }
        
        let newContact = Contact( name: name, phone: phone)
        delegate?.didAddContact(newContact)
        dismiss(animated: true, completion: nil)
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
