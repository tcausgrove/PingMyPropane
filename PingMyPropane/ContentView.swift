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
    @State private var indicatorPercentage: CGFloat = 50.0
    @StateObject var viewModel = VoiceViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Section {
                    Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    Text("Ping my propane")
                }
                .font(.title2)
                .onTapGesture {
                    indicatorPercentage = CGFloat.random(in: 0...100)
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        viewModel.startRecording()
                    }
                }
                .onAppear {
//                    pingRecorder.prepareEngine()
                }
                Spacer()
                TankFullnessView(indicatorPercentage: $indicatorPercentage)
                Spacer()
                
            }
            .navigationBarTitle("Ping My Propane")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TankFullnessView: View {
    @Binding var indicatorPercentage: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .alignmentGuide(.bottomOfWholeTank) { d in d[VerticalAlignment.bottom]}
                .frame(width: 100, height: 200)
            Rectangle()
                .alignmentGuide(.bottomOfWholeTank) { d in d[VerticalAlignment.bottom]}
                .frame(width: 100, height: indicatorPercentage * 2)
                .foregroundColor(.red)
        }
    }
}
