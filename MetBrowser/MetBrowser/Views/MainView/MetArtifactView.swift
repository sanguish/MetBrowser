//
//  MetArtifactView.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/13/24.
//

import SwiftUI

private struct MetArtifactImage: View {
    var metArtifact: MetArtifact

    var body: some View {
        AsyncImage(url: metArtifact.primaryImageSmall) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                    .shadow(radius: 8)
                    .padding(16)
                    .draggable(image)
            } else if phase.error != nil {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .tint(Color.gray)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
                    .shadow(radius: 8)
                    .padding(16)

            } else {
                ProgressView()
                    .frame(width: 200, height: 200)
                    .padding(16)
            }
        }

    }
}
/// The `MetArtifactView` provides the view that displays an individiual artifact.
struct MetArtifactView: View {
    var metArtifact: MetArtifact

    @ViewBuilder
    func dataLine(label: String, text: String) -> some View {
        Text("\(label): ").bold() + Text(text)
    }
    var body: some View {
        HStack {
            MetArtifactImage(metArtifact: metArtifact)
                .frame(width: 250)
            VStack(alignment: .leading, spacing: 5) {
                Text("Overview")
                    .font(.title)
                Divider()
                dataLine(label: "Title", text: metArtifact.title)
                dataLine(label: "Date", text: metArtifact.objectDate)
                dataLine(label: "Culture", text: metArtifact.culture)
                dataLine(label: "Medium", text: metArtifact.medium)
                dataLine(label: "Classification", text: metArtifact.classification)
                dataLine(label: "Credit Line", text: metArtifact.creditLine)
                dataLine(label: "Public Domain", text: metArtifact.isPublicDomain ? "Yes" : "No")
            }
        }
    }
}
