import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kraken_pokedex/src/core/extensions/context_extension.dart';
import 'package:kraken_pokedex/src/features/authentication/presentation/login/cubit/login_cubit.dart';
import 'package:kraken_pokedex/src/utils/constants/app_constants.dart';
import 'package:kraken_pokedex/src/utils/language/locale_keys.g.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            Fluttertoast.showToast(msg: state.message ?? LocaleKeys.unknown_error.tr());
          }
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: context.height * 0.05),
              Image.asset(key: const Key('login-image'), AppConstants.pokedexIcon.value, height: context.height * 0.35),
              Text(
                LocaleKeys.app_name.tr(),
                textAlign: TextAlign.center,
                style: context.theme.textTheme.headline3?.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              Expanded(
                child: BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    if (state == LoginSubmitting()) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LoginButton(
                          key: const Key('sign-in-with-facebook'),
                          onTap: () => context.read<LoginCubit>().signInWithFacebook(),
                          label: LocaleKeys.sign_in_with_facebook.tr(),
                          iconPath: AppConstants.facebookIcon,
                        ),
                        _LoginButton(
                          key: const Key('sign-in-with-google'),
                          onTap: () => context.read<LoginCubit>().signInWithGoogle(),
                          label: LocaleKeys.sign_in_with_google.tr(),
                          iconPath: AppConstants.googleIcon,
                        ),
                        TextButton(
                          key: const Key('sign-in-anonymously'),
                          onPressed: () => context.read<LoginCubit>().signInAnonymously(),
                          child: Text(
                            LocaleKeys.sign_in_with_anonymously.tr(),
                            style: context.theme.textTheme.bodySmall?.copyWith(color: context.theme.primaryColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onTap,
    required this.iconPath,
    required this.label,
    super.key,
  });
  final VoidCallback? onTap;
  final AppConstants iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath.value,
            height: context.extraHighIconSize,
            width: context.extraHighIconSize,
          ),
          SizedBox(width: context.normalPadding),
          Text(label),
        ],
      ),
    );
  }
}
