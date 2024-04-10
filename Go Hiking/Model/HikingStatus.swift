//
//  HikingStatus.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-05-03.
//

import Foundation
import SwiftUI

class HikingStatus: ObservableObject {
    @Published var isHiking = false
    
    func startedHiking() {
        isHiking = true
    }
    
    func stoppedHiking() {
        isHiking = false
    }
}
