//
//  Bundle+.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/13/21.
//

import Foundation

extension Bundle {
    
    func googleApiKey() -> String {
        let GoogleApiKey = "GoogleApiKey"
        let bundle = Bundle.main
        guard let value = (bundle.infoDictionary?[GoogleApiKey] as? String) else {
                assertionFailure("Required Google Api Key missing from infoPlist, please add 'GoogleApiKey' key with value")
            return ""
        }
        return value
    }
    
}
