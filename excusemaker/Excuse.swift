import Foundation
import Firebase
struct Excuse {
    struct K {
        static let collection = "Office Excuses"
        static let likes = "likes"
        static let text = "text"
        static let comments = "comments"
        static let eid = "id"
    }
    
    var data: [String: Any] {
        
        get {
            return [
                Excuse.K.likes: likes,
                Excuse.K.text: text,
                Excuse.K.comments: comments,
                Excuse.K.eid: eid,
            ]
        }
        set {
            likes = newValue[Excuse.K.likes] as? Int ?? 0
            text = newValue[Excuse.K.text] as? String ?? ""
            eid = newValue[Excuse.K.eid] as? String ?? ""
            comments = newValue[Excuse.K.comments] as? [String] ?? []
        }
    }
    var text: String = ""
     var eid: String = ""
    var likes: Int = 0
    var comments: [String] = []
    
    init() {
    }
    
   
    
}

