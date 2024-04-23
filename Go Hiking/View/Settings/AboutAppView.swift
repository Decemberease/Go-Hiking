//
//  AboutApp.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-19.
//

import SwiftUI

struct AboutAppView: View {
    
    let appVersionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let openSourceURL = NSURL(string: "https://github.com/AnthonyH93/GoHiking")! as URL
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShareSheetPresented: Bool = false
    
    var body: some View {
        HStack {
            Text("App Version")
            Spacer()
            Text(appVersionNumber)
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct AboutApp_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
