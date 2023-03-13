//
//  ContentView.swift
//  PingMyPropane
//
//  Created by Timothy Causgrove on 3/11/23.
//

import SwiftUI
import AVFoundation

extension VerticalAlignment {
    enum BottomOfWholeTank: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.bottom]
        }
    }

    static let bottomOfWholeTank = VerticalAlignment(BottomOfWholeTank.self)
}

struct ContentView: View {
    @State var indicatorPercentage: CGFloat = 50.0
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Section {
                    Image(systemName: "record.circle")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Ping my propane")
                }
                .onTapGesture {
                    indicatorPercentage = CGFloat.random(in: 0...100)
                }
                Spacer()
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .alignmentGuide(.bottomOfWholeTank) { d in d[VerticalAlignment.bottom]}
                        .frame(width: 100, height: 200)
                    Rectangle()
                        .alignmentGuide(.bottomOfWholeTank) { d in d[VerticalAlignment.bottom]}
                        .frame(width: 100, height: indicatorPercentage * 2)
                        .foregroundColor(.red)
                }
                Spacer()
                
            }
        }
        .padding()
    }
}

func recordPing() {
// Finish this later
    
//    let engine = AVAudioEngine()
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
