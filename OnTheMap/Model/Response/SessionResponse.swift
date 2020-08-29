//
//  Account.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/11/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import Foundation


// MARK: - Account
struct Account: Codable {
    let registered: Bool
    let key: String
}

// MARK: - Session
struct Session: Codable {
    let id, expiration: String
}

// MARK: - SessionResponse
struct SessionResponse: Codable {
    let account: Account
    let session: Session
}
