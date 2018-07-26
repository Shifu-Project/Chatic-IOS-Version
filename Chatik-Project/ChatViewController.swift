//
//  ChatViewController.swift
//  Chatik-Project
//
//  Created by Александр Сахнюков on 26/07/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    var messageBase = Array<Message>()

    var manager:SocketManager!
    var socket: SocketIOClient!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return  messageBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatMessageCellTableViewCell
      
        let cellItem = messageBase[indexPath.row]
        cell.MessageText.text = cellItem.content
        cell.DateLable.text = cellItem.date
        cell.userNmae.text = cellItem.username
        
        return cell
    }

 
    @IBOutlet weak var ChatTableview: UITableView!
   
    @IBAction func SendMessageButton(_ sender: UIButton) {
 let  messa = Message(content: "dasda", username: "dasda", date: "dasda")
        messageBase.append(messa)
        //  socketIOClient.emit("msg", MessageText.text!)
       MessageText.text = nil
        self.ChatTableview.reloadData()
   self.scrollToBottom()
        return
    }
    
    
    @IBOutlet weak var MessageText: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
        manager = SocketManager(socketURL: URL(string: "http://138.68.234.86:7777/")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
       
        
        
       
        
        
        socket.on("message", callback: { data, ack in
                let content = data[0] as! String
                let date = data[1] as! String
                let username = data[2] as! String
            
                let message = Message(content: content, username: username, date: date)
                print("Пиздец \(message)")
                
                
                self.messageBase.append(message)
                let indexPath = NSIndexPath(row: self.messageBase.count - 1, section: 0)
                self.ChatTableview.insertRows(at: [indexPath as IndexPath], with: .automatic)
                
                self.ChatTableview.reloadData()
   

    
        })
        socket.connect()
    }
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
        
      
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func scrollToBottom() {
        let lastRowIndexPath = NSIndexPath(row: self.messageBase.count - 1, section: 0)
        self.ChatTableview.scrollToRow(at: lastRowIndexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
}
    
   
    
}
