//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziOnboarding
import SwiftUI


struct AccountOnboarding: View {
    @EnvironmentObject private var account: Account
    @EnvironmentObject private var onboardingNavigationPath: OnboardingNavigationPath


    var body: some View {
        AccountSetup { _ in
            Task {
                // Placing the nextStep() call inside this task will ensure that the sheet dismiss animation is
                // played till the end before we navigate to the next step.
                onboardingNavigationPath.nextStep()
            }
        } header: {
            AccountSetupHeader()
        } continue: {
            OnboardingActionsView(
                "Continue",
                action: {
                    onboardingNavigationPath.nextStep()
                }
            )
        }
    }
}


#if DEBUG
private let stack = OnboardingStack(startAtStep: AccountOnboarding.self) {
    for onboardingView in OnboardingFlow.previewSimulatorViews {
        onboardingView
    }
}

#Preview {
    stack
        .environmentObject(Account(MockUserIdPasswordAccountService()))
}
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))

    return stack
        .environmentObject(Account(building: details, active: MockUserIdPasswordAccountService()))
}
#endif