// ignore_for_file: constant_identifier_names

class Urls {
  //Base
  static const baseUrl = "https://cloudwapptechnologies.com/NG/STAID/api/";
  static const image_base_url = "https://cloudwapptechnologies.com/NG/STAID/";
  static const x_client_token = "e0271afd8a3b8257af70deacee4";

  //Other Apis
  static const loginUrl = "${baseUrl}login";
  static const emailSubmitUrl = "${baseUrl}submitEmail";
  static const submitEmailVerificationUrl = "${baseUrl}verifyOtpForEmail";
  static const contactSubmitUrl = "${baseUrl}submitContactNumber";
  static const submitContactVerificationUrl = "${baseUrl}verifyOtpForMobileno";
  static const registerUrl = "${baseUrl}register";
  static const logoutUrl = "${baseUrl}logout";
  static const profileUrl = "${baseUrl}profile";
  static const updateProfileUrl = "${baseUrl}updateprofile";
  static const changePasswordUrl = "${baseUrl}changepassword";
  static const changeEmailUrl = "${baseUrl}changeemail";
  static const changeEmailVerificationUrl = "${baseUrl}verifyOtpForChangeEmail";
  static const changePhoneUrl = "${baseUrl}changemobileno";
  static const changePhoneVerificationUrl = "${baseUrl}verifyOtpForChangeMobileno";
  static const categoryUrl = "${baseUrl}categories";
  static const postATaskUrl = "${baseUrl}addtask";
  static const taskListUrl = "${baseUrl}tasklist";
  static const chatListWithTaskUrl = "${baseUrl}chatlistwithtask";
  static const getmessageUrl = "${baseUrl}getmessage";
  static const sendmessageUrl = "${baseUrl}chat";
}