//
//  EditProfileViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 17/11/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnOpenImage: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var imagePathName: URL? = nil
    
    var imageURLFirebase: URL? = nil
    
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getUser()
    }
    
    func setUpView() {
        btnOpenImage.setTitle("", for: .normal)
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onClickSave(_ sender: Any) {
        if imagePathName == nil {
            upsertProfile(url: imageURLFirebase)
        } else {
            uploadPhoto()
        }
    }
    
    
    @IBAction func onClickNewImage(_ sender: Any) {
//        Este boton debe darnos 2 opciones una para abrir la camara y para la galeria
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCamera = UIAlertAction(title: "Camara", style: .default, handler: nil)
        let openGalery = UIAlertAction(title: "Galeria", style: .default) {_ in
            self.openGallery()
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(openCamera)
        alert.addAction(openGalery)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getUser() {
        if let user = Auth.auth().currentUser {
            txtEmail.text = user.email
            
            if let name = user.displayName {
                txtName.text = name
            }
            
            if let profile = user.photoURL {
                // veamos que firebase nos da la url de la imagen
                // profile es una URL
                imageURLFirebase = profile
                setImageFromUrl(url: profile, image: imageProfile)
            }
        }
    }
    
    func openGallery() {
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageProfile.image = image
        }
        
        imagePathName = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!
        
//        Siempre debemos cerrar nuestro album despuesde escoger la foto
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadPhoto() {
//        obtener la imagen de la galeria y enviarla a firebase
        let fileExtension = imagePathName!.pathExtension
        let fileName = "image\(Int.random(in: 1...10000)).\(fileExtension)"
        
        let storageRef = storage.reference()
        let profileRef = storageRef.child("profile").child(fileName)
        
        profileRef.putFile(from: imagePathName!, metadata: nil) {
            metadata, error in
            
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                profileRef.downloadURL { (url, error) in
                    
                    //Esto retorna la URL de la foto
                    print(String(describing: url!))
                    self.upsertProfile(url: url!)
                    
                }
            }
        }
    }
    
    // url es la url de la imagen
    func upsertProfile(url: URL?) {
        let name = txtName.text
        
        // Vamos a invocar a la funcion createProfileChangeRequest()
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = url
        
        changeRequest?.commitChanges { error in
            
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
