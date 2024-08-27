//
//  String.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 04.07.24.
//

import Foundation

extension String {
    var isEmptyOrWhitespaces : Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
