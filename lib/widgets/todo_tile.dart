import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../models/todo.dart';
import '../screens/add_todo_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  Color _priorityColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    switch (todo.priority) {
      case 0:
        return Colors.green;
      case 2:
        return colors.error;
      default:
        return Colors.orange;
    }
  }

  String _priorityLabel() {
    switch (todo.priority) {
      case 0:
        return 'Low';
      case 2:
        return 'High';
      default:
        return 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        key: ValueKey(todo.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTodoScreen(todo: todo)),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: (_) =>
                  context.read<TodoBloc>().add(DeleteTodo(todo.id)),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: GestureDetector(
              onTap: () => context.read<TodoBloc>().add(ToggleTodo(todo.id)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: todo.isCompleted
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: todo.isCompleted
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                color: todo.isCompleted ? theme.colorScheme.outline : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: todo.description != null && todo.description!.isNotEmpty
                ? Text(
                    todo.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.colorScheme.outline),
                  )
                : null,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _priorityColor(context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _priorityLabel(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _priorityColor(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
