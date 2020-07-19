

import UIKit
import Firebase
import FirebaseFirestore

class AddExcuseViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var AddExcuse: UIButton!
    @IBOutlet weak var newExcuse: UITextField!
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection(category).addDocument(data: [
            "likes": 0,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                let data: [String: Any] = [
                    "likes": 0,
                    "text": self.newExcuse.text!,
                    "comments": self.comments,
                    "id" : ref!.documentID,
                ]
                db.collection(self.category).document(ref!.documentID).setData(data) { error in
                    if let error = error {
                        print("DEBUG: Service.unloadTrip: Failed to upload trip with error \(error.localizedDescription)")
                    } else {
                    }
                    
                    
                }
            }
        }
        self.showToast(message: "Successfully Added ", font: .systemFont(ofSize: 12.0))
    }
    var excusePicker = ["Gym Excuses", "Office Excuses", "University Excuses","Work Excuses"]
    var category = "Gym Excuses"
    var comments : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return excusePicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = excusePicker[row]
        print(category)
    }
    
}

