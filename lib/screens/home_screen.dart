import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_tile.dart';
import '../widgets/stats_card.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  final themeBloc = context.read<ThemeCubit>();
                  themeBloc.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodoError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is TodoLoaded) {
            return Column(
              children: [
                StatsCard(
                  total: state.todos.length,
                  completed: state.completedCount,
                  active: state.activeCount,
                ),
                _FilterBar(currentFilter: state.filter),
                Expanded(
                  child: state.filteredTodos.isEmpty
                      ? _EmptyState(filter: state.filter)
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: state.filteredTodos.length,
                          itemBuilder: (_, i) =>
                              TodoTile(todo: state.filteredTodos[i]),
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTodoScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final TodoFilter currentFilter;
  const _FilterBar({required this.currentFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<TodoFilter>(
        segments: const [
          ButtonSegment(value: TodoFilter.all, label: Text('All')),
          ButtonSegment(value: TodoFilter.active, label: Text('Active')),
          ButtonSegment(value: TodoFilter.completed, label: Text('Done')),
        ],
        selected: {currentFilter},
        onSelectionChanged: (s) =>
            context.read<TodoBloc>().add(FilterTodos(s.first)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TodoFilter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final messages = {
      TodoFilter.all: ('No tasks yet!', 'Tap + to add your first task'),
      TodoFilter.active: ('All done!', 'No active tasks remaining'),
      TodoFilter.completed: ('Nothing completed', 'Complete a task to see it here'),
    };
    final (title, subtitle) = messages[filter]!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist_rounded,
              size: 80, color: Theme.of(context).colorScheme.outline.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.outline)),
          Text(subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }
}
