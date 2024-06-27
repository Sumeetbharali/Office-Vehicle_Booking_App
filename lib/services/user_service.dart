 import 'dart:convert';

import 'package:nic_yaan/models/api_response.dart';
 import 'package:nic_yaan/services/constant.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
 // Token Storage
 Future<void> storeAccessToken(String accessToken) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('access_token', accessToken);
 }

//LOGIN
 Future<ApiResponse> login(String email, String password) async {
   ApiResponse apiResponse = ApiResponse();
   try {
     final response = await http.post(
       Uri.parse(loginURL),
       headers: {'Accept': 'application/json'},
       body: {'email': email, 'password': password},
     );
     switch (response.statusCode) {
       case 200:
         apiResponse.data = User.fromJson(jsonDecode(response.body));
         break;
       case 422:
         final errors = jsonDecode(response.body)['errors'];
         apiResponse.error = errors[errors.keys.elementAt(0)[0]];
         break;
       case 401:
         apiResponse.error = jsonDecode(response.body)['message'];
         break;
       default:
         apiResponse.error = somethingWentWrong;
         break;
     }
   } catch (e) {
     apiResponse.error = serverError;
   }
   return apiResponse;
 }

 class AuthService {
   final String apiUrl = '$baseURL/auth/register'; // Replace with your API URL

   Future<Map<String, dynamic>> register({
     required String name,
     required String email,
     required String password,
     int? firstApproverId,
   }) async {
     final Map<String, dynamic> requestData = {
       'name': name,
       'email': email,
       'password': password,
       'first_approver_id': firstApproverId,
     };

     final response = await http.post(
       Uri.parse(apiUrl),
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(requestData),
     );

     if (response.statusCode == 201) {
       return jsonDecode(response.body);
     } else {
       throw Exception('Failed to register: ${response.body}');
     }
   }
 }
//----------REGISTER------------------
 Future<ApiResponse>getUserDetail() async{
   ApiResponse apiResponse= ApiResponse();
   try{
     String token= await getToken();
     final response= await http.get(
       Uri.parse(userURL),
       headers: {'Accept': 'application/json', 'Authorization':'Bearer $token'

       }
     );
     switch (response.statusCode) {
       case 200:
         apiResponse.data = User.fromJson(jsonDecode(response.body));
         break;
       case 422:
         final errors= jsonDecode(response.body)['errors'];
         apiResponse.error= errors[errors.keys.elementAt(0)[0]];
         break;
       case 401:
         apiResponse.error=jsonDecode(response.body)['message'];
         break;
       default:
         apiResponse.error= somethingWentWrong;
         break;
     }
   }
   catch(e){
     apiResponse.error= serverError;
   }
   return apiResponse;
 }
 // ----GET TOKEN-----
 Future<String> getToken()async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  return pref.getString('access_token') ?? '';
 }
//----GET USER-----
 Future<int> getUserId()async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.getInt('userId') ?? 0;
 }
 //----LOGOUT USER-----
 Future<bool> logout()async{
   SharedPreferences pref=await SharedPreferences.getInstance();
   return pref.remove('access_token');
 }