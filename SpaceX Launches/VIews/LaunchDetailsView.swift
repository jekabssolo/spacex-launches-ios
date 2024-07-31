//
//  LaunchDetailsView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 31/07/2024.
//

import SwiftUI

struct LaunchDetailsView: View {
    let launch: Launch
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(launch.name)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                if let image = launch.flickrImages.first
                    ?? launch.patchImageLarge
                    ?? launch.patchImageSmall
                {
                    AsyncImage(url: URL(string: image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 10))
                    .padding()
                }
                if launch.hasLinks() {
                    Text("Links:")
                    HStack {
                        if let article = launch.article,
                           let articleUrl = URL(string: article) {
                            Link(destination: articleUrl, label: {
                                Text("Article")
                            })
                            Divider()
                        }
                        if let wikipedia = launch.wikipedia,
                           let wikipediaUrl = URL(string: wikipedia) {
                            Link(destination: wikipediaUrl, label: {
                                Text("Wikipedia")
                            })
                            Divider()
                        }
                        if let presskit = launch.presskit,
                           let presskitUrl = URL(string: presskit) {
                            Link(destination: presskitUrl, label: {
                                Text("Presskit")
                            })
                        }
                    }
                    .padding()
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
}

#Preview("Full data") {
    LaunchDetailsView(launch: Launch.sampleLaunches[0])
}

#Preview("Only badges & image") {
    LaunchDetailsView(launch: Launch.sampleLaunches[1])
}

#Preview("Badges only") {
    LaunchDetailsView(launch: Launch.sampleLaunches[2])
}

