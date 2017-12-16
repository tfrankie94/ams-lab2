//
//  MessagesViewController.swift
//  lab2
//
//  Created by Tomasz Frankiewicz on 15/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import Toast_Swift

class MessagesViewController: UITableViewController {

    var messages : [Message]?
    var messagesService: MessagesService?
    
    var alertController: UIAlertController?
    var alertControllerNameTextField: UITextField?
    var alertControllerMessageTextField: UITextField?

    @IBAction func onComposeMessageClick(_ sender: UIBarButtonItem) {
        self.present(alertController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesService = MessagesService()
        
        initPullToRefresh()
        initAlertController()
    }
    
    func initPullToRefresh(){
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            self?.reloadData()
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func initAlertController(){
        alertController = UIAlertController(title: "New message", message: "", preferredStyle: .alert)
        alertController?.addTextField(configurationHandler: { textField in
            self.alertControllerNameTextField = textField
            textField.placeholder = "Your name"
        } )
        alertController?.addTextField(configurationHandler: { textField in
            self.alertControllerMessageTextField = textField
            textField.placeholder = "Your message"
        } )
        let sendAction = UIAlertAction(title: "Send", style: .default, handler: { action in
            let name = self.alertController?.textFields?[0].text
            let message = self.alertController?.textFields?[1].text
            
            if(name!.count < 3 || message!.count < 3){
                self.view.makeToast("Name and message should be at least 3 letters long.", duration: 3.0, position: .top)
                self.present(self.alertController!, animated: true, completion: nil)
            } else {
                self.sendMessage(name: name!, message: message!)
                self.alertControllerNameTextField?.text = ""
                self.alertControllerMessageTextField?.text = ""
                self.view.makeToast("Message sent.", duration: 3.0, position: .top)
            }
        })
        alertController?.addAction(sendAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in })
        alertController?.addAction(cancelAction)
    }
    
    func sendMessage(name: String, message: String){
        messagesService!.sendMessage(author: name, message: message)
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData(){
        messages = sortByTimestamp(messages: (messagesService?.getMessages())!)
        self.tableView.reloadData()
    }
    
    func sortByTimestamp(messages: [Message]) -> [Message] {
        return messages.sorted(by: {$0.timestamp.timeIntervalSinceNow > $1.timestamp.timeIntervalSinceNow})
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages!.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        
        let message = messages![indexPath.row]
        let elapsedTime = Date().timeIntervalSince(message.timestamp)

        cell.textLabel?.text = "\(Int(elapsedTime)/60) minutes ago"
        cell.detailTextLabel?.text = "\(message.author) says: \(message.message)"
        return cell
    }
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
