//
//  ProfileViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 20/10/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed || isMovingFromParent {
            print("viewWillDisappear")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
    }
    
    override func endAppearanceTransition() {
        print("dismmiss1")
        if isBeingDismissed {
            print("dismmiss")
        }
    }
    
//  vamos a recuperar al usuario de session y extraer sus datos
    func setUpView() {
        
        // esto le da un border de 1px y poder default es negro
        imageProfile.layer.borderWidth = 1
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            lblEmail.text = user.email
            
            if let name = user.displayName {
                lblName.text = name
            }
            
            if let imageUrl = user.photoURL {
                setImageFromUrl(url: imageUrl, image: imageProfile)
            }
        }
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        // vamos a borrar la session del usuario actual
        let auth = Auth.auth()

        do {
            try auth.signOut()
            // dismmis para mandarlo a la vista inicial 
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
