//
//  ElapsedTime.swift
//  Stanford001
//
//  Created by ZuhuAhmu on 28/03/2026.
//

import SwiftUI

struct ElapsedTime: View {
    
    let startTime : Date
    let endTime : Date?
    
    var body: some View {
        if let endTime {
            Text(endTime, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        } else {
            Text(TimeDataSource<Date>.currentDate, format: .offset(to: startTime, allowedFields: [.minute, .second]))
        }
    }
}

//#Preview {
//    ElapsedTime()
//}
