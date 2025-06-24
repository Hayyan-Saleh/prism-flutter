import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/use-cases/account/get_local_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_remote_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_personal_account_usecase.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/widgets/personal_info_widget.dart';

class PersonalAccountPage extends StatefulWidget {
  const PersonalAccountPage({super.key});

  @override
  State<PersonalAccountPage> createState() => _PersonalAccountPageState();
}

class _PersonalAccountPageState extends State<PersonalAccountPage> {
  Widget _buildFollowersWidget(int count, BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        // TODO: LOCALIZE
        Text(
          "Followers",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        Text(count.toString(), style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildFollowingWidget(int count, BuildContext context) {
    return Column(
      children: [
        // TODO: LOCALIZE
        Text(
          "Following",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(count.toString(), style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildFirstSectionSkeleton({BuildContext? context}) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ProfilePicture(link: '', hasStatus: false),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [Text("Followers"), Text('')]),
                  Column(children: [Text("Following"), Text('')]),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '',
            style:
                context != null ? Theme.of(context).textTheme.titleLarge : null,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 16.0),
          child: Text(
            '',
            style:
                context != null
                    ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(150),
                    )
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstSection(BuildContext context) {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, state) {
        if (state is LoadedPAccountState) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ProfilePicture(
                        link: state.personalAccount.picUrl ?? '',
                        // TODO: check wrong json
                        // hasStatus: state.personalAccount.hasStatus == 'true',
                        hasStatus: true,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          _buildFollowersWidget(
                            state.personalAccount.followersCount,
                            context,
                          ),
                          _buildFollowingWidget(
                            state.personalAccount.followingCount,
                            context,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: Text(
                    state.personalAccount.accountName,

                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16.0, top: 8),
                  child: Text(
                    state.personalAccount.bio,

                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(150),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: PersonalInfoWidget(
                    userName: state.personalAccount.fullName,
                    personalInfo: state.personalAccount.personalInfos,
                    onToggleExpand: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return _buildFirstSectionSkeleton();
      },
    );
  }

  Widget _buildHighlightsSection(context) {
    // TODO: CREATE Status Bloc
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "Highlights",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      ProfilePicture(link: '', hasStatus: true),
                      Text(
                        "28/$index/24",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostsSection() {
    return Text("Posts Section");
  }

  Widget _wrapWithRefreshIndicator({
    required BuildContext context,
    required Widget child,
  }) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: () async {
        context.read<PAccountBloc>().add(LoadRemotePAccountEvent());
      },
      child: child,
    );
  }

  Widget _wrapWithProvider({required Widget child}) {
    return BlocProvider<PAccountBloc>(
      create:
          (context) =>
              _getPAccountBloc(context)..add(LoadRemotePAccountEvent()),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _wrapWithProvider(
      child: _wrapWithRefreshIndicator(
        context: context,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildFirstSection(context),
              _buildHighlightsSection(context),
              _buildPostsSection(),
              SizedBox(height: 1000),
            ],
          ),
        ),
      ),
    );
  }

  PAccountBloc _getPAccountBloc(BuildContext context) {
    return PAccountBloc(
      getLocalPersonalAccount: sl<GetLocalPersonalAccountUsecase>(),
      getRemotePersonalAccount: sl<GetRemotePersonalAccountUsecase>(),
      updatePersonalAccount: sl<UpdatePersonalAccountUsecase>(),
    );
  }
}
