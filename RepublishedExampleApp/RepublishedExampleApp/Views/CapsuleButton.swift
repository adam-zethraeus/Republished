import SwiftUI

struct CapsuleButton: View {

    let bg: (c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat)
    let fg: CGFloat
    let text: String
    let action: () -> Void

    var body: some View {
        Button(text) { action() }
            .padding(16)
            .background(
                Color(
                    CGColor(
                        genericCMYKCyan: bg.c,
                        magenta: bg.m,
                        yellow: bg.y,
                        black: bg.k,
                        alpha: 1
                    )
                )
            )
            .foregroundColor(
                Color(
                    hue: 0,
                    saturation: 0,
                    brightness: fg
                )
            )
            .clipShape(Capsule())
    }

}
