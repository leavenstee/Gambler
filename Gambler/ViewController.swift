//
//  ViewController.swift
//  Gambler
//
//  Created by Steven Lee on 4/11/19.
//  Copyright © 2019 leavenstee llc. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    var peerIDs: [MCPeerID] = []

    // Demo Background Image
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }

    func sendImage(img: UIImage) {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    @IBAction func hostButtonCommand(_ sender: Any) {
        let alert = UIAlertAction(title: "Host Now?", style: .default, handler: nil)
        startHosting(action: alert)
    }
    
    @IBAction func joinButtonCommand(_ sender: Any) {
         let alert = UIAlertAction(title: "Join Now?", style: .default, handler: nil)
        joinSession(action: alert)
    }
    
    @IBAction func sendImageCommand(_ sender: Any) {
        sendImage(img: #imageLiteral(resourceName: "clock (2)"))
    }
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

}

// MARK: MCSessionDelegate

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            peerIDs.append(peerID)
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            fatalError()
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [weak self] in
                // do something with the image
                self?.imageView.image = image
                print(peerID.displayName)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}

// MARK: MCBrowserViewControllerDelegate

extension ViewController: MCBrowserViewControllerDelegate {
}

