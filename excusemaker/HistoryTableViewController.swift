import UIKit

class HistoryTableViewController: UITableViewController {
    @IBOutlet var excuseTableView: UITableView!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        update()
        if (GlobalVar.history.count == 0) {
            deleteAllButton.isHidden = true
            editButton.isHidden = true
        } else {
            deleteAllButton.isHidden = false
            editButton.isHidden = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (GlobalVar.history.count != 0) {
            deleteAllButton.isHidden = false
            editButton.isHidden = false
        }
        return GlobalVar.history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcuseCell", for: indexPath)
        
        let excuse = GlobalVar.history[indexPath.row]
        cell.textLabel?.text = excuse
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = GlobalVar.history[indexPath.row]
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete".localized) { (action, indexPath) in
            GlobalVar.history.remove(at: indexPath.row)
            self.update()
        }
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection
        section: Int) -> String? {
        if (GlobalVar.history.count == 0) {
            return "placehistory".localized
        } else {
        return "total".localized + String(GlobalVar.history.count)
        }
    }
    

    
    func update() {
        excuseTableView.reloadData()
        if (GlobalVar.history.count == 0) {
            deleteAllButton.isHidden = true
            editButton.isHidden = true
        } else {
            deleteAllButton.isHidden = false
            editButton.isHidden = false
        }
        defaults.set(GlobalVar.history, forKey: "history")
    }
    
    @IBAction func editModePressed(_ sender: Any) {
        if(self.tableView.isEditing == true) {
            self.tableView.setEditing(false, animated: true)
            editButton.setTitle("edit".localized, for: UIControl.State.normal)
        } else {
            self.tableView.setEditing(true, animated: true)
            editButton.setTitle("done".localized, for: UIControl.State.normal)
        }
        if ((GlobalVar.history.count) == 0) {
            editButton.isHidden = true
        }
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        GlobalVar.history.removeAll(keepingCapacity: false)
        deleteAllButton.isHidden = true
        editButton.isHidden = true
        update()
    }
    
}
