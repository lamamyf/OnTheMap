//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Lama AlMayouf on 7/12/20.
//  Copyright © 2020 Lama AlMayouf. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(firstName: String, lastName: String, uniqueKey: String, mapString: String,mediaURL: String, latitude: Double, longitude: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.uniqueKey = uniqueKey
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
}
