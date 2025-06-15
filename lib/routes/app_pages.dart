import 'package:get/get.dart';
import 'package:kifinserv/screens/application/application_review_screen.dart';
import 'package:kifinserv/screens/application/track_applications_screen.dart';
import 'package:kifinserv/screens/auth/digio_verification_screen.dart';
import 'package:kifinserv/screens/auth/login_otp_verification_screen.dart';
import 'package:kifinserv/screens/auth/otp_verification_screen.dart';
import 'package:kifinserv/screens/home/home_binding.dart';
import 'package:kifinserv/screens/home/home_screen.dart';
import 'package:kifinserv/screens/home/start_application_screen.dart';
import 'package:kifinserv/screens/loans/ev_loan_vendor_screen.dart';
import 'package:kifinserv/screens/loans/ev_vehicle_selection_screen.dart';
import 'package:kifinserv/screens/loans/user_details_form_screen.dart';
import 'package:kifinserv/screens/loans/document_upload_screen.dart';
import 'package:kifinserv/screens/loans/reference_details_screen.dart';
import 'package:kifinserv/screens/loans/terms_conditions_screen.dart';
import 'package:kifinserv/screens/loans/gold_loan_screen.dart';
import 'package:kifinserv/screens/login/login_binding.dart';
import 'package:kifinserv/screens/login/login_signup_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/splash/splash_binding.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginSignupScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.START_APPLICATION,
      page: () => const StartApplicationScreen(),
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => OtpVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.LOGIN_OTP_VERIFICATION,
      page: () => LoginOtpVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.GOLD_LOAN,
      page: () => GoldLoanScreen(),
    ),
    GetPage(
      name: AppRoutes.EV_LOAN_VENDOR,
      page: () => EVLoanVendorScreen(),
    ),
    GetPage(
      name: AppRoutes.EV_VEHICLE_SELECTION,
      page: () => EVVehicleSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.USER_DETAILS_FORM,
      page: () => UserDetailsFormScreen(),
    ),
    GetPage(
      name: AppRoutes.DOCUMENT_UPLOAD,
      page: () => DocumentUploadScreen(),
    ),
    GetPage(
      name: AppRoutes.REFERENCE_DETAILS,
      page: () => ReferenceDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.TERMS_CONDITIONS,
      page: () => TermsConditionsScreen(),
    ),
    GetPage(
      name: AppRoutes.DIGIO_VERIFICATION,
      page: () => DigioVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.TRACK_APPLICATIONS,
      page: () => TrackApplicationsScreen(),
    ),
    GetPage(
      name: AppRoutes.APPLICATION_REVIEW,
      page: () => ApplicationReviewScreen(),
    ),
  ];
}
