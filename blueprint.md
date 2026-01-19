# Project Blueprint

## Overview

This document outlines the architecture, features, and design of the financial management application. The application is built with Flutter and utilizes Firebase for backend services.

## Features

### Core Features

- **User Authentication:** Secure user sign-up and sign-in functionality.
- **Transaction Management:** Users can add, edit, and delete income and expense transactions.
- **Financial Planning:** A dedicated section for financial planning, including upcoming transactions and a calendar view.
- **Data Visualization:** Charts and graphs to visualize income, expenses, and savings.

### New Feature: Transaction Tagging

- **Purpose:** To provide users with a more granular way to categorize their transactions, leading to better financial insights.
- **Implementation:**
  - **`Transaction` Entity:** The `Transaction` entity has been updated to include a `tag` field.
  - **Enums:** `IncomeTags` and `ExpenseTags` enums have been created to define a predefined list of tags for income and expense transactions, respectively.
  - **`TransactionForm`:** A new dropdown has been added to the `TransactionForm`. This dropdown is dynamically populated with either `IncomeTags` or `ExpenseTags` based on the selected `TransactionCategory`.
  - **UI Display:** The `TransactionListItem` and the `TransactionPage` have been updated to display the selected tag for each transaction.
  - **Tag Icons:** The `TransactionListItem` now displays a relevant icon next to the tag, providing a quick visual cue for each transaction's category.

### New Feature: Saving Goals

*   **Purpose:** To allow users to create and track their financial saving goals.
*   **Implementation:**
    *   **Architecture:** The feature is implemented using a clean architecture approach with `data`, `domain`, and `presentation` layers.
    *   **Domain Layer:**
        *   `SavingGoal` Entity: Represents a user's saving goal with properties like `id`, `name`, `targetAmount`, and `currentAmount`.
        *   `SavingGoalRepository` Interface: Defines the contract for managing saving goals.
        *   Use Cases: `AddSavingGoal`, `DeleteSavingGoal`, `GetSavingGoals`, `UpdateSavingGoal` encapsulate the business logic for the feature.
    *   **Data Layer:**
        *   `SavingGoalModel`: A data transfer object that extends the `SavingGoal` entity.
        *   `SavingGoalRemoteDataSource`: An interface for fetching saving goal data from a remote source.
        *   `SavingGoalRemoteDataSourceImpl`: The implementation of the data source using Firebase Firestore to store and retrieve saving goal data.
        *   `SavingGoalRepositoryImpl`: The implementation of the repository that interacts with the remote data source and handles data mapping and error handling.
    *   **Presentation Layer:**
        *   `SavingGoalCubit`: Manages the state of the saving goal feature using the BLoC pattern.
        *   `SavingGoalState`: Represents the different states of the saving goal feature (e.g., loading, loaded, error).
        *   `SavingGoalPage`: The main UI for displaying and managing saving goals.
        *   `SavingGoalList`: A widget to display a list of saving goals.

## Design and Theming

- **Layout:** The application follows a modern, clean, and intuitive design with a focus on user experience.
- **Colors:** The color scheme is based on Material Design principles, with a primary color palette and accent colors for different UI elements.
- **Typography:** The app uses a consistent set of font styles for headings, body text, and other UI elements.

## Architecture

- **State Management:** The application uses the BLoC (Business Logic Component) pattern for state management, ensuring a clear separation of concerns between the UI and business logic.
- **Dependency Injection:** The `get_it` package is used for dependency injection, making the code more modular and testable.
- **Folder Structure:** The project is organized by feature, with each feature having its own `data`, `domain`, and `presentation` layers.
