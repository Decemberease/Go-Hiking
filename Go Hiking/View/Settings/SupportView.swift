//
//  SupportView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2022-07-06.
//

import SwiftUI

struct SupportView: View {
    let privacyPolicyURL = NSURL(string: "https://anthony55hopkins.wixsite.com/gohiking/privacy-policy")! as URL
    let termsAndConditionsURL = NSURL(string: "https://anthony55hopkins.wixsite.com/gohiking/terms-and-conditions")! as URL
    
    var body: some View {
        Link("View Privacy Policy", destination: privacyPolicyURL)
        Link("View Terms and Conditions", destination: termsAndConditionsURL)
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
