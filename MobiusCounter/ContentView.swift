//
//  ContentView.swift
//  MobiusCounter
//
//  Created by Bear Cahill on 7/15/24.
//

import SwiftUI
import MobiusCore
import AVFoundation

private func beep() {
    AudioServicesPlayAlertSound(SystemSoundID(1322))
}

class CounterState {
    
    typealias CounterModel = Int
    
    enum CounterEvent {
        case increment
        case decrement
    }
    
    enum CounterEffect {
        case playSound
    }
    
    static var effectHandler = EffectRouter<CounterEffect, CounterEvent>()
        .routeCase(CounterEffect.playSound).to { beep() }
        .asConnectable
    
    static func update(model: CounterModel, event: CounterEvent) -> Next<CounterModel, CounterEffect> {
        switch event {
        case .increment:
            print(model+1)
            return .next(model + 1)
        case .decrement:
            if model == 0 {
                print(model)
                return .dispatchEffects([.playSound])
            } else {
                print(model-1)
                return .next(model - 1)
            }
        }
    }
}

struct ContentView: View {
    static var counterState = CounterState()
    let application = Mobius.loop(update: CounterState.update,
                                  effectHandler: CounterState.effectHandler)
        .start(from: 0)
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Increment") {
                application.dispatchEvent(.increment) // Model is now 1
                
            }
            
            Button("Decrement") {
                application.dispatchEvent(.decrement) // Model is now 0
//                application.dispatchEvent(.decrement) // Sound effect plays! Model is still 0
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
