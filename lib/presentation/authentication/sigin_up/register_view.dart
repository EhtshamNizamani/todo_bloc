import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/constant/app_color.dart';
import 'package:todo_bloc/presentation/authentication/sigin_in/sigin_up_screen.dart';
import 'package:todo_bloc/presentation/authentication/sigin_up/bloc/register_bloc.dart';
import 'package:todo_bloc/presentation/authentication/widget/auth_field.dart';
import 'package:todo_bloc/presentation/home/home_screen/home_screen.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is RegisterSuccess) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
            }
          },
          builder: (context, state) {
            return state is RegisterLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formKey,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50),
                          const Text('Create Account',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),

                          const SizedBox(height: 30),
                          // FullName.
                          AuthField(
                            title: 'Full Name',
                            hintText: 'Enter your name',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              } else if (!RegExp(r'^[a-zA-Z ]+ $')
                                  .hasMatch(value)) {
                                return 'Please enter a valid name';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),
                          // Email Field.
                          AuthField(
                            title: 'E-mail',
                            hintText: 'Enter your email address',
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!value.contains('@')) {
                                return 'Invalid email address';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),
                          // Password Field.
                          AuthField(
                            title: 'Password',
                            hintText: 'Enter your password',
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              } else if (value.length < 8) {
                                return 'Password should be at least 8 characters long';
                              }
                              return null;
                            },
                            isPassword: true,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 30),
                          PrimaryButton(
                            isLoading: state is RegisterLoading ? true : false,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<RegisterBloc>(context).add(
                                    RegisterUserEvent(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text));
                              }
                            },
                            text: 'Create An Account',
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignUpView()));
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: 'Login ',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class AgreeTermsTextCard extends StatelessWidget {
  const AgreeTermsTextCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: RichText(
        text: TextSpan(
          text: 'By signing up you agree to our ',
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.kGrey70),
          children: [
            TextSpan(
                text: 'Terms',
                recognizer: TapGestureRecognizer()..onTap = () {},
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kGrey100)),
            const TextSpan(
                text: ' and ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kGrey70)),
            TextSpan(
                text: 'Conditions of Use',
                recognizer: TapGestureRecognizer()..onTap = () {},
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.kGrey100)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CustomSocialButton extends StatefulWidget {
  final String icon;
  final VoidCallback onTap;
  const CustomSocialButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  State<CustomSocialButton> createState() => _CustomSocialButtonState();
}

class _CustomSocialButtonState extends State<CustomSocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          height: 48,
          width: 72,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFFF6F6F6),
            image: DecorationImage(image: AssetImage(widget.icon)),
          ),
        ),
      ),
    );
  }
}

class TextWithDivider extends StatelessWidget {
  const TextWithDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.kGrey60,
          ),
        ),
        SizedBox(width: 20),
        Text(
          'Or Sign In with',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.kGrey60,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Divider(color: AppColors.kGrey60),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? color;
  final bool isLoading;
  const PrimaryButton({
    required this.onTap,
    required this.text,
    this.isLoading = false,
    this.height,
    this.width,
    this.borderRadius,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: widget.isLoading
          ? CircularProgressIndicator()
          : ScaleTransition(
              scale: _tween.animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOut,
                  reverseCurve: Curves.easeIn,
                ),
              ),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Container(
                  height: widget.height ?? 50,
                  alignment: Alignment.center,
                  width: widget.width ?? double.maxFinite,
                  decoration: BoxDecoration(
                    color: widget.color ?? const Color(0xFFD1A661),
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 20),
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                        color: widget.color == null
                            ? AppColors.kWhite
                            : Colors.black,
                        fontSize: widget.fontSize ?? 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final double? fontSize;
  const CustomTextButton({
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.red,
          fontSize: fontSize ?? 14,
        ),
      ),
    );
  }
}

class RememberMeCard extends StatefulWidget {
  final Function(bool isChecked) onChanged;
  const RememberMeCard({required this.onChanged, super.key});

  @override
  State<RememberMeCard> createState() => _RememberMeCardState();
}

class _RememberMeCardState extends State<RememberMeCard> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isChecked
                    ? const Color(0xFFD1A661)
                    : const Color(0xFFE3E9ED),
                width: 2,
              ),
            ),
            child: _isChecked
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Color(0xFFD1A661),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Remember me',
          style: TextStyle(fontSize: 14, color: Color(0xFF78828A)),
        ),
      ],
    );
  }
}
