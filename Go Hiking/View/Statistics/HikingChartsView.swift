//
//  HikingChartsView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-08-31.
//

import SwiftUI
import CoreData

struct HikingChartsView: View {
    var invalidData: Bool
    @FetchRequest var HikingsIn1Week: FetchedResults<Hiking>
    @FetchRequest var HikingsIn1WeekBefore: FetchedResults<Hiking>
    @FetchRequest var HikingsIn5Weeks: FetchedResults<Hiking>
    @FetchRequest var HikingsIn5WeeksBefore: FetchedResults<Hiking>
    @FetchRequest var HikingsIn26Weeks: FetchedResults<Hiking>
    @FetchRequest var HikingsIn26WeeksBefore: FetchedResults<Hiking>

    init() {
        self.invalidData = false
        
        let requests: [NSFetchRequest<Hiking>?] = Hiking.fetchRequestsWithDateRanges()
        let countNils = requests.filter({ $0 == nil }).count
        // Use default fetch requests if any of the date range requests failed
        if (countNils > 0 && requests.count == 6) {
            self.invalidData = true
            let request: NSFetchRequest<Hiking> = Hiking.fetchRequest()
            request.sortDescriptors = []
            self._HikingsIn1Week = FetchRequest<Hiking>(fetchRequest: request)
            self._HikingsIn1WeekBefore = FetchRequest<Hiking>(fetchRequest: request)
            self._HikingsIn5Weeks = FetchRequest<Hiking>(fetchRequest: request)
            self._HikingsIn5WeeksBefore = FetchRequest<Hiking>(fetchRequest: request)
            self._HikingsIn26Weeks = FetchRequest<Hiking>(fetchRequest: request)
            self._HikingsIn26WeeksBefore = FetchRequest<Hiking>(fetchRequest: request)
        }
        // Otherwise, use the correct date range requests - it is safe to force unwrap here
        else {
            self._HikingsIn1Week = FetchRequest<Hiking>(fetchRequest: requests[0]!)
            self._HikingsIn1WeekBefore = FetchRequest<Hiking>(fetchRequest: requests[1]!)
            self._HikingsIn5Weeks = FetchRequest<Hiking>(fetchRequest: requests[2]!)
            self._HikingsIn5WeeksBefore = FetchRequest<Hiking>(fetchRequest: requests[3]!)
            self._HikingsIn26Weeks = FetchRequest<Hiking>(fetchRequest: requests[4]!)
            self._HikingsIn26WeeksBefore = FetchRequest<Hiking>(fetchRequest: requests[5]!)
        }
    }
    
    var body: some View {
        Section (header: Text(RecordsFormatting.headerStrings[1]), footer: Text(RecordsFormatting.footerStrings[0])) {
            if (!self.invalidData) {
                List {
                    ForEach (0..<3) { index in
                        NavigationLink(destination: BarChartView(index: index)) {
                            SingleChartListCellView(distances: self.getDistanceData(index: index), times: self.getTimeData(index: index), numberOfRoutes: self.getNumberOfRoutes(index: index), index: index)
                        }
                    }
                }
            }
            else {
                Text("Unable to retrieve hiking data at this time.")
            }
        }
    }
    
    // Functions to extract important data from the fetched data
    func getDistanceData(index: Int) -> [Double] {
        var result: [Double] = [0.0, 0.0]
        if (index == 0) {
            for entry in HikingsIn1WeekBefore {
                result[0] += entry.hikingDistance
            }
            for entry in HikingsIn1Week {
                result[1] += entry.hikingDistance
            }
        }
        if (index == 1) {
            for entry in HikingsIn5WeeksBefore {
                result[0] += entry.hikingDistance
            }
            for entry in HikingsIn5Weeks {
                result[1] += entry.hikingDistance
            }
        }
        if (index == 2) {
            for entry in HikingsIn26WeeksBefore {
                result[0] += entry.hikingDistance
            }
            for entry in HikingsIn26Weeks {
                result[1] += entry.hikingDistance
            }
        }
        return result
    }
    
    func getTimeData(index: Int) -> [Double] {
        var result: [Double] = [0.0, 0.0]
        if (index == 0) {
            for entry in HikingsIn1WeekBefore {
                result[0] += entry.hikingTime
            }
            for entry in HikingsIn1Week {
                result[1] += entry.hikingTime
            }
        }
        if (index == 1) {
            for entry in HikingsIn5WeeksBefore {
                result[0] += entry.hikingTime
            }
            for entry in HikingsIn5Weeks {
                result[1] += entry.hikingTime
            }
        }
        if (index == 2) {
            for entry in HikingsIn26WeeksBefore {
                result[0] += entry.hikingTime
            }
            for entry in HikingsIn26Weeks {
                result[1] += entry.hikingTime
            }
        }
        return result
    }
    
    func getNumberOfRoutes(index: Int) -> [Int] {
        if (index == 0) {
            return [HikingsIn1WeekBefore.count, HikingsIn1Week.count]
        }
        if (index == 1) {
            return [HikingsIn5WeeksBefore.count, HikingsIn5Weeks.count]
        }
        if (index == 2) {
            return [HikingsIn26WeeksBefore.count, HikingsIn26Weeks.count]
        }
        return [0, 0]
    }
}

//struct HikingChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HikingChartsView()
//    }
//}
