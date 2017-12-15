//
//  MessagesService.swift
//  lab2
//
//  Created by Tomasz Frankiewicz on 15/12/2017.
//  Copyright © 2017 Tomasz Frankiewicz. All rights reserved.
//

import Foundation

class MessagesService {

    init(){
        
    }
    
    func getMessages() -> [Message] {
        let messages = [
            Message(timestamp: Date(), author: "Wojtek", message: "Wiadomosc od Wojtka. Cos ciekawego mam do powiedzenia."),
            Message(timestamp: Date(), author: "Wojtek", message: "Wciaz nie ruszylem lab1."),
            Message(timestamp: Date(), author: "Tomek", message: "Wiem wojcio."),
            Message(timestamp: Date(), author: "Tomek", message: "A jeszcze algosy czekaja.")
        ]
        return messages
    }

}
