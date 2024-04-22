//
//  BikeRidesList.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-23.
//

import SwiftUI
import CoreLocation
import CoreData

struct HikingListView: View {
    let persistenceController = PersistenceController.shared
    
    @EnvironmentObject var preferences: Preferences
    
    @ObservedObject var HikingViewModel = HikingListViewModel()
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @State private var showingActionSheet = false
    @State private var showingPopover = false
    @State private var showingFilterPopover = false
    @State private var showingDeleteAlert = false
    @State private var shouldBeDeleted = false
    @State private var showingSheet = false
    @State private var sheetToPresent: SheetToPresent = .filter
    @State private var updateCategories = false
    @State private var toBeDeleted: IndexSet?
    @State private var sortChoice: SortChoice = .dateDescending
    @State private var selectedName: String = Preferences.storedSelectedRoute()
    
    @State var sortDescriptor = NSSortDescriptor(keyPath: \Hiking.hikingTime, ascending: false)
    
    var body: some View {
        NavigationView {
            GeometryReader { (geometry) in
                ListView(sortDescripter: HikingViewModel.getSortDescriptor(), name: HikingViewModel.currentName, showingDeleteAlert: $showingDeleteAlert, shouldBeDeleted: $shouldBeDeleted, updateCategories: $updateCategories)
                .listStyle(PlainListStyle())
                    .navigationBarTitle(self.getNavigationBarTitle(name: HikingViewModel.currentName), displayMode: .automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if (preferences.namedRoutes && HikingViewModel.filterEnabledCheck()) {
                            Button (HikingViewModel.getFilterActionSheetTitle()) {
                                self.sheetToPresent = .filter
                                self.showingSheet = true
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if (preferences.namedRoutes && HikingViewModel.editEnabledCheck()) {
                            Button ("Edit") {
                                self.sheetToPresent = .edit
                                self.showingSheet = true
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button (HikingViewModel.getSortActionSheetTitle()) {
                            if (min(geometry.size.width, geometry.size.height) < 600) {
                                self.showingActionSheet = true
                            }
                            else {
                                showingPopover.toggle()
                            }
                        }
                        .popover(isPresented: $showingPopover) {
                            HikingSortPopoverView(showingPopover: $showingPopover, sortChoice: $sortChoice)
                        }
                    }
                }
                .onAppear {
                    sortChoice = HikingViewModel.currentSortChoice
                    HikingViewModel.updateCategories()
                }
                // Filter action sheet
                .sheet(isPresented: $showingSheet, content: {
                    switch sheetToPresent {
                    case .filter:
                        HikingFilterSheetView(showingSheet: $showingSheet, selectedName: $selectedName, names: HikingViewModel.categories)
                    case .edit:
                        RouteRenameModalView(showEditModal: $showingSheet, names: HikingViewModel.categories)
                    }
                })
                // Sort action sheet
                .actionSheet(isPresented: $showingActionSheet, content: {
                    ActionSheet(title: Text("Sort"), message: Text("Set your preferred sorting order."), buttons:[
                        .default(Text("Date Descending (Default)"), action: HikingViewModel.sortByDateDescending),
                        .default(Text("Date Ascending"), action: HikingViewModel.sortByDateAscending),
                        .default(Text("Distance Descending"), action: HikingViewModel.sortByDistanceDescending),
                        .default(Text("Distance Ascending"), action: HikingViewModel.sortByDistanceAscending),
                        .default(Text("Time Descending"), action: HikingViewModel.sortByTimeDescending),
                        .default(Text("Time Ascending"), action: HikingViewModel.sortByTimeAscending),
                        .cancel()
                    ])
                })
                .onChange(of: HikingViewModel.currentSortChoice, perform: { _ in
                    preferences.updateStringPreference(preference: CustomizablePreferences.sortingChoice, value: HikingViewModel.currentSortChoice.rawValue)
                })
                .onChange(of: sortChoice, perform: { value in
                    switch sortChoice {
                    case .distanceAscending:
                        HikingViewModel.sortByDistanceAscending()
                    case .distanceDescending:
                        HikingViewModel.sortByDistanceDescending()
                    case .dateAscending:
                        HikingViewModel.sortByDateAscending()
                    case .dateDescending:
                        HikingViewModel.sortByDateDescending()
                    case .timeAscending:
                        HikingViewModel.sortByTimeAscending()
                    case .timeDescending:
                        HikingViewModel.sortByTimeDescending()
                    }
                })
                .onChange(of: selectedName, perform: { _ in
                    HikingViewModel.setCurrentName(name: selectedName)
                })
                .onChange(of: HikingViewModel.currentName, perform: { _ in
                    preferences.updateStringPreference(preference: CustomizablePreferences.selectedRoute, value: HikingViewModel.currentName)
                })
                .onChange(of: updateCategories, perform: { _ in
                    /* For iOS 15 */
                    if #available(iOS 15, *) {
                        HikingViewModel.updateCategories()
                    }
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        // Move alert outside of navigation view due to a SwiftUI bug
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Are you sure that you want to delete this route?"),
                  message: Text("This action is not reversible."),
                  primaryButton: .destructive(Text("Delete")) {
                    self.shouldBeDeleted = true
                  },
                  secondaryButton: .cancel() {
                    self.shouldBeDeleted = false
                  }
            )
        }
    }
    
    func getNavigationBarTitle(name: String) -> String {
        if (preferences.namedRoutes) {
            return (name == "") ? "Hiking History" : name
        }
        else {
            return "Hiking History"
        }
    }
}

struct ListView: View {
    let persistenceController = PersistenceController.shared
    
    @EnvironmentObject var preferences: Preferences
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @Binding private var showingDeleteAlert: Bool
    @Binding private var shouldBeDeleted: Bool
    @Binding private var updateCategories: Bool
    
    @State private var toBeDeleted: IndexSet?
    
    @FetchRequest var hikings: FetchedResults<Hiking>

    init(sortDescripter: NSSortDescriptor, name: String, showingDeleteAlert: Binding<Bool>, shouldBeDeleted: Binding<Bool>, updateCategories: Binding<Bool>) {
        let request: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        if (name != "") {
            request.predicate = NSPredicate(format: "hikingRouteName == %@", name)
        }
        request.sortDescriptors = [sortDescripter]
        _hikings = FetchRequest<Hiking>(fetchRequest: request)
        self._showingDeleteAlert = showingDeleteAlert
        self._shouldBeDeleted = shouldBeDeleted
        self._updateCategories = updateCategories
    }

    var body: some View {
        if (hikings.count > 0) {
            List {
                ForEach(hikings) { bikeRide in
                    NavigationLink(destination: SingleHikingView(bikeRide: bikeRide, navigationTitle: MetricsFormatting.formatDate(date: bikeRide.hikingStartTime))) {
                        // Bike ride list cell
                        VStack(spacing: 10) {
                            HStack {
                                Text(MetricsFormatting.formatDate(date: bikeRide.hikingStartTime))
                                    .font(.headline)
                                    .foregroundColor(Color(UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                                Spacer()
                                Text(MetricsFormatting.formatStartTime(date: bikeRide.hikingStartTime))
                                    .font(.headline)
                                    .foregroundColor(Color(UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                            }
                            HStack {
                                Text("Distance Hiked")
                                Spacer()
                                Text(MetricsFormatting.formatDistance(distance: bikeRide.hikingDistance, usingMetric: preferences.usingMetric))
                                    .font(.headline)
                            }
                            HStack {
                                Text("Hiking Time")
                                Spacer()
                                Text(MetricsFormatting.formatTime(time: bikeRide.hikingTime))
                                    .font(.headline)
                            }
                            HStack {
                                Text("Average Speed")
                                Spacer()
                                Text(MetricsFormatting.formatAverageSpeed(speeds: bikeRide.hikingSpeeds, distance: bikeRide.hikingDistance, time: bikeRide.hikingTime, usingMetric: preferences.usingMetric))
                                    .font(.headline)
                            }
                        }
                    }
                }
                .onDelete(perform: preferences.deletionEnabled ?  self.showDeleteAlert : nil)
                .onChange(of: shouldBeDeleted, perform: { _ in
                    if (shouldBeDeleted == true) {
                        self.deleteHiking(at: self.toBeDeleted!)
                        self.toBeDeleted = nil
                    }
                })
            }
        }
        else {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("No completed routes to display!")
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    func showDeleteAlert(at indexSet: IndexSet) {
        // Show alert
        if (preferences.deletionConfirmation && preferences.deletionEnabled) {
            self.showingDeleteAlert = true
            self.toBeDeleted = indexSet
        }
        // Delete without alert
        else if (preferences.deletionEnabled) {
            deleteHiking(at: indexSet)
        }
    }
    
    func deleteHiking(at indexSet: IndexSet) {
        self.shouldBeDeleted = false
        for index in indexSet {
            managedObjectContext.delete(hikings[index])
        }
        do {
            try managedObjectContext.save()
            updateCategories.toggle()
        } catch {
            print(error.localizedDescription)
        }
    }

}

// To decide which sheet to present
enum SheetToPresent: String, CaseIterable, Identifiable {
    case filter
    case edit

    var id: String { self.rawValue }
}

struct HikingListView_Previews: PreviewProvider {
    static var previews: some View {
        HikingListView()
    }
}
