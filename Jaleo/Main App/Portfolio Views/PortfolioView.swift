import SwiftUI

struct PortfolioView: View {
    @State private var selectedYear = 0
    let years = ["9th", "10th", "11th", "12th"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    PortfolioHeaderView()
                    
                    // Custom Tabs with full width and dividers
                    ZStack(alignment: .bottomLeading) {
                        HStack(spacing: 0) {
                            ForEach(Array(years.enumerated()), id: \.offset) { index, year in
                                Button(action: {
                                    withAnimation {
                                        selectedYear = index
                                    }
                                }) {
                                    Text(year)
                                        .foregroundColor(selectedYear == index ? .customBlue : .white)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .contentShape(Rectangle())
                                }
                                
                                if index < years.count - 1 {
                                    Divider().background(Color.gray)
                                }
                            }
                        }
                        .frame(height: 50) // Set the height of the tabs
                        .background(Color.clear) // Clear background
                        
                        // Blue line on top of the selected tab
                        Rectangle()
                            .fill(Color.customBlue)
                            .frame(width: UIScreen.main.bounds.width / CGFloat(years.count), height: 2)
                            .offset(x: CGFloat(selectedYear) * (UIScreen.main.bounds.width / CGFloat(years.count)), y: -50)
                            .animation(.default, value: selectedYear)
                    }
                    .frame(height: 50) // Set the height including the top line
                    .background(Color.clear) // Clear background
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Rounded rectangle overlay for borders
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                    
                    // Section cards
                    TabView(selection: $selectedYear) {
                        ForEach(0..<years.count) { yearIndex in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(SectionType.allCases, id: \.self) { sectionType in
                                        CollapsibleSectionCardView(title: sectionType.rawValue, sectionType: sectionType, selectedYear: selectedYear)
                                            .padding(.vertical, 5)
                                    }
                                }
                                .scrollIndicators(.hidden)
                                
                            }
                            .tag(yearIndex)
                            .padding(.horizontal, 15)
                            .scrollIndicators(.hidden)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    Spacer()
                }
                .padding(.top, 40)
            }
        }
    }
    // Namespace for Matched Geometry Effect
    @Namespace private var namespace
}

struct PortfolioHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "doc.append")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25) // Made slightly smaller
                .padding(.leading, 20)
                .foregroundColor(.white)
            Text("My Portfolio")
                .font(.headline) // Smaller font size compared to .title
                .fontWeight(.bold) // Bold font weight
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct CollapsibleSectionCardView: View {
    let title: String
    let sectionType: SectionType
    let selectedYear: Int

    @State private var isCollapsed: Bool = false
    @State private var navigateToEditView = false
    @State private var navigateToAddView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                // Chevron button for collapsing
                Button(action: {
                    withAnimation { self.isCollapsed.toggle() }
                }) {
                    Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                // Edit button
                Button(action: {
                    navigateToEditView = true
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                }

                // Add button
                Button(action: {
                    navigateToAddView = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 10)

            // Navigation links are hidden and only activated when the state changes
            NavigationLink(destination: viewForSectionType(sectionType, isEditMode: true), isActive: $navigateToEditView) { EmptyView() }
            NavigationLink(destination: viewForSectionType(sectionType, isEditMode: false), isActive: $navigateToAddView) { EmptyView() }

            if !isCollapsed {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(sectionType.items, id: \.self) { item in
                        Text(item)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                        Divider() // Divider line between items
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 7)
    }
    @ViewBuilder
        private func viewForSectionType(_ sectionType: SectionType, isEditMode: Bool) -> some View {
            switch sectionType {
            case .Courses:
                isEditMode ? AnyView(CoursesView()) : AnyView(AddCourseView())
            case .Extracurriculars:
                isEditMode ? AnyView(ExtracurricularsView()) : AnyView(AddExtracurricularView())
            case .Awards:
                isEditMode ? AnyView(AwardsView()) : AnyView(AddAwardView())
            case .TestScores:
                isEditMode ? AnyView(TestScoresView()) : AnyView(AddTestScoreView())
            }
        }
}


enum SectionType: String, CaseIterable {
    case Courses = "Courses"
    case Extracurriculars = "Extracurriculars"
    case Awards = "Awards"
    case TestScores = "Test Scores"

    var items: [String] {
        switch self {
        case .Courses: return ["Generic Science Class", "Generic Math Class", "Physical Education"]
        case .Extracurriculars: return ["Volunteering", "Arbitrary Extracurricular 1", "Clubs"]
        case .Awards: return ["Arbitrary Award 1", "Arbitrary Award 2"]
        case .TestScores: return ["Arbitrary Test 1: Score"]
        }
    }
}

// Dummy extension for custom colors
extension Color {
    static let customLightBackground = Color.gray.opacity(0.1)
    static let customDarkBackground = Color.gray.opacity(0.2)
    static let customBlue = Color.blue
}
