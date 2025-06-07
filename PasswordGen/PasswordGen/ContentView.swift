//
//  ContentView.swift
//  PasswordGen
//
//  Created by David Guffre on 6/7/25.
//

import SwiftUI
import CryptoKit

	// MARK: - Word Lists
struct WordLists {
	static let commonWords = [
		// Animals
		"cat", "dog", "bird", "fish", "lion", "tiger", "bear", "wolf", "fox", "deer",
		"horse", "cow", "pig", "sheep", "goat", "duck", "frog", "snake", "mouse", "rabbit",
		
		// Colors
		"red", "blue", "green", "yellow", "orange", "purple", "pink", "black", "white", "brown",
		"gray", "silver", "gold", "cyan", "lime", "navy", "coral", "amber", "jade", "ruby",
		
		// Objects
		"house", "car", "book", "phone", "chair", "table", "door", "window", "key", "lamp",
		"pen", "paper", "cup", "plate", "knife", "fork", "spoon", "clock", "watch", "ring",
		
		// Nature
		"tree", "flower", "grass", "rock", "river", "lake", "ocean", "mountain", "valley", "beach",
		"cloud", "rain", "snow", "wind", "fire", "earth", "moon", "star", "planet", "galaxy",
		
		// Food
		"apple", "banana", "orange", "grape", "berry", "bread", "cheese", "milk", "water", "coffee",
		"tea", "cake", "cookie", "pizza", "pasta", "rice", "fish", "meat", "egg", "honey",
		
		// Actions
		"run", "walk", "jump", "swim", "fly", "dance", "sing", "laugh", "smile", "play",
		"work", "study", "read", "write", "draw", "paint", "cook", "clean", "build", "fix",
		
		// Adjectives
		"big", "small", "tall", "short", "fast", "slow", "hot", "cold", "warm", "cool",
		"bright", "dark", "light", "heavy", "soft", "hard", "smooth", "rough", "quiet", "loud",
		
		// Technology
		"phone", "laptop", "tablet", "camera", "screen", "button", "cable", "mouse", "keyboard", "printer",
		"robot", "drone", "satellite", "rocket", "engine", "battery", "circuit", "sensor", "radar", "laser"
	]
	
	static let numbersWords = [
		"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
		"ten", "eleven", "twelve", "twenty", "thirty", "fifty", "hundred", "thousand"
	]
	
	static let allWords = commonWords + numbersWords
}

	// MARK: - Passphrase Settings Model
class PassphraseSettings: ObservableObject {
	@Published var wordCount: Double = 4
	@Published var separator: SeparatorType = .dash
	@Published var capitalization: CapitalizationType = .none
	@Published var includeNumbers: Bool = true
	@Published var includeSymbols: Bool = false
	@Published var customWords: String = ""
	
	enum SeparatorType: String, CaseIterable {
		case dash = "-"
		case underscore = "_"
		case dot = "."
		case space = " "
		case none = ""
		
		var displayName: String {
			switch self {
				case .dash: return "Dash (-)"
				case .underscore: return "Underscore (_)"
				case .dot: return "Dot (.)"
				case .space: return "Space"
				case .none: return "No Separator"
			}
		}
	}
	
	enum CapitalizationType: String, CaseIterable {
		case none = "lowercase"
		case first = "First Letter"
		case all = "ALL CAPS"
		case random = "Random"
		
		var displayName: String {
			switch self {
				case .none: return "lowercase"
				case .first: return "First Letter"
				case .all: return "ALL CAPS"
				case .random: return "Random Mix"
			}
		}
	}
	
	var wordList: [String] {
		var words = WordLists.allWords
		
			// Add custom words if provided
		if !customWords.isEmpty {
			let customWordList = customWords
				.components(separatedBy: .whitespacesAndNewlines)
				.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
				.filter { !$0.isEmpty }
			words.append(contentsOf: customWordList)
		}
		
		return words
	}
}

	// MARK: - Passphrase Strength Calculator
enum PassphraseStrength: String, CaseIterable {
	case weak = "Weak"
	case fair = "Fair"
	case good = "Good"
	case strong = "Strong"
	case veryStrong = "Very Strong"
	
	var color: Color {
		switch self {
			case .weak: return .red
			case .fair: return .orange
			case .good: return .yellow
			case .strong: return .green
			case .veryStrong: return .blue
		}
	}
	
	var progress: Double {
		switch self {
			case .weak: return 0.2
			case .fair: return 0.4
			case .good: return 0.6
			case .strong: return 0.8
			case .veryStrong: return 1.0
		}
	}
}

	// MARK: - Passphrase Generator Service
class PassphraseGenerator: ObservableObject {
	@Published var currentPassphrase = ""
	@Published var passphraseStrength: PassphraseStrength = .weak
	@Published var estimatedCrackTime = ""
	
	func generatePassphrase(with settings: PassphraseSettings) {
		let wordCount = Int(settings.wordCount)
		let wordList = settings.wordList
		
		guard !wordList.isEmpty else {
			currentPassphrase = ""
			return
		}
		
		var words: [String] = []
		
			// Generate random words
		for _ in 0..<wordCount {
			if let randomWord = wordList.randomElement() {
				words.append(formatWord(randomWord, with: settings))
			}
		}
		
			// Add numbers if enabled
		if settings.includeNumbers {
			let randomIndex = Int.random(in: 0..<words.count)
			let randomNumber = Int.random(in: 10...999)
			words.insert(String(randomNumber), at: randomIndex)
		}
		
			// Add symbols if enabled
		if settings.includeSymbols {
			let symbols = ["!", "@", "#", "$", "%", "&", "*"]
			if let randomSymbol = symbols.randomElement() {
				let randomIndex = Int.random(in: 0..<words.count)
				words.insert(randomSymbol, at: randomIndex)
			}
		}
		
			// Join words with separator
		currentPassphrase = words.joined(separator: settings.separator.rawValue)
		calculateStrength()
	}
	
	private func formatWord(_ word: String, with settings: PassphraseSettings) -> String {
		switch settings.capitalization {
			case .none:
				return word.lowercased()
			case .first:
				return word.capitalized
			case .all:
				return word.uppercased()
			case .random:
				return Bool.random() ? word.uppercased() : word.lowercased()
		}
	}
	
	private func calculateStrength() {
		let length = currentPassphrase.count
		let wordCount = currentPassphrase.components(separatedBy: CharacterSet.letters.inverted).filter { !$0.isEmpty }.count
		let hasNumbers = currentPassphrase.rangeOfCharacter(from: .decimalDigits) != nil
		let hasSymbols = currentPassphrase.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*")) != nil
		let hasMixedCase = currentPassphrase.rangeOfCharacter(from: .uppercaseLetters) != nil &&
		currentPassphrase.rangeOfCharacter(from: .lowercaseLetters) != nil
		
		var score = 0
		
			// Word count scoring
		if wordCount >= 3 { score += 1 }
		if wordCount >= 4 { score += 1 }
		if wordCount >= 5 { score += 1 }
		
			// Length scoring
		if length >= 15 { score += 1 }
		if length >= 25 { score += 1 }
		
			// Complexity scoring
		if hasNumbers { score += 1 }
		if hasSymbols { score += 1 }
		if hasMixedCase { score += 1 }
		
		switch score {
			case 0...2:
				passphraseStrength = .weak
				estimatedCrackTime = "Minutes to hours"
			case 3...4:
				passphraseStrength = .fair
				estimatedCrackTime = "Days to weeks"
			case 5...6:
				passphraseStrength = .good
				estimatedCrackTime = "Months to years"
			case 7...8:
				passphraseStrength = .strong
				estimatedCrackTime = "Decades to centuries"
			default:
				passphraseStrength = .veryStrong
				estimatedCrackTime = "Millennia+"
		}
	}
}

	// MARK: - Main Content View
struct ContentView: View {
	@StateObject private var settings = PassphraseSettings()
	@StateObject private var generator = PassphraseGenerator()
	@State private var showCopiedAlert = false
	@State private var hapticImpact = UIImpactFeedbackGenerator(style: .medium)
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 24) {
						// Passphrase Display Section
					PassphraseDisplayView(
						passphrase: generator.currentPassphrase,
						strength: generator.passphraseStrength,
						crackTime: generator.estimatedCrackTime,
						onCopy: copyPassphrase
					)
					
						// Settings Section
					PassphraseSettingsView(settings: settings)
					
						// Generate Button
					Button(action: generatePassphrase) {
						HStack {
							Image(systemName: "arrow.clockwise")
							Text("Generate Passphrase")
								.fontWeight(.semibold)
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(12)
					}
					
					Spacer(minLength: 100)
				}
				.padding()
			}
			.navigationTitle("Passphrase Generator")
			.navigationBarTitleDisplayMode(.large)
			.onAppear {
				generatePassphrase()
			}
			.alert("Passphrase Copied!", isPresented: $showCopiedAlert) {
				Button("OK") { }
			}
		}
	}
	
	private func generatePassphrase() {
		hapticImpact.impactOccurred()
		generator.generatePassphrase(with: settings)
	}
	
	private func copyPassphrase() {
		UIPasteboard.general.string = generator.currentPassphrase
		hapticImpact.impactOccurred()
		showCopiedAlert = true
	}
}

	// MARK: - Passphrase Display View
struct PassphraseDisplayView: View {
	let passphrase: String
	let strength: PassphraseStrength
	let crackTime: String
	let onCopy: () -> Void
	
	var body: some View {
		VStack(spacing: 16) {
				// Passphrase Text
			VStack(spacing: 8) {
				Text(passphrase.isEmpty ? "Generate a passphrase" : passphrase)
					.font(.system(.title3, design: .monospaced))
					.foregroundColor(passphrase.isEmpty ? .secondary : .primary)
					.multilineTextAlignment(.center)
					.textSelection(.enabled)
					.padding()
					.frame(minHeight: 100)
					.frame(maxWidth: .infinity)
					.background(Color(.systemGray6))
					.cornerRadius(12)
				
				if !passphrase.isEmpty {
					Button(action: onCopy) {
						HStack {
							Image(systemName: "doc.on.doc")
							Text("Copy Passphrase")
						}
						.font(.subheadline)
						.foregroundColor(.blue)
					}
				}
			}
			
				// Strength Indicator
			if !passphrase.isEmpty {
				StrengthIndicatorView(strength: strength, crackTime: crackTime)
			}
		}
	}
}

	// MARK: - Strength Indicator View
struct StrengthIndicatorView: View {
	let strength: PassphraseStrength
	let crackTime: String
	
	var body: some View {
		VStack(spacing: 12) {
			HStack {
				Text("Strength:")
					.font(.subheadline)
					.foregroundColor(.secondary)
				Spacer()
				Text(strength.rawValue)
					.font(.subheadline)
					.fontWeight(.medium)
					.foregroundColor(strength.color)
			}
			
			ProgressView(value: strength.progress)
				.progressViewStyle(LinearProgressViewStyle(tint: strength.color))
				.scaleEffect(x: 1, y: 2, anchor: .center)
			
			HStack {
				Text("Est. crack time:")
					.font(.caption)
					.foregroundColor(.secondary)
				Spacer()
				Text(crackTime)
					.font(.caption)
					.fontWeight(.medium)
					.foregroundColor(.secondary)
			}
		}
	}
}

	// MARK: - Passphrase Settings View
struct PassphraseSettingsView: View {
	@ObservedObject var settings: PassphraseSettings
	
	var body: some View {
		VStack(spacing: 20) {
				// Word Count Slider
			VStack(alignment: .leading, spacing: 2) {
				HStack {
					Text("Number of Words")
						.font(.headline)
					Spacer()
					Text("\(Int(settings.wordCount))")
						.font(.title2)
						.fontWeight(.semibold)
						.foregroundColor(.blue)
				}
				
				Slider(value: $settings.wordCount, in: 2...8, step: 1)
					.accentColor(.blue)
			}
			
			Divider()
			
				// Separator Selection
			VStack(alignment: .leading, spacing: 8) {
				Text("Word Separator")
					.font(.headline)
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
					ForEach(PassphraseSettings.SeparatorType.allCases, id: \.self) { separator in
						Button(action: {
							settings.separator = separator
						}) {
							Text(separator.displayName)
								.font(.subheadline)
								.padding(.vertical, 8)
								.padding(.horizontal, 12)
								.background(settings.separator == separator ? Color.blue : Color(.systemGray5))
								.foregroundColor(settings.separator == separator ? .white : .primary)
								.cornerRadius(8)
						}
					}
				}
			}
			
			Divider()
			
				// Capitalization Selection
			VStack(alignment: .leading, spacing: 8) {
				Text("Capitalization")
					.font(.headline)
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
					ForEach(PassphraseSettings.CapitalizationType.allCases, id: \.self) { cap in
						Button(action: {
							settings.capitalization = cap
						}) {
							Text(cap.displayName)
								.font(.subheadline)
								.padding(.vertical, 8)
								.padding(.horizontal, 12)
								.background(settings.capitalization == cap ? Color.blue : Color(.systemGray5))
								.foregroundColor(settings.capitalization == cap ? .white : .primary)
								.cornerRadius(8)
						}
					}
				}
			}
			
			Divider()
			
				// Additional Options
			VStack(spacing: 12) {
				ToggleRow(
					title: "Include Numbers",
					subtitle: "Add random numbers",
					isOn: $settings.includeNumbers
				)
				
				ToggleRow(
					title: "Include Symbols",
					subtitle: "Add special characters",
					isOn: $settings.includeSymbols
				)
			}
			
			Divider()
			
				// Custom Words
			VStack(alignment: .leading, spacing: 8) {
				Text("Custom Words")
					.font(.headline)
				
				TextField("Add your own words (space separated)", text: $settings.customWords, axis: .vertical)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.lineLimit(3)
				
				Text("These will be mixed with the built-in word list")
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(16)
	}
}

	// MARK: - Toggle Row Component
struct ToggleRow: View {
	let title: String
	let subtitle: String
	@Binding var isOn: Bool
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.body)
				Text(subtitle)
					.font(.caption)
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			Toggle("", isOn: $isOn)
				.labelsHidden()
		}
	}
}


	// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
