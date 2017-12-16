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

    var messages = [
        Message(timestamp: Date(), author: "Wojtek", message: "Wiadomosc od Wojtka. Cos ciekawego mam do powiedzenia."),
        Message(timestamp: Date(), author: "Wojtek", message: "Wciaz nie ruszylem lab1."),
        Message(timestamp: Date(), author: "Tomek", message: "Wiem wojcio."),
        Message(timestamp: Date(), author: "Tomek", message: "A jeszcze algosy czekaja.")
    ]
    
    init(){
        
    }
    
    func getMessages() -> [Message] {
//        getRequest();
        return messages
    }
    
    func sendMessage(author: String, message: String){
        messages.append(Message(timestamp: Date(), author: author, message: message))
    }
    
    func getRequest(){
        Alamofire.request("https://httpbin.org/get").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

}
