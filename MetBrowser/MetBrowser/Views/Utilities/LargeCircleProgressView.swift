//
//  CircleProgressView.swift
//  MetBrowser
//
//  Created by Scott Anguish on 3/30/24.
//

import SwiftUI

struct CircleProgressView: View {
    @Binding var percentComplete: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 8))
            Circle()
                .trim(from: 0, to: percentComplete / 100)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .foregroundColor(.green)
                .rotationEffect(.degrees(-90))
            VStack {
                Text("\(Int(percentComplete))%")
                    .font(.title3)
                    .animation(.none)
            }
        }
    }
}
