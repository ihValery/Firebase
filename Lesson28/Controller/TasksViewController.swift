import UIKit
import Firebase

class TasksViewController: UIViewController {
    
    var user: User!
    var ref: Firebase.DatabaseReference!
    var tasks: [Task] = []
    
    @IBOutlet private weak var addNewTask: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Получаем текущего пользователя
        guard let currentUser = Auth.auth().currentUser else { return }
        //Достаем его во "внешний мир" )))
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "user").child(String(user.uid)).child("tasks")

    }
    @IBAction private func addNewTastTap(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a new joke", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first?.text, textField != "" else { return }
            
            let task = Task(title: textField, userId: (self?.user.uid)!)
            //task.title.lowercased() - используется в качестве папки
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("_____________deinit TasksViewController_____________")
    }
}

extension TasksViewController: UITableViewDelegate {
    
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
