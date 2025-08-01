import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/follow_bloc/follow_bloc.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimplifiedAccountWidget extends StatefulWidget {
  final int personalAccId;
  final SimplifiedAccountEntity account;
  final bool isGroupMembersPage;
  final bool updateGroupRole;
  final VoidCallback? onLongPress;

  const SimplifiedAccountWidget({
    super.key,
    required this.account,
    required this.personalAccId,
    this.isGroupMembersPage = false,
    this.updateGroupRole = false,
    this.onLongPress,
  });

  @override
  State<SimplifiedAccountWidget> createState() =>
      _SimplifiedAccountWidgetState();
}

class _SimplifiedAccountWidgetState extends State<SimplifiedAccountWidget> {
  late FollowStatus _followStatus;

  @override
  void initState() {
    super.initState();
    _followStatus = widget.account.followingStatus;
  }

  void _onFollowPressed() {
    context.read<FollowBloc>().add(
      ToggleFollowEvent(
        newStatus: _followStatus != FollowStatus.following,
        targetId: widget.account.id,
      ),
    );
  }

  Widget _buildFollowButton() {
    return BlocConsumer<FollowBloc, FollowState>(
      listener: (context, state) {
        if (state is DoneFollowState) {
          setState(() {
            _followStatus = state.newStatus;
          });
        } else if (state is FailedFollowState) {
          showCustomAboutDialog(
            context,
            AppLocalizations.of(context)!.error,
            state.failure.message,
            null,
            true,
          );
        }
      },
      builder: (context, state) {
        final secondaryColor = Theme.of(context).colorScheme.secondary;
        String btnTxt = "";
        Color btnColor =
            state is LoadingFollowState
                ? secondaryColor.withAlpha(100)
                : secondaryColor;

        FollowStatus currentStatus = _followStatus;
        if (state is DoneFollowState) {
          currentStatus = state.newStatus;
        }

        Function()? onPressed;

        if (currentStatus == FollowStatus.pending) {
          btnTxt = AppLocalizations.of(context)!.pending;
          onPressed = () => _onFollowPressed();
        } else if (currentStatus == FollowStatus.following) {
          btnTxt = AppLocalizations.of(context)!.unfollow;
          onPressed = () => _onFollowPressed();
        } else {
          // FollowStatus.notFollowing
          btnTxt =
              widget.account.isPrivate
                  ? AppLocalizations.of(context)!.requestToFollow
                  : AppLocalizations.of(context)!.follow;
          onPressed = () => _onFollowPressed();
        }

        if (state is FailedFollowState) {
          btnTxt = AppLocalizations.of(context)!.errorPleaseRefresh;
          onPressed = null;
          btnColor = btnColor.withAlpha(100);
        }

        return SizedBox(
          child: AppButton(
            bgColor: btnColor,
            onPressed: onPressed ?? () {},
            child: Text(
              btnTxt,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorByRole() {
    switch (widget.account.role) {
      case AccountRole.owner:
        return Colors.blueGrey.withAlpha(50);
      case AccountRole.admin:
        return Colors.deepOrangeAccent.withAlpha(50);
      case AccountRole.member:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getColorByRole(),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 0.1 * getHeight(context),
      child: GestureDetector(
        onTap:
            widget.personalAccId == widget.account.id
                ? null
                : () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.otherAccPage,
                    arguments: {
                      'personalAccountId': widget.personalAccId,
                      'otherAccountId': widget.account.id,
                    },
                  );
                },
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
          child: Row(
            children: [
              ProfilePicture(
                link: widget.account.avatar,
                role: widget.account.role,
                radius: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.account.fullName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(widget.account.accountName),
                  ],
                ),
              ),
              widget.isGroupMembersPage
                  ? Text(widget.account.role.name)
                  : (widget.personalAccId != widget.account.id)
                  ? _buildFollowButton()
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
