import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/data/models/user_model.dart';
import 'package:myapp/features/auth/domain/entities/user.dart';
import 'package:myapp/features/auth/presentation/widgets/change_email_dialog.dart';

import '../bloc/auth_cubit.dart';
import '../widgets/auto_logout_dialog.dart';
import '../widgets/confirmation_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String newEmail;
  late User currentUser;
  final TextEditingController _nameController = TextEditingController(
    text: 'Guest User',
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(
    text: '+1 234 567 890',
  );
  final TextEditingController _locationController = TextEditingController(
    text: 'Ville, Pays',
  );
  @override
  void initState() {
    super.initState();
    newEmail = "";
    currentUser = UserModel.empty();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      _emailController.text = authState.user.email;
      _nameController.text = authState.user.name;
      context.read<AuthCubit>().getUserById(authState.user.id);
      //_phoneController.text = authState.user.phone;
      //_locationController.text = authState.user.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Builder(
                  builder: (context) {
                    final authState = context.read<AuthCubit>().state;
                    bool isAuth = authState is AuthSuccess;

                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF008080),
                      child: Text(
                        isAuth ? authState.user.name[0].toUpperCase() : 'G',
                        style: TextStyle(fontSize: 60, color: Colors.white),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF003366),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        // Handle image change
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Press to change',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildTextField(
              controller: _nameController,
              label: 'Complete name',
              icon: Icons.person_outline,
              onClick : (value){},
                onChange : (value){}
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
                onClick : (value){
                  showDialog(
                      context: context,
                      builder: (context){
                        return ChangeEmailDialog(onChangeEmail: (newEmail, password) async{
                          setState(() {
                            this.newEmail = newEmail;
                          });
                          context.read<AuthCubit>().changeEmail(newEmail, password);
                          Navigator.pop(context);
                        });
                      }
                  );
                },
              onChange: (value){}
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if(state is AuthSuccess){
                  currentUser = state.user;
                  setState(() {
                    _phoneController.text = currentUser.phoneNumber!;
                  });
                }
                if (state is EmailChangedSuccessfully) {
                  // The SnackBar is good, let's keep it.
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email change initiated successfully')),
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: false, // User cannot dismiss it by tapping outside
                    builder: (dialogContext) {
                      // Provide the AuthCubit to the dialog's context tree
                      return BlocProvider.value(
                        value: context.read<AuthCubit>(),
                        child: const AutoLogoutDialog(
                          title: 'Vérifiez vos e-mails',
                          content: 'Un lien de confirmation a été envoyé. Après avoir vérifié votre nouvelle adresse, vous serez déconnecté pour vous reconnecter.',
                          buttonText: 'Compris',
                          countdownFrom: 10, // The countdown will start from 10 seconds
                        ),
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                return const SizedBox.shrink(); // Use shrink to take no space
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              label: 'Téléphone',

              icon: Icons.phone_outlined,
                onClick : (value){},
              onChange: (value){
                var currentUserModel = UserModel.fromEntity(currentUser);
                var updatedUser = currentUserModel.copyWith(phoneNumber: value);
                context.read<AuthCubit>().updateUser(updatedUser);
              }
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _locationController,
              label: 'Localisation',
              icon: Icons.location_on_outlined,
                onClick : (value){},
              onChange: (value){
                  var currentUserModel = UserModel.fromEntity(currentUser);
                  var updatedUser = currentUserModel.copyWith(location: value);
                  context.read<AuthCubit>().updateUser(updatedUser);
              }
            ),
            const SizedBox(height: 40),
            /*ElevatedButton(
              onPressed: () {
                // Handle save
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sauvegarder'),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String newValue) onClick,
    required Function(String newValue) onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black26),
            ),
            filled: true,
            fillColor: const Color.fromARGB(82, 255, 255, 255),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black26),
            ),
          ),
          onTap: (){
            onClick(controller.text);
          },
          onChanged: (value){
            onChange(value);

          },
        ),
      ],
    );
  }
}
