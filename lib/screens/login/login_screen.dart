// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kifinserv/controller/login/login_controller.dart';


// class LoginScreen extends GetView<LoginController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(
//               controller: controller.emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: controller.passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: controller.login,
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
