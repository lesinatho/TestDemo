//
//  General.swift
//

// MARK: -  General Response model for API 

import Foundation

struct GeneralResponse: Codable {
    var message: String?
    var error: String?
    var status_code: Int?
    var response: String?
}


