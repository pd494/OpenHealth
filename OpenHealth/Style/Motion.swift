import SwiftUI

enum Motion {
    static let press = Animation.easeOut(duration: 0.15)
    static let state = Animation.spring(duration: 0.3, bounce: 0)
    static let fill = Animation.spring(duration: 0.9, bounce: 0)
    static let enter = Animation.easeOut(duration: 0.3)
    static let exit = Animation.easeOut(duration: 0.15)

    /// Reduce Motion turns every movement into a short cross-fade rather than removing feedback.
    static func resolve(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? exit : animation
    }
}

func withMotion<T>(_ animation: Animation = Motion.state, reduceMotion: Bool, _ body: () throws -> T) rethrows -> T {
    try withAnimation(Motion.resolve(animation, reduceMotion: reduceMotion), body)
}
