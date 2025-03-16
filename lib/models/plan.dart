import './task.dart';

class Plan {
  int get completedCount => tasks
  .where((task) => task.complete)
  .length;

String get completenessMessage =>
  '$completedCount out of ${tasks.length} tasks';


  final String name;
  final List<Task> tasks;
  
  const Plan({this.name = '', this.tasks = const []});
}

