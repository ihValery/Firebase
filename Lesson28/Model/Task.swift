import Foundation
import Firebase

struct Task {
    
    let title: String
    let userId: String
    //Reference к конкретной записи в DB (опционал - создаем локально, а Reference после помещения в базу данный)
    let ref: Firebase.DatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    // DataSnapshot - снимок иерархии DB
    init(snapshot: Firebase.DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
}
