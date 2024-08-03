// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct StringSpinnerView: View {
	@Binding var animating: Bool
	var symbolGroups: [String]
	var distinctFirst: Bool
	
	public init(animating: Binding<Bool>, symbolGroups: [String], distinctFirst: Bool = false) {
		self._animating = animating
		self.symbolGroups = symbolGroups
		self.distinctFirst = distinctFirst
	}
	
	public var body: some View {
		VStack {
			GeometryReader { geometry in
				Circle()
					.frame(maxHeight: .infinity)
					.foregroundStyle(Color.clear)
					.background {
						ForEach(Array(symbolGroups.enumerated()), id: \.self.offset) { idx, symbols in
							let time = Double(symbols.count / symbolGroups.count / max(idx, 1))
							ForEach(Array(symbols.map { String($0) }.enumerated()), id: \.self.offset) { index, char in
								let angle = Double((index * 360/symbols.count))
								let char = distinctFirst ? index == 0 ? String(char).uppercased() : String(char) : String(char)
								displaySymbols(char, angle: angle, size: geometry.size.width/2 - CGFloat(idx) * 30)
									.fontWeight(distinctFirst ? index == 0 ? .bold : .regular : .regular)
							}
							.rotationEffect(.degrees(animating ? idx % 2 == 0 ? 360 : -360 : 0))
							.animation(animating ? .linear(duration: time).repeatForever() : .linear(duration: 0.5),  value: animating)
						}
					}
			}
		}
		.onAppear(perform: {
			animating.toggle()
		})
		.padding()
	}
	
	func displaySymbols(_ symbol: String, angle: Double, size: CGFloat) -> some View {
		return Text(symbol)
			.font(.title)
			.offset(x: size)
			.rotationEffect(.degrees(angle))
			.animation(.linear(duration: 0.5), value: angle)
	}
}

struct PreviewView: View {
	@State private var toggle = false
	var body: some View {
		VStack {
			StringSpinnerView(animating: $toggle, symbolGroups: ["asdfqwertyuio", "1234567890"])
			Toggle(isOn: $toggle, label: {
				Text("Toggle")
			})
		}
	}
}

#Preview {
	PreviewView()
}
