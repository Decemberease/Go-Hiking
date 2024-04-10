//
//  SettingsView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-17.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var hikingStatus: HikingStatus

    var body: some View {
        NavigationView {
            VStack {
                if (hikingStatus.isHiking) {
                    Text("Certain sections are disabled while hiking is in progress. Please end the current hiking session to enable editing of all settings.")
                        .padding(.all, 10)
                }
                Form {
                    Section(header: Text("Customization")) {
                        ColourView()
                        ChangeAppIconView().environmentObject(IconNames())
                    }
                    .disabled(hikingStatus.isHiking)
                    .navigationBarTitle("Settings", displayMode: .inline)
                    Section(header: Text("Hiking Metrics")) {
                        UnitsView()
                    }
                    .disabled(hikingStatus.isHiking)
                    Section(header: Text("Hiking History")) {
                        HikingHistorySettingsView()
                    }
                    .disabled(hikingStatus.isHiking)
                    Section(header: Text("Sync")) {
                        SyncSettingsView()
                    }
                    .disabled(hikingStatus.isHiking)
                    Section(header: Text("Reset")) {
                        ResetView()
                    }
                    .disabled(hikingStatus.isHiking)
                    Section(header: Text("About the app")) {
                        AboutAppView()
                    }
                    Section(header: Text("Support")) {
                        SupportView()
                    }
                }
                .navigationBarTitle(Text("Settings"))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
