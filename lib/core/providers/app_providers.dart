import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import all cubits
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/pets/presentation/bloc/pets_cubit.dart';
import '../../features/reports/presentation/bloc/reports_cubit.dart';
import '../../features/chat/presentation/bloc/chat_cubit.dart';
import '../../features/map/presentation/bloc/map_cubit.dart';
import '../../features/map/services/map_location_service.dart';

/// Provides all BLoC instances to the app
class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Cubit - Global state for authentication
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        
        // Pets Cubit - Global state for pets management
        BlocProvider<PetsCubit>(
          create: (context) => PetsCubit(),
        ),
        
        // Reports Cubit - Global state for reports
        BlocProvider<ReportsCubit>(
          create: (context) => ReportsCubit(),
        ),
        
        // Chat Cubit - Global state for chat
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        
        // Map Cubit - Global state for map
        BlocProvider<MapCubit>(
          create: (context) => MapCubit(MapLocationService()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // Listen to auth changes and update other cubits
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // User logged in - set user ID in other cubits
                context.read<PetsCubit>().setUserId(state.user.id);
                context.read<ReportsCubit>().setUserId(state.user.id);
                context.read<ChatCubit>().setUserId(state.user.id);
              } else if (state is AuthInitial) {
                // User logged out - reset other cubits
                context.read<PetsCubit>().reset();
                context.read<ReportsCubit>().reset();
              }
            },
          ),
        ],
        child: child,
      ),
    );
  }
}