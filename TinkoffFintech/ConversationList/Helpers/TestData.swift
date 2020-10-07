//
//  TestData.swift
//  TinkoffFintech
//
//  Created by Anya on 26.09.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
 
struct TestData {
    let conversations: [Conversation]
    
    init() {
        let timestamp = Date().timeIntervalSince1970
        
        let message1 = Message(text: "Hi", date: 1601153289, isRead: true, senderIsMe: true)
        let message2 = Message(text: "Hi!", date: 1601153446, isRead: true, senderIsMe: false)
        let message3 = Message(text: "Not sleeping?", date: 1601153498, isRead: true, senderIsMe: true)
        let message4 = Message(text: "Nope(", date: 1601153543, isRead: true, senderIsMe: false)
        let message5 = Message(text: "Why?", date: 1601153587, isRead: true, senderIsMe: true)
        let message6 = Message(text: "Coding...", date: 1601414505, isRead: false, senderIsMe: false)
        let message7 = Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", date: 1600858552, isRead: true, senderIsMe: false)
        let message8 = Message(text: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.", date: 1600858732, isRead: true, senderIsMe: false)
        let message9 = Message(text: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", date: 1600946572, isRead: true, senderIsMe: true)
        let message10 = Message(text: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium", date: 1600947352, isRead: false, senderIsMe: false)
        let message11 = Message(text: "Totam rem aperiam, eaque ipsa quae ab illo inventore veritatis", date: Int(timestamp) - 1000, isRead: false, senderIsMe: true)
        let message12 = Message(text: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit", date: Int(timestamp) - 1500, isRead: true, senderIsMe: true)
        let message13 = Message(text: "Meeee... 🐑", date: Int(timestamp), isRead: true, senderIsMe: false)
        let message14 = Message(text: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem", date: 1601324557, isRead: false, senderIsMe: false)
        let message15 = Message(text: "👋", date: 1601324557, isRead: true, senderIsMe: true)
        let message16 = Message(text: "How are you?", date: 1601065357, isRead: true, senderIsMe: true)
        let message17 = Message(text: "🤯", date: 1601324557, isRead: false, senderIsMe: false)
        let message18 = Message(text: "Don't know what it means 😕", date: 1601065357, isRead: true, senderIsMe: true)
        let message19 = Message(text: "How much watches?", date: 1601064637, isRead: true, senderIsMe: true)
        let message20 = Message(text: "Ten clocks", date: 1601064647, isRead: true, senderIsMe: false)
        let message21 = Message(text: "Such much?", date: 1601064657, isRead: true, senderIsMe: true)
        let message22 = Message(text: "To whom how…", date: 1601064667, isRead: true, senderIsMe: false)
        let message23 = Message(text: "MGIMO finished?", date: 1601064677, isRead: true, senderIsMe: true)
        let message24 = Message(text: "A-a-a-ask!..", date: 1601064687, isRead: false, senderIsMe: false)
        let message25 = Message(text: "What does the fox say?", date: 1601153587, isRead: true, senderIsMe: false)
        let message26 = Message(text: "Hatee-hatee-hatee-ho!\nHatee-hatee-hatee-ho!\nHatee-hatee-hatee-ho!", date: 1601153587, isRead: true, senderIsMe: true)
        let message27 = Message(text: "🥱🥱🥱🥱🥱\n😴😴😴😴😴", date: Int(timestamp), isRead: false, senderIsMe: false)
        let message28 = Message(text: "You never read messages(", date: Int(timestamp)-2000, isRead: false, senderIsMe: true)
        let message29 = Message(text: "What is your name?", date: 1600947352, isRead: true, senderIsMe: true)
        let message30 = Message(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", date: 1600947362, isRead: true, senderIsMe: false)
        
        
        let conversation1 = Conversation(name: "Mary",
                                         messages: [message1, message2],
                                         isOnline: true)
        let conversation2 = Conversation(name: "Sashka",
                                         messages: [message19, message20, message21, message22, message23, message24],
                                         isOnline: true)
        let conversation3 = Conversation(name: "Vladimir Aleksandrovich",
                                         messages: [message7, message8, message9],
                                         isOnline: false)
        //empty conversations [
        let conversation4 = Conversation(name: "Peter B",
                                         messages: [],
                                         isOnline: true)
        let conversation5 = Conversation(name: "Tom W",
                                         messages: [],
                                         isOnline: false)
        // ]
        let conversation6 = Conversation(name: "Katy",
                                         messages: [message1, message2, message3, message4, message5, message6],
                                         isOnline: true)
        let conversation7 = Conversation(name: "Dad",
                                         messages: [message10, message11],
                                         isOnline: true)
        let conversation8 = Conversation(name: "Dmitry",
                                         messages: [message1, message2, message12],
                                         isOnline: false)
        let conversation9 = Conversation(name: "Ile Lile",
                                         messages: [message7, message11],
                                         isOnline: false)
        let conversation10 = Conversation(name: "Gunter the Sheep",
                                          messages: [message1, message3, message13],
                                          isOnline: false)
        let conversation11 = Conversation(name: "Aleksandr Aleksandrovich Konstantinov",
                                          messages: [message3, message7],
                                          isOnline: true)
        let conversation12 = Conversation(name: "Konstantin Konstantinovich Aleksandrov",
                                          messages: [message12, message14],
                                          isOnline: false)
        let conversation13 = Conversation(name: "Andrew V",
                                          messages: [message2, message15],
                                          isOnline: true)
        let conversation14 = Conversation(name: "Sonya Kim",
                                          messages: [message1, message16, message17],
                                          isOnline: true)
        let conversation15 = Conversation(name: "K K",
                                          messages: [message16, message14, message18],
                                          isOnline: false)
        let conversation16 = Conversation(name: "Mom",
                                          messages: [message10],
                                          isOnline: true)
        let conversation17 = Conversation(name: "Ylvis",
                                          messages: [message25, message26],
                                          isOnline: false)
        let conversation18 = Conversation(name: "Ran Nem",
                                          messages: [message16, message27],
                                          isOnline: false)
        let conversation19 = Conversation(name: "Random Name",
                                          messages: [message15, message28],
                                          isOnline: false)
        let conversation20 = Conversation(name: "",
                                          messages: [message3, message4, message5, message7, message8, message9, message10, message11, message12, message13, message14, message15, message16, message3, message4, message5, message7, message8, message9, message10, message11, message12, message13, message14, message15, message16],
                                          isOnline: false)
        let conversation21 = Conversation(name: "",
                                          messages: [message29, message30],
                                          isOnline: true)
        
        self.conversations = [conversation1, conversation2, conversation3, conversation4, conversation5, conversation6, conversation7, conversation8, conversation9, conversation10, conversation11, conversation12, conversation13, conversation14, conversation15, conversation16, conversation17, conversation18, conversation19, conversation20, conversation21]
    }
}
