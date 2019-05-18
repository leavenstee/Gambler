//
//  OnboardingViewController.swift
//  Gambler
//
//  Created by Steven Lee on 5/11/19.
//  Copyright © 2019 leavenstee llc. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var viewModel: OnboardingViewModel?

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = viewModel?.randomUsername
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            usernameTextField.text = viewModel?.randomUsername
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let viewModel = viewModel else {
            fatalError("ViewModel Needs to be implmented to get past here")
        }
        viewModel.username = usernameTextField.text
        
        if viewModel.createAccountError == nil {
            // Transition to Lobby
            transitionToLobby()
        } else {
            // Show Error Toast
            print("Error Messege")
        }
    }
    
    private func transitionToLobby() {
        let lobbyViewController = LobbyViewController(nibName: "LobbyViewController", bundle: nil)
        present(lobbyViewController, animated: true, completion: nil)
    }
}
