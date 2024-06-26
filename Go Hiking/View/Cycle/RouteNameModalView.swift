//
//  RouteNameModalView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-05-15.
//

import SwiftUI

struct RouteNameModalView: View {
    let persistenceController = PersistenceController.shared

    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showEditModal: Bool
    
    @State private var showModally = true
    @State private var selectedNameIndex = 0
    @State private var namedRoutesViewSelection = NamedRoutesViewSelection.new
    
    @State private var typedRouteName: String = ""
    
    @ObservedObject var routeNamingViewModel = RouteNamingViewModel()
    
    private var HikingToEdit: Hiking?
    
    init(showEditModal: Binding<Bool>, HikingToEdit: Hiking?) {
        if (HikingToEdit != nil) {
            self.HikingToEdit = HikingToEdit
        }
        self._showEditModal = showEditModal
    }
    
    var body: some View {
        VStack {
            Text("Categorize Your Route")
                .font(.headline)
                .padding()
            
            Picker("Selected Category", selection: $namedRoutesViewSelection) {
                Text("Create a New Category").tag(NamedRoutesViewSelection.new)
                Text("Use an Existing Category").tag(NamedRoutesViewSelection.existing)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(EdgeInsets.init(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            switch namedRoutesViewSelection {
            case .new:
                Text("Enter your new category name")
                    
                TextField("Category Name", text: $typedRouteName)
                    .border(Color(UIColor.separator))
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
                // Extra option for existing routes where the category can be removed
                if (self.HikingToEdit != nil) {
                    Divider()
                    Button (action: {self.removeCategoryPressed()}) {
                        Text("Remove From Category")
                            .foregroundColor(Color.red)
                    }
                    .padding()
                }
                Divider()
                Button (action: {self.savePressed()}) {
                    Text("Save")
                }
                .disabled(!((self.typedRouteName.count > 0)))
                .padding()
                Divider()
                Button (action: {self.presentationMode.wrappedValue.dismiss()}) {
                    Text(self.HikingToEdit == nil ? "Save Without a Category" : "Cancel")
                        .bold()
                }
                .padding()
                Divider()
            case .existing:
                if (routeNamingViewModel.routeNames.count > 0) {
                    List {
                        ForEach(0 ..< routeNamingViewModel.routeNames.count, id: \.self) { index in
                        Button(action: {
                            self.selectedNameIndex = index
                        }) {
                            HStack {
                                Text(self.routeNamingViewModel.routeNames[index])
                                Spacer()
                                if self.selectedNameIndex == index {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .foregroundColor(.primary)
                        }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                else {
                    Text("There are no saved categories.")
                }
                Spacer()
                // Extra option for existing routes where the category can be removed
                if (self.HikingToEdit != nil) {
                    Divider()
                    Button (action: {self.removeCategoryPressed()}) {
                        Text("Remove From Category")
                            .foregroundColor(Color.red)
                    }
                    .padding()
                }
                Divider()
                Button (action: {self.savePressed()}) {
                    Text("Save")
                }
                .padding()
                .disabled(!(self.routeNamingViewModel.routeNames.count > 0))
                Divider()
                if (self.HikingToEdit != nil) {
                    Button (action: {self.presentationMode.wrappedValue.dismiss()}) {
                        Text("Cancel")
                            .bold()
                    }
                    .padding()
                    Divider()
                }
            }
        }
        .presentation(isModal: self.showModally) {
        }
        .onAppear {
            if (HikingToEdit != nil && HikingToEdit?.hikingRouteName != "Uncategorized") {
                self.selectedNameIndex = routeNamingViewModel.routeNames.firstIndex(of: HikingToEdit!.hikingRouteName)!
            }
            else {
                self.selectedNameIndex = 0
            }
        }
    }
    
    func savePressed() {
        var routeName = ""
        switch namedRoutesViewSelection {
        case .new:
            routeName = typedRouteName
        case .existing:
            routeName = self.routeNamingViewModel.routeNames[self.selectedNameIndex]
        }
        
        // This means that we are in the Hike tab
        if (self.HikingToEdit == nil) {
            // Get most recent bike ride
            let ride = self.routeNamingViewModel.allHikings[self.routeNamingViewModel.allHikings.count - 1]
            // Route name should be Uncategorized at this point
            if (ride.hikingRouteName == "Uncategorized") {
                persistenceController.updateHikingRouteName(
                    existingHiking: ride,
                    latitudes: ride.hikingLatitudes,
                    longitudes: ride.hikingLongitudes,
                    speeds: ride.hikingSpeeds,
                    distance: ride.hikingDistance,
                    elevations: ride.hikingElevations,
                    startTime: ride.hikingStartTime,
                    time: ride.hikingTime,
                    routeName: routeName)
            }
            self.presentationMode.wrappedValue.dismiss()
            self.showEditModal = false
            self.showModally = false
        }
        else {
            let ride = self.HikingToEdit!
            persistenceController.updateHikingRouteName(
                existingHiking: ride,
                latitudes: ride.hikingLatitudes,
                longitudes: ride.hikingLongitudes,
                speeds: ride.hikingSpeeds,
                distance: ride.hikingDistance,
                elevations: ride.hikingElevations,
                startTime: ride.hikingStartTime,
                time: ride.hikingTime,
                routeName: routeName)
            self.presentationMode.wrappedValue.dismiss()
            self.showEditModal = false
            self.showModally = false
        }
    }
    
    func removeCategoryPressed() {
        let ride = self.HikingToEdit!
        persistenceController.updateHikingRouteName(
            existingHiking: ride,
            latitudes: ride.hikingLatitudes,
            longitudes: ride.hikingLongitudes,
            speeds: ride.hikingSpeeds,
            distance: ride.hikingDistance,
            elevations: ride.hikingElevations,
            startTime: ride.hikingStartTime,
            time: ride.hikingTime,
            routeName: "Uncategorized")
        self.presentationMode.wrappedValue.dismiss()
        self.showEditModal = false
        self.showModally = false
    }
}

// Used for the picker
enum NamedRoutesViewSelection: String, CaseIterable, Identifiable {
    case new
    case existing

    var id: String { self.rawValue }
}

//struct RouteNameModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouteNameModalView()
//    }
//}
