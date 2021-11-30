//
//  LoginViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 20/10/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    // viewDidLoad se ejecua una vez que la vista cargo
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // La funcion que se ejecuta antes de renderizar la vista
    override func viewDidAppear(_ animated: Bool) {
        validateSession()
    }
  

    @IBAction func onClickLogin(_ sender: Any) {
//        paso 1 capturo el texto de mis inputs
        let email = txtEmail.text!
        let password = txtPassword.text!
//        primero vamos a probar si es que el usuario se crea
//        storeUser(email: email, password: password)
        login(email: email, password: password)
    }
    
//    creamos una funcion para registrar un usuario
    func storeUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) {
            authResponse, error in
            
            if error == nil {
//                tiene que ir a la vista del home
                self.goHome()
            }
        }
    }
    
//    creamos una funcion para hacer login
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResponse, error in
            
            if error == nil {
            // tiene que ir a la vista del home
                self.goHome()
            }
        }
    }
    
    func validateSession() {
        if Auth.auth().currentUser != nil {
            // esta en la session
            self.goHome()
        }
    }
    
    func goHome() {
        self.performSegue(withIdentifier: "segueLogin", sender: nil)
    }
}
