import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    private var validate: Validate!
    private var ref: DatabaseReference!
    
    @IBOutlet private weak var firebaseLebal: UILabel!
    @IBOutlet private weak var warningLabel: UILabel! {
        willSet { newValue.alpha = 0 }
    }
   
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var progressViewPassword: UIProgressView!
   
    @IBOutlet private weak var singUp: UIButton!
    @IBOutlet private weak var singIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        
        validate = Validate()
 
        //Если есть действующий пользователь
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: "goTasks", sender: nil)
            }
        }
        registerForKeyboardNotifications()
    }
    
        //MARK: - Keyboard
    
    private func registerForKeyboardNotifications() {
        //self - то есть наш класс наблюдает за изменениями
        //Selector - метод который выполняется когда мы замечаем событие
        //NSNotification.Name? - за чем мы наблюдаем? (в данном случае за методом клавиатуры)
        //object- nil потому что ни с какими объектами сейчас не работаем
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        print("_____________registerForKeyboardNotifications_____________")
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        print("_____________removeKeyboardNotifications_____________")
    }
    
    //когда появляется клавиатура мы хотим знать ее размеры - notification хранит в себе некую информацию
    @objc func kbWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        //keyboardFrameEndUserInfoKey - определяет прямоугольник (CGRect) клавиатуры в координатах экрана(в текущей ориентации устройства)
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= kbFrameSize.height / 1.5
            print("________kbWillShow(notification: Notification)______")
        }
    }
    
    @objc func kbWillHide() {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            print("________kbDidHide______")
        }
    }
    
    //Скрываем клавиатуру по тапу view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        //Скрываем клавиатуру вызванную для конкретно этого объекта
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //MARK: -
    
    @IBAction private func passwordTextFieldTap(_ sender: UITextField) {
        
        validate.isValidPassword(sender, progressView: progressViewPassword)
    }
    
    @IBAction private func emailTextFieldTap(_ sender: UITextField) {
        
        guard let email = emailTextField.text, email != "" else { return }
        if validate.isValidEmail(email) {
            displayWarningLabel(withText: "Your email is correct")
        }
    }
    
    private func displayWarningLabel(withText text: String) {
        warningLabel.text = text
        
        //withDuration - продолжительность, delay - задерка, usingSpringWithDamping - интенсивность 0-1
        //options - массив опций - одну опцию можно без скобок
        //animayion - логика анимации и завершающий completion
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
            self?.warningLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction private func singUpTap(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            displayWarningLabel(withText: "Info is not correct")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            guard let user = user else { return }
            let userRef = self?.ref.child(user.user.uid)
            userRef?.setValue(["email" : user.user.email])
        }
    }
    
    @IBAction private func singInTap(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
              let password = passwordTextField.text, password != "" else {
            displayWarningLabel(withText: "Info is not correct")
            return
        }
        
        //Логинит пользователя если он существует
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                self?.performSegue(withIdentifier: "goTasks", sender: nil)
                self?.clearFields()
                return
            }
            
            self?.displayWarningLabel(withText: "No such user")
        }
    }
    
    private func clearFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        progressViewPassword.progress = 0
    }
    
    deinit {
        removeKeyboardNotifications()
        print("_____________deinit LoginViewController_____________")
    }
}
