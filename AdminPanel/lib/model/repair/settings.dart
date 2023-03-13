import 'package:abg_utils/abg_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// sms.to api key надо проверять самому

Future<String?> repairSettings() async {
  try{
    FirebaseFirestore.instance.collection("settings").doc("main").set({
      "about" : "We are a LICENSED, BONDED and INSURED Service Provider that was founded in 2004. Over the years we have grown into the successful company that we are today. We have focused our vision on doing what is best for our customers by providing excellence and quality service. We know that by providing our customers with the necessities they need and the customer service they deserve that our company will continue to strive and grow in this industry. We at Handyman at Your Command are also committed to the personal development of our employees. By having educated employees that have their own goals and aspirations, we know we can continue to ensure excellence in our handyman services and products. Handyman at Your Command is your best choice for your handyman and home remodeling needs.<br><br>We at Handyman at Your Command take great pride in our work. Every project that we work on is a direct reflection not only on our name, but also the personal levels of quality and dedication we have to customer service. You can guarantee that when you work with our handyman and home remodeling professionals, your project will be done the right way and to your satisfaction. We stand behind all of our work by offering a one-year warranty on craftsmanship for small projects and three years on large remodel projects.<br><br>The mission of Handyman at Your Command is to enrich the life of each customer by providing unique services to our customers and exceptional craftsmanship, all while maintaining a pleasant work environment. By fulfilling this mission, Handyman at Your Command will realize its vision to be an innovative leader in the home improvement market.",
      "rightSymbol": false,
      "digitsAfterComma": 2,
      "code": "USD",
      "symbol": "\$",
      "distance_unit": "km",
      "time_format": "24h",
      "date_format": "yyyy.MM.dd",
      "google_map_apikey": "AIzaSyDOz5oWyuWCeyh-9c1W5gexDzRakcRP-eM",
      "cloud_key": "AAAABtAXAG0:APA91bGOODbFu0WrKmyQvXAqos0V2lKSc3jnkMhrAiZg6GJ1jWq9FYNck32c9FDj5rqrPMWOYiTwdX1MS71FhL4swg6cujgz4JxQtSopJPq_2mPQX2WSNYMhCnOUPIdFruZGNe9s8KQp",
      "copyright": "Copyright, 2021 by AlphaBettaGamma",
      'policy' : "This Global Privacy Policy describes Handyman commitment to protecting your privacy. It forms a part of our Website Terms of Use, Trial Terms of Use, and Standard Terms of Service, and all other documents incorporated therein (“Terms”). Any capitalized terms not defined in this Global Privacy Policy are defined as set out in the Terms.<br><br>Please familiarize yourself with this Global Privacy Policy. This Global Privacy Policy is formally reviewed annually and is updated as often as necessary. Updates will be posted publicly on the Website. If we make substantive changes to the purposes and policies set out here, we will update this page and we will inform Product Users by email or in-application notification.",
      'terms' : "<p>A Terms and Conditions agreement acts as legal contracts between you (the company) who has the website or mobile app, and the user who accesses your website/app.</p><p>Having a Terms and Conditions agreement is completely optional. No laws require you to have one. Not even the super-strict and wide-reaching General Data Protection Regulation (GDPR).</p><p>Your Terms and Conditions agreement will be uniquely yours. While some clauses are standard and commonly seen in pretty much every Terms and Conditions agreement, it's up to you to set the rules and guidelines that the user must agree to.</p>",
      'googlePlayLink' : "https://play.google.com/store/apps/details?id=com.abg.ondservice",
      // 'appStoreLink' : appStoreLink,

      'otpEnable' : false,
      'otpPrefix' : "+9",
      'otpTwilioEnable' : false,
      'twilioAccountSID': "",
      'twilioAuthToken': "",
      'twilioServiceId': "",
      // nexmo
      "otpNexmoEnable" : false,
      "nexmoFrom" : "",
      "nexmoText" : "",
      "nexmoApiKey" : "",
      "nexmoApiSecret" : "",
      // sms.to
      "otpSMSToEnable" : true,
      "smsToFrom" : "HANDYMAN",
      "smsToText" : "Your code is {code}",
      //
      'defaultServiceAppLanguage' : "en",
      'defaultProviderAppLanguage' : "en",
      'defaultSiteAppLanguage' : "en",
      'defaultAdminAppLanguage' : "en",
      'currentServiceAppLanguage' : "en",
      "currentAdminLanguage": "en",
      //
      'adminDarkMode' : false,
      'customerMainColor': Color(0xff3c7396).value.toString(),
      'customerLogoLocal': "",
      'customerLogoServer': "",
      'customerFontSize': 14,
      'customerCategoryImageSize': 80,
      'providerMainColor': Color(0xff3c7396).value.toString(),
      'providerLogoLocal': "",
      'providerLogoServer': "",
      'websiteMainColor': Color(0xff69c4ff).value.toString(),
      'websiteLogoLocal': "",
      'websiteLogoServer': "",
      'adminPanelMainColor': Color(0xff3c7396).value.toString(),
      'adminPanelLogoLocal': "",
      'adminPanelLogoServer': "",

      'providerAreaMapLat' : 71.71436015411734,
      'providerAreaMapLng': 16.649089140202022,
      'providerAreaMapZoom' : 4,

    }, SetOptions(merge:true));

    dprint("Settings repaired");
  }catch(ex){
    return "repairSettings " + ex.toString();
  }
}
