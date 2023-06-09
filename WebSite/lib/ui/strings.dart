import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../lang_listener.dart';
import '../theme.dart';

Lang strings = Lang();

class Lang {

  int languageVersion = 6;
  var direction = TextDirection.ltr;
  String locale = "en";

  Map<int, String> langEng = {
    0 : "HANDYMAN",
    1 : "View all",
    2 : "Providers",
    3 : "Phone",
    4 : "WWW",
    5 : "Instagram",
    6 : "Provider",
    7 : "Telegram",
    8 : "Monday",
    9 : "Tuesday",
    10 : "Wednesday",
    11 : "Thursday",
    12 : "Friday",
    13 : "Saturday",
    14 : "Sunday",
    15 : "Galleries",
    16 : "Services",
    17 : "Service",
    18 : "Top Services",
    19 : "Blog",
    20 : "Category",
    21 : "fixed",
    22 : "hourly",
    23 : "Addons",
    24 : "Duration",
    25 : "This service can take up to",
    26 : "min",
    27 : "Privacy Policy",
    28 : "About Us",
    29 : "Terms & Conditions",
    30 : "Search service",
    31 : "Search",
    32 : "Welcome. Please Login to continue",
    33 : "Email",
    34 : "Password",
    35 : "Remember me",
    36 : "Sign In",
    37 : "Username or password is incorrect",
    38 : "Permission denied",
    39 : "Forgot password?",
    40 : "Sign Out",
    41 : "or continue with",
    42 : "Reset password",
    43 : "Email",
    44 : "Send new password",
    45 : "Reset password email sent. Please check your mail.",
    46 : "Back to Login",
    47 : "Go back",
    48 : "Don't have account. Register",
    49 : "Register",
    50 : "in less than a minute",
    51 : "Name",
    52 : "Confirm Password",
    53 : "User don't create",
    54 : "Please Enter Email",
    55 : "Please enter password",
    56 : "Passwords are not equal",
    57 : "Email are wrong",
    58 : "Select Address",
    59 : "Verification",
    60 : "Phone number",
    61 : "We'll sent verification code.",
    62 : "CONTINUE",
    63 : "Enter your phone number",
    64 : "Enter code",
    65 : "We've sent 6 digit verification code.",
    66 : "Current address",
    67 : "Other addresses",
    68 : "Address not found",
    69 : "Add address",
    70 : "Find services near your",
    71 : "By allowing location access, you can search for services and providers near your.",
    72 : "Use currents location",
    73 : "Set from map",
    74 : "Latitude",
    75 : "Longitude",
    76 : "Pick here",
    77 : "Please enter address",
    78 : "Add the location",
    79 : "Label as",
    80 : "Home",
    81 : "Delivery Address",
    82 : "Office",
    83 : "Other",
    84 : "Contact name",
    85 : "Contact phone number",
    86 : "Save location",
    87 : "Please Enter name",
    88 : "Please enter phone",
    89 : "Book this service",
    90 : "Your address",
    91 : "Add new",
    92 : "Your address is outside provider work area",
    93 : "See details",
    94 : "Special Requests",
    95 : "Any Time",
    96 : "Schedule an Order",
    97 : "Select a Date & Time",
    98 : "Requested Service on",
    99 : "CLOSE",
    100 : "Please select address",
    101 : "Coupon Code",
    102 : "Coupon not found",
    103 : "Coupon has expired",
    104 : "Coupon not supported by this provider",
    105 : "Coupon not support this category",
    106 : "Coupon not support this service",
    107 : "Coupon activated",
    108 : "Quantity",
    109 : "Pricing",
    110 : "Coupon",
    111 : "no",
    112 : "Tax amount",
    113 : "Total",
    114 : "Requested Service on",
    115 : "Cash payment",
    116 : "CONFIRM & BOOKING NOW",
    117 : "From user:",
    118 : "New Booking was arrived",
    119 : "Thank you!",
    120 : "Your booking has been successfully submitted, you will receive a confirmation soon.",
    121 : "Ok",
    122 : "Please enter valid code",
    123 : "Account",
    124 : "Booking",
    125 : "Profile",
    126 : "Favorites",
    127 : "Notifications",
    128 : "My Address",
    129 : "Notifications not found",
    130 : "SAVE",
    131 : "Data saved",
    132 : "Change password",
    133 : "New password",
    134 : "Confirm New password",
    135 : "CHANGE PASSWORD",
    136 : "Enter Password",
    137 : "Enter Confirm Password",
    138 : "Passwords are not equal",
    139 : "Password changed",
    140 : "Favorites not found",
    141 : "Full address",
    142 : "Please tap on map for select location",
    143 : "Not found ...",
    144 : "Any Time",
    145 : "Code sent. Please check your phone for the verification code.",
    146 : "Your phone number verified. You can't edit phone number",
    147 : "Requested on",
    148 : "by administrator",
    149 : "by provider",
    150 : "by customer",
    151 : "Now status:",
    152 : "Booking status was changed",
    153 : "Rate this provider",
    154 : "Id",
    155 : "Back to bookings list",
    156 : "Time creation",
    157 : "Booking ID",
    158 : "Rate this service",
    159 : "Click on the stars to rate this service",
    160 : "Tell us something about this service",
    161 : "Add image",
    162 : "",
    163 : "Submit Review",
    164 : "You can add images",
    165 : "Please enter text",
    166 : "Search on ",
    167 : " or ",
    168 : "Filter",
    169 : "Sort by",
    170 : "Ascending (A-Z)",
    171 : "Descending (Z-A)",
    172 : "Nearby you",
    173 : "Far",
    174 : "Price",
    175 : "Reset Filter",
    176 : "Apply Filter",
    177 : "Payment cancel!",
    178 : "Your booking has been cancelled, you can making booking again.",
    179 : "Login",
    180 : "Current",
    181 : "Subtotal",
    182 : "Discount",
    183 : "Subcategory",
    184 : "Change avatar",
    185 : "Favorite Providers",
    186 : "Not available Now",
    187 : "Related products",
    188 : "See more",
    189 : "Sort by provider",
    190 : "Not select",
    191 : "Search service, provider or product",
    193 : "Products",
    194 : "Add to cart",
    195 : "in stock",
    196 : "Total amount",
    197 : "Please select variant",
    198 : "Product added to cart",
    199 : "This product already in the cart",
    200 : "My Cart",
    201 : "Proceed to checkout",
    202 : "Your cart in empty",
    203 : "Addons:",
    204 : "Quantity",
    205 : "Item price",
    206 : "Other products",
    207 : "Is there anything else",
    208 : "VAT/TAX",
    209 : "Search products",
    210 : "Provider products",
    211 : "Reviews & Ratings",
    212 : "Maximum purchase amount for this provider: ",
    213 : "Minimum purchase amount for this provider: ",
  };

  setLang(Map<String, dynamic> _def, String _locale, BuildContext context, TextDirection _direction){
    defaultLang = _def;
    locale = _locale;
    direction = _direction;
    Provider.of<LanguageChangeNotifierProvider>(context,listen:false).changeLocale(locale);
    theme = AppTheme();
  }

  Map<String, dynamic>? defaultLang;

  String get(int id){

    if (defaultLang == null) {
      return langEng[id] == null ? "" : langEng[id]!;
    }else{
      if (defaultLang![id.toString()] != null)
        return defaultLang![id.toString()];
      return langEng[id] == null ? "" : langEng[id]!;
    }
  }
}

