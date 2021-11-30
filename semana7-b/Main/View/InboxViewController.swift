//
//  InboxViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 29/09/21.
//

import UIKit

class InboxViewController: UIViewController {
 
    // El oulet me sirve para poder captura el indice
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let people: [String] = ["Jassyra Ezpinoza", "Kriss Galiano", "Miguel Inga", "Emmanuel Ore", "Percy Herrera", "Anthony Quito"]
    
    let messages: [String] = ["Hola que tal? ✌🏻", "Estamos en curso de iOS 👨🏼‍💻", "Tengo reu a la 5 ⏰", "Vamos a Tecsup", "Entremos en 5 a la clase", "Entremos en 5 a la clase"]
    
    let notifications: [String] = ["Solicitud de amistad ☃️", "Nuevo acceso detectado"]
    let descriptions: [String] = ["El pepe quiere ser tu amigo", "Se entro desde una mac 💻"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onClickSegment(_ sender: Any) {
        // cada que aca click en el segment control debo recargar mi table
        tableView.reloadData()
    }

}

// Puedo crear una extension de mi controlador
extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentOptions.selectedSegmentIndex == 0 {
            return people.count
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if segmentOptions.selectedSegmentIndex == 0 {
            cell.textLabel?.text = people[indexPath.row]
            cell.detailTextLabel?.text = messages[indexPath.row]
        } else {
            cell.textLabel?.text = notifications[indexPath.row]
            cell.detailTextLabel?.text = descriptions[indexPath.row]
        }
        
        return cell
    }
}
