//
//  LoginTableViewController.swift
//  TestThisApp
//
//  Created by Semen Matsepura on 19.01.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Starscream
import SwiftyJSON

var size = 0

class LoginTableViewController: UITableViewController, WebSocketDelegate {
    
    // MARK: - Property
    
    @IBOutlet weak var indicatorProgress: UIProgressView!
    
    var socket: WebSocket!
    var webSocketReceiveURL = ""
    var dictFromWebSocket = [String:AnyObject]!()
    var updateIndicator: Float = 0.0
    var sourceToCell = [ResponceModel]()
    var countFromSizeScreen = 0
    
    // MARK: - Download Indicator
    
    func indicateSuccess() {
        UIView.animateWithDuration(1) { () -> Void in
            self.updateIndicator += 0.2
            self.indicatorProgress.setProgress(self.updateIndicator, animated: true)
        }
    }
    
    // MARK: - Setup
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.view.frame.width == 320 {
            size = 6
        } else if self.view.frame.width == 375 {
            size = 8
        } else if self.view.frame.width == 414 {
            size = 9
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.width)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        indicateSuccess()
        connectToWebSocket()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - WebSocket
    
    func connectToWebSocket() {
        socket = WebSocket(url: NSURL(string: "ws://54.154.96.23:8082")!)
        socket.delegate = self
        socket.connect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
        indicateSuccess()
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
        webSocketReceiveURL = text
        convertStringToDictionary(text)
        if let url = dictFromWebSocket["url"] as? String{
            webSocketReceiveURL = url
        }
        print(webSocketReceiveURL)
        
        makeRequest()
        indicateSuccess()
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }
    
    // MARK: - Alamofire & SwiftyJSON
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                dictFromWebSocket = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                indicateSuccess()
                return dictFromWebSocket
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func makeRequest() {
        
        Alamofire.request(.GET, webSocketReceiveURL).responseJSON { response in
            switch response.result {
            case .Success:
                
                print(response.description)
                let json = JSON(data: response.data!)
                if let array = json.array {
                    for appDict in array {
                        
                        let images: Array<String>? = appDict["images"].arrayObject as! Array<String>?
                        let id: Int = appDict["id"].intValue
                        let name: String = appDict["name"].stringValue
                        let url: String = appDict["url"].stringValue
                        let time: Int = appDict["time"].intValue
                        let information = ResponceModel(image: images!, id: id, name: name, url: url, time: time)
                        self.sourceToCell.append(information)
                    }
                    self.tableView.reloadData()
                    self.indicateSuccess()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("create cell")
        return self.sourceToCell.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MyTableViewCell
        cell.titleLabel.text = self.sourceToCell[indexPath.row].name
        cell.countPic.text = String(self.sourceToCell[indexPath.row].images.count)
        cell.mainImage.af_setImageWithURL(NSURL(string:self.sourceToCell[indexPath.row].url)!, placeholderImage: UIImage(named: "pic"))
        
        cell.mainImage.layer.borderWidth = 1.0
        cell.mainImage.layer.masksToBounds = false
        cell.mainImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.mainImage.layer.cornerRadius = cell.mainImage.frame.size.width/2
        cell.mainImage.clipsToBounds = true
        cell.heightOfMiniPic.constant = 40
        cell.updateConstraints()
        cell.createPictures(self.sourceToCell[indexPath.row].images)
        cell.heightOfMiniPic.constant += cell.lines * 40
        cell.updateConstraints()
    
        return cell
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SendDataSegue" {
            if let destination = segue.destinationViewController as? TapViewController {
                    let path = self.sourceToCell[(tableView.indexPathForSelectedRow?.row)!]
                print(path.name)
                print(view.frame.width)
                destination.responceFromSegue.append(path)
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("SendDataSegue", sender: self)
        }
    }
}