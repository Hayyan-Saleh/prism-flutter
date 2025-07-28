import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_group_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/join_group_bloc/join_group_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SimplifiedGroupWidget extends StatefulWidget {
  final bool applyJoin;
  final SimplifiedGroupEntity group;
  final Function(BuildContext context) trigger;

  const SimplifiedGroupWidget({
    super.key,
    required this.group,
    required this.applyJoin,
    required this.trigger,
  });

  @override
  State<SimplifiedGroupWidget> createState() => _SimplifiedGroupWidgetState();
}

class _SimplifiedGroupWidgetState extends State<SimplifiedGroupWidget> {
  late JoinStatus _joinStatus;

  @override
  void initState() {
    super.initState();
    _joinStatus = widget.group.joinStatus;
  }

  void _onJoinPressed() {
    context.read<JoinGroupBloc>().add(
      ToggleJoinGroupEvent(
        groupId: widget.group.id,
        join: _joinStatus != JoinStatus.joined,
      ),
    );
  }

  Widget _buildJoinButton() {
    return BlocConsumer<JoinGroupBloc, JoinGroupState>(
      listener: (context, state) {
        if (state is JoinGroupSuccess) {
          setState(() {
            _joinStatus = state.newStatus;
          });
          widget.trigger(context);
        } else if (state is JoinGroupFailure) {
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
            state is JoinGroupLoading
                ? secondaryColor.withAlpha(100)
                : secondaryColor;

        JoinStatus currentStatus = _joinStatus;
        if (state is JoinGroupSuccess) {
          currentStatus = state.newStatus;
        }

        Function()? onPressed;

        if (currentStatus == JoinStatus.pending) {
          btnTxt = AppLocalizations.of(context)!.pending;
          onPressed = () => _onJoinPressed();
        } else if (currentStatus == JoinStatus.joined) {
          btnTxt = 'Leave';
          onPressed = () => _onJoinPressed();
        } else {
          btnTxt = 'Join';
          onPressed = () => _onJoinPressed();
        }

        if (state is JoinGroupFailure) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.groupPage,
          arguments: {'groupId': widget.group.id},
        );
      },
      child: ListTile(
        leading: _buildCachedImage(widget.group.avatar ?? ''),
        title: Text(widget.group.name),
        subtitle: Text(widget.group.privacy),
        trailing:
            widget.applyJoin
                ? _buildJoinButton()
                : Text('${widget.group.membersCount} Members'),
      ),
    );
  }

  Widget _buildCachedImage(String link) {
    return SizedBox(
      height: 70,
      width: 70,
      child: CachedNetworkImage(
        imageUrl: link,
        imageBuilder:
            (context, imageProvider) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(image: imageProvider, fit: BoxFit.cover),
            ),
        placeholder:
            (context, url) => const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator(strokeWidth: 4)),
            ),
        errorWidget:
            (context, url, error) => const SizedBox(
              height: 100,
              width: 100,
              child: Center(child: Icon(Icons.error)),
            ),
      ),
    );
  }
}
