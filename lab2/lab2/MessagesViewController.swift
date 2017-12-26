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
            self?.reloadData()
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func initAlertController(){
        alertController = UIAlertController(title: "newMessageTitle".localized, message: "", preferredStyle: .alert)
        alertController?.addTextField(configurationHandler: { textField in
            self.alertControllerNameTextField = textField
            textField.placeholder = "namePlaceholder".localized
        } )
        alertController?.addTextField(configurationHandler: { textField in
            self.alertControllerMessageTextField = textField
            textField.placeholder = "messagePlaceholder".localized
        } )
        let sendAction = UIAlertAction(title: "sendButtonText".localized, style: .default, handler: { action in
            let name = self.alertController?.textFields?[0].text
            let message = self.alertController?.textFields?[1].text
            
            if(name!.count < 3 || message!.count < 3){
                self.view.makeToast("lengthVerificationText".localized, duration: 3.0, position: .top)
                self.present(self.alertController!, animated: true, completion: nil)
            } else {
                self.sendMessage(name: name!, message: message!)
                self.alertControllerNameTextField?.text = ""
                self.alertControllerMessageTextField?.text = ""
                self.view.makeToast("messageSentText".localized, duration: 3.0, position: .top)
            }
        })
        alertController?.addAction(sendAction)
        let cancelAction = UIAlertAction(title: "cancelButtonText".localized, style: .cancel, handler: { _ in })
        alertController?.addAction(cancelAction)
    }
    
    func sendMessage(name: String, message: String){
        let message = Message(name: name, message: message)
        messagesService!.sendMessage(message: message){responseMessage in
            self.messages?.insert(responseMessage, at: 0)
            self.refreshUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData(){
        messagesService?.getMessages{ messages in
            self.messages = self.sortByTimestamp(messages: messages)
            self.refreshUI()
        }
    }
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func sortByTimestamp(messages: [Message]) -> [Message] {
        return messages.sorted(by: {$0.timestamp.timeIntervalSinceNow > $1.timestamp.timeIntervalSinceNow})
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        let message = messages![indexPath.row]
        let elapsedTime = Date().timeIntervalSince(message.timestamp)
        
        cell.textLabel?.text = "\(Int(elapsedTime)/60) \("minutesAgoTitleText".localized)"
        cell.detailTextLabel?.text = "\(message.name) \("saysSubtitleText".localized): \(message.message)"
        return cell
    }

}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
