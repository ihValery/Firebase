//
//  ViewController.swift
//  Lesson28
//
//  Created by Валерий Игнатьев on 13.04.21.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet private weak var firebaseLebal: UILabel!
    @IBOutlet private weak var warningLabel: UILabel! {
        willSet { newValue.isHidden = true }
    }
   
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var progressViewPassword: UIProgressView!
   
    @IBOutlet private weak var singUp: UIButton!
    @IBOutlet private weak var singIn: UIButton!
   
    @IBOutlet private weak var firebaseLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func passwordTextFieldTap(_ sender: UITextField) {
        
        isValidPassword()
    }
    
    @IBAction private func emailTextFieldTap(_ sender: UITextField) {
        
        guard let text = emailTextField.text, text != "" else { return }
        warningLabel.text = isValidEmail(text) ? "" : "email is not correct"
        warningLabel.isHidden = isValidEmail(text) ? true : false
    }
    
    @IBAction private func singUpTap(_ sender: UIButton) {
        
    }
    
    @IBAction private func singInTap(_ sender: UIButton) {
        
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword() {
        
            let levelTwoBigChar   = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[A-Z]).{6,}$")
            let levelTwoNumber    = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[0-9]).{6,}$")
            let levelTwoSpec      = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
            
            let levelThreeNumber  = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$")
            let levelThreeSpec    = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,}$")
            let levelThreeBigChar = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
            
            let levelFour         = NSPredicate(format: "SELF MATCHES %@ ",
                                  "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{8,}$")
            
            if let pass = passwordTextField.text {
                switch pass {
                    case _ where levelFour.evaluate(with: pass):
                        progressViewPassword.progress = 1
                        progressViewPassword.progressTintColor = .green
                    
                    case _ where levelThreeBigChar.evaluate(with: pass) || levelThreeNumber.evaluate(with: pass) || levelThreeSpec.evaluate(with: pass):
                        progressViewPassword.progress = 0.75
                        progressViewPassword.progressTintColor = .systemYellow
                        
                    case _ where levelTwoBigChar.evaluate(with: pass) || levelTwoNumber.evaluate(with: pass) || levelTwoSpec.evaluate(with: pass):
                        progressViewPassword.progress = 0.5
                        progressViewPassword.progressTintColor = .orange
                        
                    case _ where pass.count > 4:
                        progressViewPassword.progress = 0.25
                        progressViewPassword.progressTintColor = .red
                        
                    default:
                        progressViewPassword.progress = 0
                }
            }
        }
}
