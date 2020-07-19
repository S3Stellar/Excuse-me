
import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource, UIDropInteractionDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if flag == true {
            return 0
        }
        else{
            return self.excuseAll[self.random].comments.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentsCollectionViewCell", for: indexPath) as! commentsCollectionViewCell
        
        if flag == true {
            return cell
        }
        else{
            cell.commentLbl.text = self.excuseAll[self.random].comments[indexPath.row]
            return cell
        }
        
        
    }
    
    
    
    
    
    @IBOutlet weak var cmntLbl: UILabel!
    @IBOutlet weak var exc1: UILabel!
    @IBOutlet weak var clipButton: UIButton!
    @IBOutlet weak var commentSec: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesNumber: UILabel!
    @IBOutlet weak var commentsCol: UICollectionView!
    @IBAction func likeButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        let likes = self.excuseAll[self.random].likes
        let data: [String: Any] = [
            "likes": likes+1,
            "text": self.excuseAll[self.random].text,
            "comments": self.excuseAll[self.random].comments,
            "id" : self.excuseAll[self.random].eid,
        ]
        db.collection(category).document(self.excuseAll[self.random].eid).setData(data) { error in
            if let error = error {
                print("DEBUG: Service.unloadTrip: Failed to upload trip with error \(error.localizedDescription)")
                //                    complition(false)
            } else {
            }
            
        }
        likesNumber.text = "\(likes+1) Likes"
        likeButton.isEnabled = false
        
    }
    @IBAction func commentButtonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        var comments : [String] = self.excuseAll[self.random].comments
        print(comments.count)
        let comtxt : String = commentSec.text ?? ""
        comments.append(comtxt)
        print(comments.count)
        let data: [String: Any] = [
            "likes": self.excuseAll[self.random].likes,
            "text": self.excuseAll[self.random].text,
            "comments": comments,
            "id" : self.excuseAll[self.random].eid,
        ]
        db.collection(category).document(self.excuseAll[self.random].eid).setData(data) { error in
            if let error = error {
                print("DEBUG: Service.unloadTrip: Failed to upload trip with error \(error.localizedDescription)")
            } else {
            }
            
        }
    
        commentsCol.reloadData()
        self.showToast(message: "Successfully Added ", font: .systemFont(ofSize: 12.0))
        commentSec.text = ""
        commentButton.isEnabled = false
    }
    
    static var shared = Service()
    let defaults = UserDefaults.standard
    var flag = true
    var category : String = "Gym Excuses"
    var random : Int = 0
    let excusePicker = ["Gym Excuses", "Office Excuses", "University Excuses","Work Excuses"]
    let langStr = Locale.current.languageCode!
    var excuseAll : [Excuse] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.addInteraction(UIDropInteraction(delegate: self))
        GlobalVar.history = defaults.stringArray(forKey: "history") ?? [String]()
        exc1.text = defaults.string(forKey: "excuse1") ?? "place1".localized
        likeButton.isEnabled = false
        commentButton.isEnabled = false
    }
    
    @IBAction func copyClipboardPressed(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = exc1.text!
    }
    
    
    @IBAction func generateExcusePressed(_ sender: Any) {
        flag = false
        //       var ref: DatabaseReference!
        _ = Firestore.firestore()
        var _: DocumentReference? = nil
        
        
        Service.shared.fetchExcuseData(collectionName: category,complition:  { posts in
            self.excuseAll = posts
            if(posts.count==0){
                self.exc1.text = "No excuses found"
                self.showToast(message: "No excuses found", font: .systemFont(ofSize: 12.0))
            }
            else{
                self.random = Int.random(in: 0 ..< self.excuseAll.count)
                self.exc1.text = self.excuseAll[self.random].text
                self.likesNumber.text = String(self.excuseAll[self.random].likes) + " Likes"
                self.commentsCol.reloadData()
                self.clipButton.isEnabled = true
                self.likeButton.isEnabled = true
                self.commentButton.isEnabled = true
            }
            self.likesNumber.isHidden = false
            self.cmntLbl.isHidden = false
        })
        GlobalVar.history.insert(exc1.text!, at: 0)
        if (GlobalVar.history.count == 200) {
            GlobalVar.history.remove(at: 199)
        }
        autosave()
        
    }
    
    func autosave() {
        defaults.set(GlobalVar.history, forKey: "history")
        defaults.set(exc1.text, forKey: "excuse1")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return excusePicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return excusePicker[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = excusePicker[row]
        print(category)
    }
}

struct GlobalVar {
    static var history = [String]()
}
extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
