//
//  RouteNamingViewModel.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-05-15.
//

import Foundation
import SwiftUI

class RouteNamingViewModel: ObservableObject {

    @Published var allHikings: [Hiking] = Hiking.allHikings()
    @Published var routeNames: [String] = Hiking.allRouteNames()
    
}

