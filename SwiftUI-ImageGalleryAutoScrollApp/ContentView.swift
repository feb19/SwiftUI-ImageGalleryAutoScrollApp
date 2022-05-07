//
//  ContentView.swift
//  SwiftUI-ImageGalleryAutoScrollApp
//
//  Created by Nobuhiro Takahashi on 2022/05/07.
//

import SwiftUI

struct ContentView: View {
    private var numberOfImages = 5
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common)
        .autoconnect()
    @State private var currentIndex = 0
    let imageNames = [
        "myles-tan-IWCljYv1TJw-unsplash",
        "chris-holder-uY2UIyO5o5c-unsplash",
        "pars-sahin-V7uP-XzqX18-unsplash",
        "leon-contreras-YndHL7gQIJE-unsplash",
        "baikang-yuan-VDYAsdbHVhc-unsplash"
    ]

    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }

    func startTimer() {
        self.timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
    }

    func previous() {
        stopTimer()
        withAnimation {
            startTimer()
            currentIndex = currentIndex > 0 ? currentIndex - 1 : numberOfImages - 1
        }
    }

    func next() {
        stopTimer()
        withAnimation {
            startTimer()
            currentIndex = currentIndex < numberOfImages ? currentIndex + 1 : 0
        }
    }

    var controls: some View {
        HStack {
            Button {
                previous()
            } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
                .frame(width: 100)
            Button {
                next()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .accentColor(.primary)
        .padding()
    }

    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { proxy in
                TabView(selection: $currentIndex) {
                    ForEach(0 ..< numberOfImages, id:\.self) { num in
                        Image(imageNames[num])
                            .resizable()
                            .scaledToFill()
                            .tag(num)
                    }
                }
                .tabViewStyle(.page)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding()
                .onReceive(timer) { _ in
                    next()
                }
            }
            Spacer()
            controls
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
