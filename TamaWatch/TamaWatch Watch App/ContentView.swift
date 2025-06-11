//
//  ContentView.swift
//  TamaWatch Watch App
//
//  Created by David Guffre on 6/11/25.
//

import SwiftUI

enum TamagotchiState {
	case idle, sleeping, eating, happy
}

struct PixelArtTamagotchi: View {
	let state: TamagotchiState
	let isBreathing: Bool
	let isSleepingAnim: Bool
	let isChewing: Bool
	let isHappyAnim: Bool

	// 11x11 grid, change color pattern per state/anim
	private func pixels() -> [[Color?]] {
		// Skull pixel art, eyes/nose/mouth change per state
		// nil = transparent pixel
		switch state {
		case .sleeping:
			return PixelArtTamagotchi.sleeping
		case .eating:
			return isChewing ? PixelArtTamagotchi.eating2 : PixelArtTamagotchi.eating1
		case .happy:
			return isHappyAnim ? PixelArtTamagotchi.happy2 : PixelArtTamagotchi.happy1
		default:
			return isBreathing ? PixelArtTamagotchi.idle2 : PixelArtTamagotchi.idle1
		}
	}

	var body: some View {
		let grid = pixels()
		VStack(spacing: 0) {
			ForEach(0..<grid.count, id: \.self) { row in
				HStack(spacing: 0) {
					ForEach(0..<grid[row].count, id: \.self) { col in
						Rectangle()
							.fill(grid[row][col] ?? .clear)
							.frame(width: 7, height: 7)
					}
				}
			}
		}
		.frame(width: 77, height: 77)
	}

	// MARK: - Pixel patterns (11x11) for each state (skull style)

	static let o = nil as Color? // shorthand for clear
	static let W = Color.white // bone
	static let B = Color.black // eyes/nose/mouth

	// Idle (breathing off) skull
	static let idle1: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, B, W, W, W, B, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, B, W, W, W, W, W, W, B, W, o],
		[W, W, B, W, B, B, W, B, W, W, o],
		[W, W, W, B, W, W, B, W, W, W, o],
		[o, W, W, W, B, B, W, W, W, o, o],
		[o, o, W, W, W, W, W, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Idle (breathing on) skull - eyes/nose slightly changed to simulate breathing
	static let idle2: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, o, W, W, W, o, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, o, W, W, W, W, W, W, o, W, o],
		[W, W, o, W, B, B, W, o, W, W, o],
		[W, W, W, o, W, W, o, W, W, W, o],
		[o, W, o, W, B, B, W, o, W, o, o],
		[o, o, W, o, W, W, o, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Sleeping skull - eyes closed (black pixels replaced by bone except nose)
	static let sleeping: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, W, W, W, W, W, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, o, W, W, W, W, W, W, o, W, o],
		[W, W, o, W, B, B, W, o, W, W, o],
		[W, W, W, o, W, W, o, W, W, W, o],
		[o, W, o, W, W, W, W, o, W, o, o],
		[o, o, W, o, W, W, o, W, o, o, o],
		[o, o, W, o, o, o, o, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Eating1 skull - mouth showing teeth (black pixels in mouth)
	static let eating1: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, B, W, W, W, B, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, B, W, W, W, W, W, W, B, W, o],
		[W, W, B, W, B, B, W, B, W, W, o],
		[W, W, W, B, B, B, B, B, W, W, o],
		[o, W, W, W, B, B, W, W, W, o, o],
		[o, o, W, W, W, W, W, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Eating2 skull - mouth open slightly more (teeth spread)
	static let eating2: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, B, W, W, W, B, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, B, W, W, W, W, W, W, B, W, o],
		[W, W, o, B, B, B, B, o, W, W, o],
		[W, W, o, B, B, B, B, o, W, W, o],
		[o, W, W, W, B, B, W, W, W, o, o],
		[o, o, W, W, W, W, W, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Happy1 skull - smile mouth (curved teeth)
	static let happy1: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, B, W, W, W, B, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, B, W, W, W, W, W, W, B, W, o],
		[W, W, B, W, B, B, W, B, W, W, o],
		[W, W, W, o, W, W, o, W, W, W, o],
		[o, W, W, W, B, B, W, W, W, o, o],
		[o, o, W, W, W, W, W, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
	// Happy2 skull - bigger smile (mouth slightly more open)
	static let happy2: [[Color?]] = [
		[o, o, o, o, W, W, W, o, o, o, o],
		[o, o, W, W, W, W, W, W, W, o, o],
		[o, W, W, B, W, W, W, B, W, W, o],
		[W, W, W, W, W, W, W, W, W, W, W],
		[W, B, W, W, W, W, W, W, B, W, o],
		[W, o, B, B, B, B, B, B, o, W, o],
		[W, o, o, W, W, W, o, o, W, W, o],
		[o, W, W, W, B, B, W, W, W, o, o],
		[o, o, W, W, W, W, W, W, o, o, o],
		[o, o, W, B, B, B, B, W, o, o, o],
		[o, o, o, o, W, W, o, o, o, o, o],
	]
}

struct ContentView: View {
	@State private var state: TamagotchiState = .idle
	@State private var isBreathing = false
	@State private var isSleepingAnim = false
	@State private var isChewing = false
	@State private var isHappyAnim = false

	var body: some View {
		VStack(spacing: 12) {
			ZStack {
				PixelArtTamagotchi(state: state, isBreathing: isBreathing, isSleepingAnim: isSleepingAnim, isChewing: isChewing, isHappyAnim: isHappyAnim)
					.offset(y: state == .sleeping ? (isSleepingAnim ? 2 : -2) : 0)
					.animation(state == .sleeping ? .easeInOut(duration: 1.8).repeatForever(autoreverses: true) : .default, value: isSleepingAnim)
					.scaleEffect((state == .idle && isBreathing) ? 1.03 : (state == .idle ? 1.0 : 1))
					.animation(state == .idle ? .easeInOut(duration: 1.8).repeatForever(autoreverses: true) : .default, value: isBreathing)
					.scaleEffect(state == .happy ? (isHappyAnim ? 1.08 : 1.0) : 1)
					.animation(state == .happy ? .easeInOut(duration: 0.7).repeatForever(autoreverses: true) : .default, value: isHappyAnim)
					.frame(height: 100)

				// Food for eating state
				if state == .eating {
					VStack {
						Spacer()
						Image(systemName: "leaf.fill")
							.resizable()
							.frame(width: 24, height: 16)
							.foregroundStyle(.green)
							.offset(y: 38)
					}
					.frame(height: 100)
				}

				// Zzzs for sleeping
				if state == .sleeping {
					VStack {
						Text("💤")
							.font(.system(size: 20))
							.offset(x: 40, y: -30)
					}
					.frame(height: 100)
				}
			}
			.frame(height: 100)

			// State change buttons
			HStack(spacing: 10) {
				Button(action: { setState(.eating) }) { Label("Eat", systemImage: "fork.knife") }
				Button(action: { setState(.happy) }) { Label("Play", systemImage: "smiley") }
			}
			HStack(spacing: 10) {
				Button(action: { setState(.sleeping) }) { Label("Sleep", systemImage: "moon.fill") }
				Button(action: { setState(.idle) }) { Label("Idle", systemImage: "circle") }
			}
		}
		.padding()
		.onAppear {
			updateAnimation()
		}
		.onChange(of: state) { _, _ in
			updateAnimation()
		}
	}

	private func setState(_ newState: TamagotchiState) {
		state = newState
	}

	private func updateAnimation() {
		switch state {
		case .idle:
			isBreathing = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
				isBreathing = true
			}
			isSleepingAnim = false
			isChewing = false
			isHappyAnim = false
		case .sleeping:
			isSleepingAnim = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
				isSleepingAnim = true
			}
			isBreathing = false
			isChewing = false
			isHappyAnim = false
		case .eating:
			isChewing = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
				isChewing = true
			}
			isBreathing = false
			isSleepingAnim = false
			isHappyAnim = false
		case .happy:
			isHappyAnim = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
				isHappyAnim = true
			}
			isBreathing = false
			isSleepingAnim = false
			isChewing = false
		}
	}
}

// Arc shape for happy mouth
struct Arc: Shape {
	var startAngle: Angle
	var endAngle: Angle
	var clockwise: Bool

	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
		            radius: rect.width / 2,
		            startAngle: startAngle,
		            endAngle: endAngle,
		            clockwise: clockwise)
		return path
	}
}

#Preview {
	ContentView()
}
