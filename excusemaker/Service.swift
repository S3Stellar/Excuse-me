import Foundation
import Firebase
import FirebaseFirestore
struct Service {

    static var shared = Service()
    var ref: DatabaseReference!
    let db = Firestore.firestore()
//
//
     func fetchExcuseData( collectionName : String = "", complition: @escaping([Excuse]) -> Void) {
            db.collection(collectionName).getDocuments { querySnapshot, error in
                if let error = error {
                    
                    print("DEBUG: Service.fetchTripData: failed to fetch trip with error \(error)")
                    
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        var excuses:[Excuse] = []
                        
                        
                        for excuse in snapshotDocuments {
                            
                            var exc = Excuse()
                        exc.data = excuse.data()
                            excuses.append(exc)
                            
                        }
                         complition(excuses)
                    }
                }
            }
        }
}
