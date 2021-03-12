//
//  AppConstant.swift
//

import Foundation

struct AppConstants {
    static let APP_NAME = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOSTestTalk"
    static let AppStore_URL = ""
    static let deviceType           = "ios"
    static let baseURL              = "https://api.github.com/"
}
