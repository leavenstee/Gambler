//
//  LobbyViewModel.swift
//  Gambler
//
//  Created by Steven Lee on 5/17/19.
//  Copyright © 2019 leavenstee llc. All rights reserved.
//

import Foundation
import MultipeerConnectivity

final public class LobbyViewModel: NSObject {

    let user: User!
    
    init(user: User) {
        self.user = user
    }

}
