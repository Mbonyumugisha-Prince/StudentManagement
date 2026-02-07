class Student {
   final String first_name;
   final String last_name;
   final String email;
   final String password;
   final DateTime createdAt;


   Student ( {
     required this.first_name,
     required this.last_name,
     required this.email,
     required this.password,
     required this.createdAt,
});

Map<String, dynamic> toMap() =>  {
    'firstname' : first_name,
    'lastname' : last_name,
    'email' : email,
    'createdAt' : createdAt.toIso8601String(),


};
}




