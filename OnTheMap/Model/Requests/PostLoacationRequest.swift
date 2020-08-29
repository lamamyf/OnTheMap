//
//  PostLoacationRequest.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/13/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import Foundation
struct PostLoacationRequest: Codable {
    let uniqueKey, firstName, lastName, mapString: String
    let mediaURL: String
    let latitude, longitude: Double
}
