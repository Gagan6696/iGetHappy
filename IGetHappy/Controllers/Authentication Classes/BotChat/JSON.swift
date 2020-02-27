//
//  JSON.swift
//  IGetHappy
//
//  Created by Gurleen Osahan on 2/12/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
