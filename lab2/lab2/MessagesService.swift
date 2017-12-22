//
//  MessagesService.swift
//  lab2
//
//  Created by Tomasz Frankiewicz on 15/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation
import Alamofire

class MessagesService {
    
    var endpointUrl = "https://home.agh.edu.pl/~ernst/shoutbox.php"
    var getParams: Parameters = ["secret": "ams2017"]
    
    var dateFormatter = DateFormatter()
    
    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 3600)
    }
    
    func getMessages(completionHandler: @escaping (_ messages: [Message]) -> ()) {
        Alamofire.request(endpointUrl, method: .get, parameters: getParams).responseJSON { response in
            
            var messages : [Message] = []
            
            if let json = response.result.value as! NSDictionary?{
                if let array = json["entries"] as! NSArray? {
                    for element in array {
                        let data = element as! NSDictionary
                        
                        let id : Int = Int((data["id"] as! NSString).intValue)
                        let name : String  = (data["name"] as! NSString) as String
                        let message : String  = (data["message"] as! NSString) as String
                        let timestamp: Date = self.dateFormatter.date(from: (data["timestamp"] as! NSString) as String)!
                        
                        messages.append(Message(id: id, timestamp: timestamp, name: name, message: message))
                    }
                }
                completionHandler(messages)
            }
        }
    }
    
    func sendMessage(message: Message, completionHandler: @escaping (_ response: Message) -> ()){
        let postParams: [String: Any] = [
            "name": message.name,
            "message": message.message,
        ]
        Alamofire.request("\(endpointUrl)?secret=ams2017", method: .post, parameters: postParams).responseJSON { response in
            switch(response.result) {
            case .success(_):
                completionHandler(message)
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    

}
