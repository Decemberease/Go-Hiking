//
//  StatisticsView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-08-23.
//

import SwiftUI

struct StatisticsView: View {
    var body: some View {
        NavigationView {
            Form {
                HikingChartsView()
                HikingRecordsView()
                ActivityAwardsView()
            }
            .navigationBarTitle("Hiking Statistics", displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
