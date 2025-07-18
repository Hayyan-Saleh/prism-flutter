import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/simplified_account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';

class StatusesSectionWidget extends StatefulWidget {
  const StatusesSectionWidget({super.key});

  @override
  State<StatusesSectionWidget> createState() => _StatusesSectionWidgetState();
}

class _StatusesSectionWidgetState extends State<StatusesSectionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatusBloc>().add(GetFollowingStatusesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            _buildAddStatusButton(context),
            _buildStatusesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddStatusButton(BuildContext context) {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, state) => _handlePAccountState(context, state),
    );
  }

  Widget _handlePAccountState(BuildContext context, PAccountState state) {
    if (state is LoadedPAccountState) {
      return GestureDetector(
        onTap: () => _navigateToAddStatus(context),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ProfilePicture(
                link: state.personalAccount.picUrl ?? "",
                radius: 40,
              ),
            ),
            _buildAddStatusIcon(context),
          ],
        ),
      );
    } else if (context.read<PAccountBloc>().pAccount != null) {
      final pAccount = context.read<PAccountBloc>().pAccount!;
      return GestureDetector(
        onTap: () => _navigateToAddStatus(context),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ProfilePicture(link: pAccount.picUrl ?? "", radius: 36),
            ),
            _buildAddStatusIcon(context),
          ],
        ),
      );
    }
    return _buildDefaultProfilePicture();
  }

  void _navigateToAddStatus(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addStatusPage);
  }

  Widget _buildAddStatusIcon(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDefaultProfilePicture() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: ProfilePicture(link: "", radius: 36),
    );
  }

  Widget _buildStatusesList(BuildContext context) {
    return BlocBuilder<StatusBloc, StatusState>(
      builder: (context, state) => _handleStatusState(context, state),
    );
  }

  Widget _handleStatusState(BuildContext context, StatusState state) {
    if (state is FollowingStatusLoaded) {
      return Row(
        spacing: 8,
        children:
            state.simpleAccounts
                .asMap()
                .entries
                .map(
                  (entry) => _buildStatusProfilePicture(
                    context,
                    entry.value,
                    entry.key,
                    state.simpleAccounts,
                  ),
                )
                .toList(),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatusProfilePicture(
    BuildContext context,
    SimplifiedAccountEntity account,
    int index,
    List<SimplifiedAccountEntity> accounts,
  ) {
    return GestureDetector(
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRoutes.followingStatusesPage,
            arguments: {
              'userIds': accounts.map((e) => e.id).toList(),
              'initialUserIndex': index,
            },
          ),
      child: ProfilePicture(link: account.avatar, hasStatus: true, radius: 36),
    );
  }
}
