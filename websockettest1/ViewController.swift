//
//  ViewController.swift
//  websockettest1
//
//  Created by Neuro Leap on 7/26/16.
//  Copyright © 2016 Neuro Leap. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController, NSNetServiceBrowserDelegate, NSNetServiceDelegate, WebSocketDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var address: UITextField!

    var nsb: NSNetServiceBrowser!
    var services = [NSNetService]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {

        UIView.animateWithDuration(1.0, delay: 0, options: [.Repeat, .Autoreverse], animations: {
                                    self.image.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }, completion: nil)
    }

    @IBAction func connect(sender: AnyObject) {
        let socket = WebSocket(url: NSURL(string: "ws://beaglebone.local:12345/")!)
        socket.delegate = self
        socket.connect()
    }


    func aaa() {
        print("listening for services...")
        self.services.removeAll()
        self.nsb = NSNetServiceBrowser()
        self.nsb.delegate = self
        self.nsb.searchForServicesOfType("_http._tcp", inDomain: "local")
    }


    func netServiceBrowser(aNetServiceBrowser: NSNetServiceBrowser, didFindService aNetService: NSNetService, moreComing: Bool) {

        services.append(aNetService)

        print("Found a device \(aNetService)")

        aNetService.delegate = self
        aNetService.resolveWithTimeout(3)
    }

    func netServiceDidResolveAddress(sender: NSNetService) {

        print(sender.addresses)
        print(sender.hostName)
        print(sender.port)
    }
}






extension ViewController {
    func websocketDidConnect(socket: WebSocket) {
        print("websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }

    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("got some text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("got some data: \(data.length)")
    }



}
