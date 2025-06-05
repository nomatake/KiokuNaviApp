import 'package:flutter/material.dart';

///Basic Constants
const String kAppName = "Kioku Navi";

///Colors
const kScaffoldBackgroundColor = 0xFFF7F9FC;

///API
const String kBaseUrl = "";

///Common
const String kEmpty = "";
const String kKey = "key";
const String kIndex = "index";
const String kValue = "value";
const String kCanGoBack = "canGoBack";
const String kProfile = "Profile";
const String kHome = "Home";
const String kStatus = "status";
const String kMessage = "message";
const String kOneSpace = "\u0020";
const String kTitle = 'title';
const String kIcon = 'icon';
const String kRoute = 'route';
const String kCancel = 'Cancel';
const String kConfirm = 'Confirm';
const String kRead = 'Read';
const String kWrite = 'Write';
const String kRequired = 'Required';
const String kToken = 'token';
const String kAuthorization = 'Authorization';
const String kBearer = 'Bearer';
const String kUserEmail = 'user_email';

/// HTTP Status Codes
const int kStatusOK = 200;
const int kStatusCreated = 201;
const int kStatusNoContent = 204;
const int kStatusBadRequest = 400;
const int kStatusUnauthorized = 401;
const int kStatusForbidden = 403;
const int kStatusNotFound = 404;
const int kStatusMethodNotAllowed = 405;
const int kStatusConflict = 409;
const int kStatusUnprocessableEntity = 422;
const int kStatusInternalServerError = 500;
const int kStatusServiceUnavailable = 503;

/// HTTP Status Messages
const String kMessageOK = "Success";
const String kMessageUnauthorized = "Unauthorized: Please login again";
const String kMessageForbidden = "Access denied";
const String kMessageBadRequest = "Invalid request";
const String kMessageNotFound = "Resource not found";
const String kMessageServerError = "Server error occurred";
const String kMessageNetworkError = "Network error occurred";
const String kMessageTimeout = "Request timed out";
const String kMessageValidationError =
    "Invalid credentials";
const String kMessageConnectionTimeout = "Connection timeout";
const String kMessageSendTimeout = "Send timeout";
const String kMessageReceiveTimeout = "Receive timeout";
const String kMessageCancel = "Request cancelled";

/// UI Size Constants
const double k0Double = 0.0;
const double k0_2Double = 0.2;
const double k1_05Double = 1.05;
const double k2Double = 2.0;
const double k3Double = 3.0;
const double k4Double = 4.0;
const double k6Double = 6.0;
const double k9Double = 9.0;
const double k10Double = 10.0;
const double k11Double = 11.0;
const double k12Double = 12.0;
const double k14Double = 14.0;
const double k16Double = 16.0;
const double k20Double = 20.0;
const double k22Double = 22.0;
const double k25Double = 25.0;
const double k30Double = 30.0;
const double kGapTitleToFirstInput = 33.0;
const double kGapBetweenInputs = 12.0;
const double kGapInputsToButton = 105.0;
const double kGapButtonToTerms = 24.0;
const double kGapInputToTerms = 24.0;
const double kGapTermsToButton = 40.0;
const double kGapAppBarToHeader = 24.0;

/// Horizontal padding for register view (from Figma)
const double kRegisterHorizontalPadding = 16.0;

/// Horizontal padding for terms text in register view (from Figma)
const double kRegisterTermsHorizontalPadding = 67.5;

// Progress bar constants (from Figma)
const double kRegisterProgressBarWidth = 286.0;
const double kRegisterProgressBarHeight = 15.0;
const double kRegisterProgressBarOverlayHeight = 4.0;
const double kRegisterProgressBarOverlayLeft = 4.0;
const double kRegisterProgressBarOverlayTop = 3.0;
const Color kRegisterProgressBarBgColor = Color(0xFFCFD8DC);
const Color kRegisterProgressBarProgressColor = Color(0xFF1976D2);
const Color kRegisterProgressBarOverlayColor = Color.fromRGBO(255, 255, 255, 0.2);