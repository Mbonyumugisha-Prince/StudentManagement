# Student Management System

A mobile application that serves as a personal academic assistant for ALU students. This app should help users organize their coursework, track their schedule, and monitor their academic engagement throughout the term.

## Project Purpose

The Student Management System is a central platform that will helps ALU students to:
- Track attendance and stay in good academic standing
- Manage assignments and deadlines
- View class schedules and sessions
- Check academic progress and performance
- Access their personal academic information


## Key Features

### Dashboard
- **Overview Metrics**: Real-time attendance percentage, pending assignments
- **Today's Sessions**: Dynamic display of scheduled classes with time and location
- **Upcoming Assignments**: Priority-based assignment tracking with due dates
- **Attendance Alerts**: Warning system for attendance below 75% threshold

### Authentication System
- **Secure Login**: Email and password-based authentication
- **User Registration**: Complete student profile creation
- **Session Management**: Persistent login state with logout functionality
- **Password Recovery**: Forgot password dialog for account recovery

### Schedule Management
- **Class Schedule**: Weekly view of all scheduled sessions
- **Session Details**: Course information, timing, and location
**Assignment Creation**: Add new session with sesion title, date, time, type and Location.
- **Day-based Filtering**: Quick access to specific day's sessions

### Assignment Tracking
- **Assignment Creation**: Add new assignments with course, title, and due date
- **Priority System**: High/Medium/Low priority classification
- **Status Management**: Track completion status (Pending/Completed)
- **Due Date Alerts**: Visual indicators for approaching deadlines

### Attendance Monitoring
- **Attendance Recording**: Mark presence for each session
- **Percentage Calculation**: Automatic attendance rate computation
- **Threshold Alerts**: Notifications when attendance drops below 75%
- **Visual Progress**: Color-coded attendance status

### Profile Management
- **Personal Information**: View and edit student details
- **Academic Summary**: Overview of academic performance
- **Account Settings**: User preferences and configurations

## Architecture

### Project Structure
```
mobile/
├── lib/
│   ├── features/
│   │   ├── authentication/    # Login & signup screens
│   │   ├── dashboard/         # Main dashboard
│   │   ├── assignments/       # Assignment management
│   │   ├── attendance/        # Attendance tracking
│   │   ├── schedule/          # Class scheduling
│   │   ├── profile/           # User profile
│   │   ├── models/            # Data models
│   │   ├── services/          # Core system rules
│   │   └── widgets/           # Reusable UI components
│   ├── core/
│   │   └── theme/             # App theming & colors
│   └── main.dart              # App entry point
```

### Key Components

#### Data Models
- **Student Model**: User profile and academic information
- **Assignment Model**: Assignment details with priority and status
- **Attendance Model**: Session tracking and presence records
- **Schedule Model**: Class sessions with timing and location

#### State Management
- **AssignmentStore**: Manages assignment data and operations
- **AttendanceStore**: Handles attendance tracking and calculations
- **ScheduleStore**: Controls schedule data and session management
- **StudentStore**: Manages user profile information

#### UI Components
- **CustomBottomNavBar**: Navigation bar with icon indicators
- **BackgroundWithPattern**: Consistent app background design
- **CustomTextField**: Styled input fields with validation
- **HeaderText**: Same header style used on all pages for consistency

## Technology Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language for app logic
- **Material Design 3**: UI design system for consistent interface

### Data Storage
- **Local JSON Storage**: Persistent data storage using local files
- **In-Memory State**: Reactive state management for real-time updates

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android/iOS development environment

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd StudentManagement/mobile
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```


### Development Setup

1. **Code Quality**
   ```bash
   flutter analyze
   flutter test
   ```


## App Screens

### Authentication Flow
- **Login Screen**: Secure user authentication
- **Signup Screen**: New user registration

### Main Application
- **Dashboard**: Main screen that shows summary information and key statistics
- **Attendance**: Track and monitor the attendance
- **Assignments**: Manage academic assignments
- **Schedule**: View and manage Weekly schedules
- **Profile**: User account management

## UI/UX Design

### Design Principles
- **ALU Branding**: Consistent with university color palette
- **Responsive Layout**: Adaptive design for various screen sizes
- **Intuitive Navigation**: Clear user flow and interactions

### Color Scheme
- **Primary Blue**: Main app color and navigation
- **Primary White**: Card backgrounds and content areas
- **Accent Yellow**: Highlights and important elements
- **Primary Red**: Alerts and warning indicators
- **Text Colors**: Hierarchical typography for readability


### Team
- **Prince Mbonyumugisha**
- **Gaddiel Irakoze**
- **Dominion Enyojo Yusuf**
- **Rwigenza Davy Niyoyandemye**


### Project Deriverables
- **Repository**: https://github.com/Mbonyumugisha-Prince/StudentManagement.git
- **Demo Video**: https://drive.google.com/file/d/1pDK3xhn6cH8nZFoeziC4fVYjoeI0NY6N/view?usp=sharing

---
