//
//  HikingRecordsView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-08-30.
//

import SwiftUI

struct HikingRecordsView: View {
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var records: HikingRecords
    
    var body: some View {
        Section(header: Text(RecordsFormatting.headerStrings[0]), footer: Text(RecordsFormatting.getHikingRecordsFooterText(usingMetric: preferences.usingMetric))) {
            VStack {
                HStack {
                    Text("Single Route Records")
                        .font(.headline)
                        .foregroundColor(Color(UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                    Spacer()
                }
                HikingSingleRecordView(recordValue: MetricsFormatting.formatDistance(distance: records.longestHikingDistance, usingMetric: preferences.usingMetric), recordName: RecordsFormatting.recordsStrings[3], recordDate: RecordsFormatting.formatOptionalDate(date: records.longestHikingDistanceDate), firstEntry: true)
                HikingSingleRecordView(recordValue: MetricsFormatting.formatTime(time: records.longestHikingTime), recordName: RecordsFormatting.recordsStrings[4], recordDate: RecordsFormatting.formatOptionalDate(date: records.longestHikingTimeDate), firstEntry: false)
                HikingSingleRecordView(recordValue: MetricsFormatting.formatSingleSpeed(speed: records.fastestAverageSpeed, usingMetric: preferences.usingMetric), recordName: RecordsFormatting.recordsStrings[5], recordDate: RecordsFormatting.formatOptionalDate(date: records.fastestAverageSpeedDate), firstEntry: false)
            }
            VStack {
                HStack {
                    Text("Cummulative Records")
                        .font(.headline)
                        .foregroundColor(Color(UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                    Spacer()
                }
                HikingSingleRecordView(recordValue: MetricsFormatting.formatDistance(distance: records.totalHikingDistance, usingMetric: preferences.usingMetric), recordName: RecordsFormatting.recordsStrings[0], recordDate: nil, firstEntry: true)
                HikingSingleRecordView(recordValue: MetricsFormatting.formatTime(time: records.totalHikingTime), recordName: RecordsFormatting.recordsStrings[1], recordDate: nil, firstEntry: false)
                HikingSingleRecordView(recordValue: "\(records.totalHikingRoutes)", recordName: RecordsFormatting.recordsStrings[2], recordDate: nil, firstEntry: false)
            }
        }
    }
}

struct HikingRecordsView_Previews: PreviewProvider {
    static var previews: some View {
        HikingRecordsView()
    }
}
