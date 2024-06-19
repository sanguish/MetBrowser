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
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .tint(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 100)
                        .clipped()
                        .shadow(radius: 8)
                    Text("Image Unavailable")
                }
                .frame(width: 200, height: 200)
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
    func dataLine(label: String, text: String?) -> some View {
        Text("**\(label):** \(text ?? "")")
            .textSelection(.enabled)
    }

    var shareString: String {
        var outputString = ""
        outputString = outputString + "Title: \(metArtifact.title)\n"
        outputString = outputString + "Date: \(metArtifact.objectDate)\n"
        outputString = outputString + "Culture: \(metArtifact.culture)\n"
        outputString = outputString + "Medium: \(metArtifact.medium)\n"
        outputString = outputString + "Classification: \(metArtifact.classification)\n"
        outputString = outputString + "Credit Line: \(metArtifact.creditLine)\n"
        outputString = outputString + "Public Domain: \(metArtifact.isPublicDomain ? "Yes" : "No")\n"
        return outputString
    }

    var body: some View {
        HStack {
            MetArtifactImage(metArtifact: metArtifact)
                .frame(width: 250)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Overview")
                        .font(.title)
                    Spacer()
                    ShareLink("", item: shareString, subject: Text(metArtifact.title))
                        .buttonStyle(PlainButtonStyle())
                }

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
