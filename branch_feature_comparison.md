# KiokuNaviApp Branch Feature Comparison Matrix

## Overview
This document provides a comprehensive comparison of features implemented across different branches of the KiokuNaviApp project.

## Branch Feature Matrix

| Branch | Routes | Modules | Views | Unique Features |
|--------|--------|---------|-------|-----------------|
| **main** | - HOME<br>- ROOT_SCREEN<br>- REGISTER<br>- PARENT_LOGIN<br>- STUDENT_LOGIN<br>- FORGOT_PASSWORD<br>- CHILD_HOME<br>- TUTORIAL (1-9)<br>- LEARNING<br>- QUESTION<br>- RESULT<br>- CONTINUOUS_PLAY_RECORD<br>- SESSION_CHANGE | - auth<br>- home<br>- learning<br>- tutorial | - **Auth**: root_screen, register, parent_login, student_login, forgot_password<br>- **Home**: home, child_home<br>- **Learning**: learning, question, result, continuous_play_record, session_change<br>- **Tutorial**: tutorial, tutorial_two through tutorial_nine | - Complete app with all modules<br>- Full learning module<br>- All 9 tutorial screens<br>- Child home screen<br>- Session management |
| **feat-auth-UI** | - HOME<br>- ROOT_SCREEN | - home<br>- root_screen | - **Home**: home<br>- **Root Screen**: root_screen | - Basic auth UI structure<br>- Minimal implementation<br>- Focus on initial screens |
| **feat-learning** | Same as main | Same as main | Same as main | - Same implementation as main<br>- Focus on learning features<br>- Full tutorial suite |
| **feat-tutorials-ui** | - HOME<br>- ROOT_SCREEN<br>- REGISTER<br>- LOGIN<br>- PARENT_LOGIN<br>- STUDENT_LOGIN<br>- FORGOT_PASSWORD<br>- TUTORIAL (1-9) | - auth<br>- home<br>- tutorial | - **Auth**: root_screen, register, parent_login, student_login, forgot_password<br>- **Home**: home, child_home<br>- **Tutorial**: tutorial through tutorial_nine | - Focus on tutorial UI<br>- Has LOGIN route (unique)<br>- Complete tutorial implementation |
| **fear-tutorials-view** | - HOME<br>- ROOT_SCREEN<br>- REGISTER<br>- LOGIN<br>- PARENT_LOGIN<br>- STUDENT_LOGIN<br>- FORGOT_PASSWORD<br>- TUTORIAL (1-3) | - auth<br>- home<br>- tutorial | - **Auth**: root_screen, register, parent_login, student_login, forgot_password<br>- **Home**: home<br>- **Tutorial**: tutorial, tutorial_two, tutorial_three | - Only first 3 tutorials<br>- Simplified tutorial implementation |
| **feat-ipad-responsive-screens** | Same as main | Same as main | Same as main | - iPad responsive design<br>- Same features as main<br>- Focus on responsive layouts |
| **child-screens** | Same as main | Same as main | Same as main | - Child-specific screens<br>- Same implementation as main |
| **ui-developement** | - HOME<br>- LOGIN<br>- REGISTER<br>- PARENT_LOGIN<br>- STUDENT_LOGIN<br>- FORGOT_PASSWORD<br>- ROOT_SCREEN | - home<br>- login<br>- register<br>- root_screen | - **Home**: home<br>- **Login**: parent_login, student_login, forgot_password<br>- **Register**: register<br>- **Root Screen**: root_screen | - Separate login module<br>- Different module structure<br>- No tutorial or learning modules |
| **tutorials** | - HOME<br>- ROOT_SCREEN<br>- REGISTER<br>- LOGIN<br>- PARENT_LOGIN<br>- STUDENT_LOGIN<br>- FORGOT_PASSWORD<br>- TUTORIAL<br>- TUTORIAL_TWO | - auth<br>- home<br>- tutorial | - **Auth**: root_screen, register, parent_login, student_login, forgot_password<br>- **Home**: home<br>- **Tutorial**: tutorial, tutorial_two | - Only first 2 tutorials<br>- Basic tutorial implementation |

## Integration Decision
Based on this analysis, **feat-ipad-responsive-screens** was merged into the unified branch to provide responsive design improvements while maintaining all existing functionality from main.