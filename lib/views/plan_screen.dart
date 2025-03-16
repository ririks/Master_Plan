import 'package:master_plan/provider/plan_provider.dart';
import 'package:master_plan/models/plan.dart';
import 'package:master_plan/models/task.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  final Plan plan;
  const PlanScreen({super.key, required this.plan});

  @override
  State createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  Plan get plan => widget.plan;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Plan>> plansNotifier = PlanProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(plan.name)),
      body: ValueListenableBuilder<List<Plan>>(
        valueListenable: plansNotifier,
        builder: (context, plans, child) {
          Plan currentPlan = plans.firstWhere((p) => p.name == plan.name);
          return Column(
            children: [
              Expanded(child: _buildList(currentPlan)),
              SafeArea(child: Text(currentPlan.completenessMessage)),
            ],
          );
        },
      ),
      floatingActionButton: _buildAddTaskButton(context),
    );
  }

  Widget _buildAddTaskButton(BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Plan currentPlan = plan;
        int planIndex = planNotifier.value.indexWhere((p) => p.name == currentPlan.name);
        
        List<Task> updatedTasks = List<Task>.from(currentPlan.tasks)
          ..add(Task(description: '', complete: false)); // Set complete ke false

        planNotifier.value = List<Plan>.from(planNotifier.value)
          ..[planIndex] = Plan(
            name: currentPlan.name,
            tasks: updatedTasks,
          );

        planNotifier.notifyListeners(); // Tambahkan ini
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskTile(plan, plan.tasks[index], index, context);
      },
    );
  }

  Widget _buildTaskTile(Plan plan, Task task, int index, BuildContext context) {
    ValueNotifier<List<Plan>> planNotifier = PlanProvider.of(context);

    return ListTile(
      leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
          if (selected == null) return;

          int planIndex = planNotifier.value.indexWhere((p) => p.name == plan.name);

          List<Task> updatedTasks = List<Task>.from(plan.tasks);
          updatedTasks[index] = Task(
            description: task.description,
            complete: selected,
          );

          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: updatedTasks,
            );

          planNotifier.notifyListeners(); // Perubahan langsung diterapkan
        },
      ),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          int planIndex = planNotifier.value.indexWhere((p) => p.name == plan.name);

          List<Task> updatedTasks = List<Task>.from(plan.tasks);
          updatedTasks[index] = Task(
            description: text,
            complete: task.complete,
          );
          planNotifier.value = List<Plan>.from(planNotifier.value)
            ..[planIndex] = Plan(
              name: plan.name,
              tasks: updatedTasks,
            );

          planNotifier.notifyListeners(); // Perubahan langsung diterapkan
        },
      ),
    );
  }
}
