//
//  LobbyViewController.swift
//  Gambler
//
//  Created by Steven Lee on 5/11/19.
//  Copyright © 2019 leavenstee llc. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var viewModel: LobbyViewModel?
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var peerIDs: [MCPeerID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SetupView
        usernameLabel.text = viewModel?.user.username
        
        // Do any additional setup after loading the view.
        peerID = MCPeerID(displayName: viewModel?.user.username ?? "")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    
    // Reference this for sending chips
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
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        
        // Transition to Blackjack Game
        let dealerViewController = LobbyViewController(nibName: "DealerViewController", bundle: nil)
        navigationController?.pushViewController(dealerViewController, animated: true)
    }
    
    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
}

// MARK: MCSessionDelegate

extension LobbyViewController: MCSessionDelegate {
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
        print(data)
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

extension LobbyViewController: MCBrowserViewControllerDelegate {
}

